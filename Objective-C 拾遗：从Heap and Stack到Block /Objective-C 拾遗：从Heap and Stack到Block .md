# Objective-C 拾遗：从Heap and Stack到Block


## Stack和Heap
heap和stack是内存管理的两个重要概念。在这里我们指的不是数据结构上面的堆与栈,在这里指的是内存的分配区域。

1. stack的空间由操作系统进行分配。

	在现代操作系统中,一个线程会分配一个stack.
当一个函数被调用,一个stack frame(栈帧)就会被压到stack里。里面包含这个函数涉及的参数,局部变量,返回地址等相关信息。当函数返回后,这个栈帧就会被销毁。而这一切都是自动的,由系统帮我们进行分配与销毁。对于程序员是透明的,我们不需要手动调度。

2. heap的空间需要手动分配。

	heap与动态内存分配相关,内存可以随时在堆中分配和销毁。我们需要明确请求内存分配与内存销毁。
	简单来说，就是malloc与free.
	
## Objective-C中的Stack和Heap

首先所有的Objective-C对象都是分配在heap的。
在OC最典型的内存分配与初始化就是这样的。

~~~objective-c
    NSObject *obj = [[NSObject alloc] init];
~~~
一个对象在alloc的时候，就在Heap分配了内存空间。

stack对象通常有速度的优势，而且不会发生内存泄露问题。那么为什么OC的对象都是分配在heap的呢？
原因在于：

1. stack对象的生命周期所导致的问题。例如一旦函数返回，则所在的stack frame就会被摧毁。那么此时返回的对象也会一并摧毁。这个时候我们去retain这个对象是无效的。因为整个stack frame都已经被摧毁了。简单而言，就是stack对象的生命周期不适合Objective-C的引用计数内存管理方法。

2. stack对象不够灵活，不具备足够的扩展性。创建时长度已经是固定的,而stack对象的拥有者也就是所在的stack frame


## 关于Block
### 问题的由来：
洋洋洒洒讲了前面这些东西,其实为什么决定写这篇总结呢,简单讲讲最初的问题。  

那就是在之前我在类中声明block属性时,一直用的是strong修饰符。因为我一直把block当成一个普通的OC对象来看待。并且也没有出现过问题。后来阅读一些别人的源代码和博客,发现不少人都是使用copy修饰符,于是引起了这篇探索。可以简单地把这个问题总结为：为什么block需要使用copy修饰符？

### 简单的答案：

首先在官方文档《Programming with Objective-C》里面写到,初学阅读的时候没有注意到这个细节：
> You should specify copy as the property attribute, because a block needs to be copied to keep track of its captured state outside of the original scope. This isn’t something you need to worry about when using Automatic Reference Counting, as it will happen automatically, but it’s best practice for the property attribute to show the resultant behavior

在这里官方叫我们使用copy修饰符,虽然在ARC时代已经不需要再显式声明了,也就是使用strong是没有问题的,但是仍然建议我们使用copy以显示相关拷贝行为。问题到这里就基本结束了。目前使用strong和copy都是没有问题的。

### 深入探索：

但是在这里仍然无法解答我的疑惑,需要使用copy修饰符的根本原因是什么。所以继续探索。

最终得到的答案是这与block对象在创建时是stack对象有关。  
所以,其实Objective-C是有它的Stack object的。是的,那就是block.

首先我们先对block进行进一步的认识。

> 在Objective-C语言中，一共有3种类型的block：
> 
>_NSConcreteGlobalBlock 全局的静态block，不会访问任何外部变量。
>
>_NSConcreteStackBlock 保存在栈中的block，当函数返回时会被销毁。
>
>_NSConcreteMallocBlock 保存在堆中的block，当引用计数为0时会被销毁。

这里我们主要基于内存管理的角度对它们进行分类。

- NSConcreteGlobalBlock,这种不捕捉外界变量的block是不需要内存管理的,这种block不存在于Heap或是Stack而是作为代码片段存在,类似于C函数。

- NSConcreteStackBlock。这就是这次探索的重点了,需要涉及到外界变量的block在创建的时候是在stack上面分配空间的,也就是一旦所在函数返回,则会被摧毁。这就导致内存管理的问题,如果我们希望保存这个block或者是返回它,如果没有做进一步的copy处理,则必然会出现问题。

举个栗子(来自参考资料block quiz),在手动管理引用计数时,如果在exampleD_getBlock方法返回block时对block进行[[block copy] autorelease]的操作,则方法执行完毕后,block就会被销毁，则返回block是无效的。

~~~objective-c 
typedef void (^dBlock)();
 
dBlock exampleD_getBlock() {
  char d = 'D';
  return ^{
    printf("%c\n", d);
  };
}
 
void exampleD() {
  exampleD_getBlock()();
}
~~~

- NSConcreteMallocBlock,因此为了解决block作为Stack object的这个问题,我们最终需要把它拷贝到堆上面来。而此时NSConcreteMallocBlock扮演的就是这个角色。

	拷贝到堆后,block的生命周期就与一般的OC对象一样了,我们通过引用计数来对其进行内存管理。

### 真正的答案：	

因此答案便是因为block在创建时是stack对象,如果我们需要在离开当前函数仍能够使用我们创建的block。我们就需要把它拷贝到堆上以便进行以引用计数为基础的内存管理。

### ARC的疑团：

解答完最初的问题后,新的问题又出现在我的脑海。那就是ARC是如何进行block的内存管理的呢,对于普通的OC对象之前已经在[内存管理](https://github.com/100mango/zen/blob/master/iOS%E5%A4%AF%E5%AE%9E%EF%BC%9A%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/iOS%E5%A4%AF%E5%AE%9E%EF%BC%9A%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86.md)里面进行总结过。

那么block在ARC下是如何从栈管理正确过渡到堆的管理的呢：

我在网上查阅了许多资料与博文,有部分总结是：
> 在ARC下NSConcreteStackBlock类型的block会替换成NSConcreteMallocBlock类型

其实这是不够准确的,来自苹果LLVM ARC的文档中谈到：
> With the exception of retains done as part of initializing a __strong parameter variable or reading a __weak variable, whenever these semantics call for retaining a value of block-pointer type, it has the effect of a Block_copy. The optimizer may remove such copies when it sees that the result is used only as an argument to a call.

也就是说ARC帮助我们完成了copy的工作,在ARC下,即使你声明的修饰符是strong,实际上效果是与声明为copy一样的。

因此在ARC情况下,创建的block仍然是NSConcreteStackBlock类型,只不过当block被引用或返回时,ARC帮助我们完成了copy和内存管理的工作。

### 总结和心得：
其实用一句话总结便是：  
在ARC下,我们可以将block看做一个正常的OC对象,与其他对象的内存管理没什么不同。

有时我们可能简单地从博客和文档上面得到一句简单的结论就够了。但是如果我们不断探索，不断思考,那么我们的收获会更大,更深。可能不仅仅是一句知识点,更多的是探索的方法和过程。对一件事情剥茧抽丝,还原本质的过程对我来说也是一种享受,一种修行。

经过了一系列探索,最终理解了block的概念,了解了block的实现,弄懂了block的内存管理。  
加油,继续修行~

-
#### 参考资料:

[What and where are the stack and heap?](http://stackoverflow.com/questions/79923/what-and-where-are-the-stack-and-heap)

[Cocoa blocks as strong pointers vs copy](http://stackoverflow.com/questions/27152580/cocoa-blocks-as-strong-pointers-vs-copy)

[Should I still copy/Block_copy the blocks under ARC?](http://stackoverflow.com/questions/23334863/should-i-still-copy-block-copy-the-blocks-under-arc)

[Stack and Heap Objects in Objective-C](https://www.mikeash.com/pyblog/friday-qa-2010-01-15-stack-and-heap-objects-in-objective-c.html)

[谈Objective-C Block的实现
](http://blog.devtang.com/blog/2013/07/28/a-look-inside-blocks/)

[Objective-C Blocks Quiz](http://blog.parse.com/2013/02/05/objective-c-blocks-quiz/)

#Objective-C 拾遗：从Heap and Stack到Block


##Stack和Heap
heap和stack是内存管理的两个重要概念。在这里我们指的不是数据结构上面的堆与栈,在这里指的是内存的分配区域。

1. stack的空间由操作系统进行分配。

	在现代操作系统中,一个线程会分配一个stack.
当一个函数被调用,一个stack frame(栈帧)就会被压到stack里。里面包含这个函数涉及的参数,局部变量,返回地址等相关信息。当函数返回后,这个栈帧就会被销毁。而这一切都是自动的,由系统帮我们进行分配与销毁。对于程序员是透明的,我们不需要手动调度。

2. heap的空间需要手动分配。

	heap与动态内存分配相关,内存可以随时在堆中分配和销毁。我们需要明确请求内存分配与内存销毁。
	简单来说，就是malloc与free.
	
[^1]: (What and where are the stack and heap?)[http://stackoverflow.com/questions/79923/what-and-where-are-the-stack-and-heap]

##Objective-C中的Stack和Heap

首先所有的Objective-C对象都是分配在heap的。
在OC最典型的内存分配与初始化就是这样的。

~~~objective-c
    NSObject *obj = [[NSObject alloc] init];
~~~
一个对象在alloc的时候，就在Heap分配了内存空间。

stack对象通常有速度的优势，而且不会发生内存泄露问题。那么为什么OC的对象都是分配在heap的呢？
原因在于：

1. stack对象的生命周期所导致的问题。例如一旦函数返回，则所在的stack frame就会被摧毁。那么此时返回的对象也会一并摧毁。这个时候我们去retain这个对象也无补于事。因为整个stack frame都已经被摧毁了。简单而言，就是stack对象的生命周期不适合Objective-C的引用计数内存管理方法。

2. stack对象不够灵活，不具备足够的扩展性。创建时长度已经是固定的,而stack对象的拥有者也就是所在的stack frame


##关于Block
洋洋洒洒讲了前面这些东西,其实为什么决定写这篇总结呢,简单讲讲最初的问题。  

那就是在之前我在类中声明block属性时,一直用的是strong修饰符。因为我一直把block当成一个普通的OC对象。也没有出现问题。后来阅读一些别人的源代码和博客,发现不少人都是使用copy修饰符,于是引起了这篇探索。可以简单地把这个问题总结为：为什么block需要使用copy修饰符？


首先在官方文档《Programming with Objective-C》里面写到,初学阅读的时候没有注意到这个细节：
> You should specify copy as the property attribute, because a block needs to be copied to keep track of its captured state outside of the original scope. This isn’t something you need to worry about when using Automatic Reference Counting, as it will happen automatically, but it’s best practice for the property attribute to show the resultant behavior

在这里官方叫我们使用copy修饰符,虽然在ARC时代已经不需要再显式声明了,也就是使用strong是没有问题的,但是仍然建议我们使用copy以显示相关行为。

但是在这里仍然无法解答我的疑惑。所以继续探索。

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

我们


-
####参考资料:

[What and where are the stack and heap?](http://stackoverflow.com/questions/79923/what-and-where-are-the-stack-and-heap)

[Cocoa blocks as strong pointers vs copy](http://stackoverflow.com/questions/27152580/cocoa-blocks-as-strong-pointers-vs-copy)

[Should I still copy/Block_copy the blocks under ARC?](http://stackoverflow.com/questions/23334863/should-i-still-copy-block-copy-the-blocks-under-arc)

[Stack and Heap Objects in Objective-C](https://www.mikeash.com/pyblog/friday-qa-2010-01-15-stack-and-heap-objects-in-objective-c.html)

[谈Objective-C Block的实现
](http://blog.devtang.com/blog/2013/07/28/a-look-inside-blocks/)

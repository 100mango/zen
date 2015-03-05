#iOS夯实：内存管理

> 最近的学习计划是将iOS的机制原理好好重新打磨学习一下,总结和加入自己的思考。
> 
> 有不正确的地方，多多指正。

##基本信息
###Objective-C 提供了两种内存管理方式。

1. MRR （manual retain-release） 手动内存管理  
	这是基于reference counting实现的,由NSObject与runtime environment共同工作实现。
	
2. ARC （Automatic Reference Counting）自动引用技术  
 	ARC使用了基于MBR同样的reference counting机制，区别在于系统在编译的时候帮助我们插入了合适的memory management method。
 	
###Good Practices能有效的避免内存相关问题
基于内存，主要有两种错误 
 
1. 清空或覆盖了还在使用的内存  
	这种清空通常会导致应用崩溃，甚至用户数据遭到改写  
2. 没有清空已经不需要的内存会导致内存泄露  
   会导致系统性能下降，应用遭到系统终止
 
实际上，我们不应该只从reference counting的角度来管理内存，这样会让我们纠结于底层细节。我们应该站在object ownership and object graphs的角度来管理内存

可以用一幅这样的图来阐明：

![](memory_management.png)

#旧时代的细节
##一.基本内存管理准则
###基本的内存管理准则：Cocoa为我们提供了这些准则

-  You own any object you create  
	我们通过名字前缀为“alloc”, “new”, “copy”, or “mutableCopy”的方法创建对象
	
- You can take ownership of an object using retain  
  通过retain来获取对象的ownership,使用retain主要有两种场景  
  1. 在accessor method 或 init method。来获取你想存储的对象的所有权
  2. 在某些场景里避免一个对象被移除，我们可以对它进行retain

- When you no longer need it, you must relinquish ownership of an object you own  
  当我们需要释放一个对象所有权时,我们通过对它发送release或autorelaese消息。
  
- You must not relinquish ownership of an object you do not own  
  不要释放你没有拥有的对象所有权
  
###关于dealloc:
 
 NSObject为我们提供了一个dealloc方法,当对象被销毁时，系统会自动调用它。这个方法的作用主要是清空对象自身内存与它所持有的资源。例如：
 
 ~~~objective-c
 @interface Person : NSObject
@property (retain) NSString *firstName;
@property (retain) NSString *lastName;
@property (assign, readonly) NSString *fullName;
@end
~~~
~~~
@implementation Person
- (void)dealloc
    [_firstName release];
    [_lastName release];
    [super dealloc];
}
@end
 ~~~
 
***需要强调的是：永远不要自己调用dealloc方法***  
***在dealloc的最后需要调用super class的dealloc***

##二.实践中的内存管理准则
###1. 使用存取方法来简化内存管理。  
	如果代码中都是一堆retain release，必然不是一个好的情况。在存取方法里面进行retain和release的操作能够简化内存管理。例如：
	
~~~objective-c
- (void)setCount:(NSNumber *)newCount {
    [newCount retain];
    [_count release];
    // Make the new assignment.
    _count = newCount;
}
~~~

###2. 使用存取方法来设置Property value

对比如下代码，第一种使用了存取方法来设置，第二种直接对实例变量操作。显然我们应该采用第一种，使用第二种情况，简单的情况还好，如果情况一旦复杂,就非常容易出错。并且直接对实例变量操作，不会引发KVO通知。

~~~objective-c
- (void)reset {
    NSNumber *zero = [[NSNumber alloc] initWithInteger:0];
    [self setCount:zero];
    [zero release];
}

- (void)reset {
    NSNumber *zero = [[NSNumber alloc] initWithInteger:0];
    [_count release];
    _count = zero;
}
~~~

###3. 不要在初始化方法和dealloc方法中使用Accessor Methods

  唯一不需要使用Accessor Methods的地方是initializer和dealloc.
  在苹果官方文档中没有解释为什么。经过一番查阅后,最主要的原因是此时对象的状况不确定，尚未完全初始化完毕，而导致一些问题的发送。
  
  例如这个类或者子类重写了setMethod,里面调用了其他一些数据或方法,而这些数据和方法需要一个已经完全初始化好的对象。而在init中,对象的状态是不确定的。
  
  举个例子，一个子类重写了set方法，在里面进行了一些子类特有的操作，而此时如果父类在init直接使用Accessor Methods，就会导致问题的发送。
  
  其它一些问题还有，像会触发KVO notification等。[^1][^2]
  
  ***总之，记住在开发中记住这个principle最重要。***
  
[^1]: [stackoverflow](http://stackoverflow.com/questions/8056188/should-i-refer-to-self-property-in-the-init-method-with-arc/8056260#8056260)
[^2]: [objc-zen-book](https://github.com/objc-zen/objc-zen-book)

###4. 使用弱引用来避免引用环

我们都知道在ARC，弱引用通过声明property的attribute为weak来实现。  

而在MRR中则是通过引用对象，但是不retain它来实现（A weak reference is a non-owning relationship where the source object does not retain the object to which it has a reference）

在Cocoa中，典型需要使用弱引用的有delegate，data source, notification observer

我们需要注意处理好弱引用对象，如果对已经被销毁的对象发送信息，则会导致crash.通常被弱引用的对象当它将被销毁时，负责通知其它object.

像notification center保存了observer的弱引用，因此当被弱引用observer准备结束生命周期时，observer需要通知notification center,unregister自己。

###4. 不要让你正在使用的对象被移除

观察以下两种代码，第一种因为没有retain,对象可能会被移除，而第二种是正确的写法

~~~objective-c
heisenObject = [array objectAtIndex:n];
[array removeObjectAtIndex:n];
// heisenObject could now be invalid.

heisenObject = [[array objectAtIndex:n] retain];
[array removeObjectAtIndex:n];
// Use heisenObject...
[heisenObject release];
~~~

###5. Collections类拥有其收集的的对象的所有权

例如NSArray,dictionary等。他们负责其收集的对象的所有权,因此我们不需要retain存进去的对象。
例如下面的allocedNumber就不需要retain了。

~~~objective-c
for (i = 0; i < 10; i++) {
    NSNumber *allocedNumber = [[NSNumber alloc] initWithInteger:i];
    [array addObject:allocedNumber];
    [allocedNumber release];
}
~~~

###6. 最后,以上这些ownership policy是基于retain count实现的

- 当你创建一个对象，它的retain count为1。
- 当你对一个对象发送retain信息，它的retain count +1 
- 当你对一个对象发送release信息，他的retain count -1  
  当你对一个对象发送autorelease信息，在当前autorelease pool block结束时，retain count -1
- 当一个对象的retain count 降至0，它就被dealloced了。


##三.使用Autorelease Pool block

autorelease pool 为我们提供了一个机制，避免当我们解除一个对象所有权时,对象被立刻销毁（例如从一个方法里返回一个对象）

一个autorelease pool block对象是这样子的：

~~~objective-c
@autoreleasepool {
    // Code that creates autoreleased objects.
}
~~~
在block的最后，所有收到过autorelease消息的对象都会接收到release消息。

在ARC的新时代里面，autorelease pool block主要用于处理避免内存峰值，只是我们不需要再手动添加autorelease的代码了

例如以下这个例子（有点生编硬造，主要为了阐明一下）  
如果我们没有添加autoreleasepool,我们最后可需要释放10000*10000个对象，而不是每次循环都分别释放掉10000个对象

~~~objective-c
- (void)useALoadOfNumbers {
    for (int j = 0; j < 10000; ++j) {
        @autoreleasepool {
            for (int i = 0; i < 10000; ++i) {
                NSNumber *number = [NSNumber numberWithInt:(i+j)];
                NSLog(@"number = %p", number);
            }
        }
    }
}
~~~

#新时代

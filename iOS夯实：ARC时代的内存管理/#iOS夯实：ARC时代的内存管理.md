#iOS夯实：ARC时代的内存管理




##什么是ARC
> Automatic Reference Counting (ARC) is a compiler feature that provides automatic memory management of Objective-C objects. Rather than having to think about retain and release operations [^1]

[^1]: [Transitioning to ARC Release Notes](https://developer.apple.com/library/mac/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html)
  
ARC提供是一个编译器的特性，帮助我们在编译的时候自动插入管理引用计数的代码。  
最重要的是我们要认识到ARC的本质仍然是通过引用计数来管理内存。因此有时候如果我们操作不当,仍然会有内存泄露的危险。下面就总结一下ARC时代可能出现内存泄露的场景。


##内存泄露类型

1. 循环引用

	基于引用计数的内存管理机制无法绕过的一个问题便是循环引用（retain cycle）  
	(Python同样也采用了基于引用计数的内存管理,但是它采用了另外的机制来清除引用循环导致的内存泄露，而OC和Swift需要我们自己来处理这样的问题[^2])
	- 对象之间的循环引用：使用弱引用避免
	- block与对象之间的循环引用：

	会导致Block与对象之间的循环引用的情况有：
	
	~~~objective-c
	self.myBlock = ^{ self.someProperty = XXX; };  
	~~~
	
	对于这种Block与Self直接循环引用的情况,编译器会给出提示。
	
	但是对于有多个对象参与的情况,编译器便无能为力了,因此涉及到block内使用到self的情况,我们需要非常谨慎。（推荐涉及到self的情况,如果自己不是非常清楚对象引用关系,统一使用解决方案处理）
	
	~~~objective-c
	someObject.someBlock = ^{ self.someProperty = XXX; }; //还没有循环引用 
	self.someObjectWithBlock = someObject; // 导致循环引用,且编译器不会提醒
	~~~
	
	解决方案：
	
	~~~objective-c
	__weak SomeObjectClass *weakSelf = self;

	SomeBlockType someBlock = ^{
		SomeObjectClass *strongSelf = weakSelf;
    	if (strongSelf == nil) {
        // The original self doesn't exist anymore.
        // Ignore, notify or otherwise handle this case.
    	}
    	[strongSelf someMethod];
	};
	~~~
	
	我们还有一种更简便的方法来进行处理,实际原理与上面是一样的,但简化后的指令更易用。
	
	~~~objective-c
@weakify(self)
[self.context performBlock:^{
    // Analog to strongSelf in previous code snippet.
    @strongify(self)

    // You can just reference self as you normally would. Hurray.
    NSError *error;
    [self.context save:&error];

    // Do something
}];
~~~
	你可以在这里找到@weakify,@strongify工具：[MyTools_iOS](https://github.com/100mango/MyTools_iOS)
	
[^2]: [How does Python deal with retain cycles?](http://www.quora.com/How-does-Python-deal-with-retain-cycles)

2. NSTimer

	一般情况下在action/target模式里 target一般都是被weak引用,除了NSTimer。
	
	~~~objective-c
	+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                            target:(id)target
                          selector:(SEL)aSelector
                          userInfo:(id)userInfo
                           repeats:(BOOL)repeats
	~~~
	在官方文档中：
	> target	
	The object to which to send the message specified by aSelector when the timer fires. The timer maintains a strong reference to this object until it (the timer) is invalidated.
	
	Timer Programming Topics :
	> A timer maintains a strong reference to its target. This means that as long as a timer remains valid, its target will not be deallocated. As a corollary, this means that it does not make sense for a timer’s target to try to invalidate the timer in its dealloc method—the dealloc method will not be invoked as long as the timer is valid.


	
	举一个例子，一个Timer的Target是ViewController.
	
	这个时候，如果我们是在dealloc方法里让timer invalidate，就会造成内存泄露.
	
	事实上，timer是永远不会被invalidate.因为此时VC的引用计数永远不会为零。因为Timer强引用了VC。而因为VC的引用计数不为零,dealloc永远也不会被执行，所以Timer永远持有了VC.
	
	因此我们需要注意在什么地方invalidate计时器，我们可以在viewWillDisappear里面做这样的工作。
	

##Swift's ARC

在Swift中,ARC的机制与Objective-C基本是一致的。

相对应的解决方案：

- 对象之间的循环引用：使用弱引用避免

~~~swift
protocol aProtocol:class{}

class aClass{
    weak var delegate:aProtocol?
}
~~~

注意到这里,`aProtocol`通过在继承列表中添加关键词`class`来限制协议只能被class类型所遵循。这也是为什么我们能够声明delegate为`weak`的原因,`weak`仅适用于引用类型。而在Swift,`enum`与`struct`这些值类型中也是可以遵循协议的。


- 闭包引起的循环引用：

Swift提供了一个叫`closure capture list`的解决方案。

语法很简单,就是在闭包的前面用`[]`声明一个捕获列表。

~~~swift
let closure = { [weak self] in 
    self?.doSomething() //Remember, all weak variables are Optionals!
}
~~~

我们用一个实际的例子来介绍一下,比如我们常用的NotificationCenter：

~~~swift
class aClass{
    var name:String
    init(name:String){
        self.name = name
        NSNotificationCenter.defaultCenter().addObserverForName("print", object: self, queue: nil)
        { [weak self] notification in print("hello \(self?.name)")}
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
~~~





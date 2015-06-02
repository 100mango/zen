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
	- block与对象之间的循环引用：使用__weak指令

	~~~objevtive-c
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
	
	举一个例子，一个Timer的Target是ViewController.
	
	这个时候，如果我们是在dealloc方法里让timer invalidate，就会造成内存泄露.
	
	事实上，timer是永远不会被invalidate.因为此时VC的引用计数永远不会为零。因为Timer强引用了VC。而因为VC的引用计数不为零,dealloc永远也不会被执行，所以Timer永远持有了VC.
	
	因此我们需要注意在什么地方invalidate计时器，我们可以在viewWillDisappear里面做这样的工作。
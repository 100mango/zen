#iOS夯实：RunLoop

目标：用简洁易懂的语言归纳runLoop和对我们日常开发的影响。

###1. 什么是RunLoop

runLoop是一个与线程相关的机制，可以简单理解为一个循环。
在这个循环里面等待事件，然后处理事件。而这个循环是基于线程的。
在Cocoa中每个线程都有它的runLoop.
通过runLoop这样的机制，线程能够在没有事件需要处理的时候休息，有事情的时候运行。减轻CPU压力。


###2. 日常开发中的RunLoop
简单理解了RunLoop之后，我们发现其实我们平时的开发，背后都无时无刻与runLoop有关。

但是我们很幸运不需要把时间都浪费在纠结这些底层细节上,绝大部分工作都交给了操作系统为我们实现。
所以关于runLoop，我们在不想被底层细节包围的前提下，需要了解和做些什么呢。

1. 需要了解RunLoop的坑：
	- NSTimer  
	日常开发中，我们与runLoop接触得最近可能就是通过NSTimer了。一个Timer一次只能加入到一个RunLoop中。我们日常使用的时候，通常就是加入到当前的runLoop的default mode中。  
	
	 提到mode,就需要谈谈RunLoop Modes  
	 简单的说，runLoop有多个Mode,RunLoop只能运行一个Mode,runLoop只会处理它当前Mode的事件。
	 
	 所以就会导致一些地方我们需要去注意。
	 - 一般Timer是运行在RunLoop的default mode上，而ScrollView在用户滑动时，主线程RunLoop会转到UITrackingRunLoopMode。而这个时候，Timer就不会运行,方法得不到fire。

	 用一个真实例子来说明（自身教训）：![注册界面](https://github.com/100mango/zen/blob/master/%23iOS%E5%A4%AF%E5%AE%9E%EF%BC%9ARunLoop/RunLoop.png)
	 
	 在一次写一个注册界面的时候，用户点击发送验证码后，使用Timer,倒数60秒以允许用户再次申请发送验证码，同时每一秒更新界面秒数信息。而此时Timer运行于主线程的default mode上。若此时用户滑动显示屏，则会出现Timer失效,界面得不到更新的情况。此时就是因为RunLoop的mode原因。
	 
	- NSURLConnection,NSStream也是同样的情况，默认运行于default mode。
	
2. 解决方案：
	- 第一种:设置RunLoop Mode，例如NSTimer,我们指定它运行于NSRunLoopCommonModes,这是一个Mode的集合。注册到这个Mode下后，无论当前runLoop运行哪个mode,事件都能得到执行。
	- 第二种:另一种解决Timer的方法是，我们在另外一个线程执行和处理Timer事件，然后在主线程更新UI.
	 

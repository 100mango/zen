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
	 简单的说，runLoop有多个Mode,一次只能运行一个Mode,runLoop只会处理它当前Mode的事件。
	 
	 所以就会导致一些地方我们需要去注意。
	 - 一般Timer是运行在RunLoop的default mode上，而ScrollView在用户滑动时，主线程RunLoop会转到UITrackingRunLoopMode。而这个时候，Timer就不会运行,方法得不到fire。

	 用一个真实例子来说明（自身经历）：在一次写一个注册界面的时候，用户点击
	 ![注册界面]()
	 
	 

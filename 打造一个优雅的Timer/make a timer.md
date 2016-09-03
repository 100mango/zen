#打造一个优雅的Timer

![](logo.png)

源代码地址： [SwiftTimer](https://github.com/100mango/SwiftTimer)

##问题

在iOS和macOS平台上，我们使用的Timer基本上以`NSTimer`为主。

而众所周知的是，`NSTimer`有不少需要注意的地方。

1. 循环引用问题

	NSTimer会强引用targrt,同时RunLoop会强引用未invalidate的NSTimer实例。 容易找成内存泄露。
	 
	(关于NSTimer引起的内存泄露可阅读[iOS夯实：ARC时代的内存管理](https://github.com/100mango/zen/blob/master/iOS%E5%A4%AF%E5%AE%9E%EF%BC%9AARC%E6%97%B6%E4%BB%A3%E7%9A%84%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/%23iOS%E5%A4%AF%E5%AE%9E%EF%BC%9AARC%E6%97%B6%E4%BB%A3%E7%9A%84%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86.md) NSTimer一节）
	
2. RunLoop问题

	因为NSTimer依赖于RunLoop机制进行工作,因此需要注意RunLoop相关的问题。NSTimer默认运行于RunLoop的default mode中。
	
	而ScrollView在用户滑动时，主线程RunLoop会转到`UITrackingRunLoopMode`。而这个时候，Timer就不会运行,方法得不到fire。如果想要在ScrollView滚动的时候Timer不失效，需要注意将Timer设置运行于`NSRunLoopCommonModes`。
	
	
3. 线程问题

	NSTimer无法在子线程中使用。如果我们想要在子线程中执行定时任务，必须激活和自己管理子线程的RunLoop。否则NSTimer是失效的。
	
4. 不支持动态修改时间间隔

	NSTimer无法动态修改时间间隔，如果我们想要增加或减少NSTimer的时间间隔。只能invalidate之前的NSTimer，再重新生成一个NSTimer设定新的时间间隔。

5. 不支持闭包。

	NSTimer只支持调用`selector`,不支持更现代的闭包语法。
	

关于循环引用问题，网上已经有不少方案和开源项目对其进行了解决。

那么，有没有可能一次性解决上面这五大问题呢？

答案是可以的。我们可以基于GCD的`DispatchSource`做一个优雅简洁，无循环引用问题，不需要手动管理RunLoop，支持子线程,支持动态修改时间间隔，支持闭包语法的Timer。


##实现

Swift3对`libdispatch`进行了[抽象和重命名](https://github.com/apple/swift-evolution/blob/master/proposals/0088-libdispatch-for-swift3.md)，将我们以往使用的C API转换成了更现代的语法和面向对象范式。在这里，为了使实现更简洁易懂，基于Swift实现我们的Timer，Objective-C的实现同理可得。


首先简单介绍一下`DispatchSource`：

`DispatchSource` 用于监听系统底层事件的发生，并协调后续的工作。

`DispatchSource` 有以下几种类型：

- Timer Dispatch Source： 定时信号调度源
- Signal Dispatch Source：监听UNIX信号调度源，比如监听代表挂起指令的SIGSTOP信号。
- Descriptor Dispatch Source：监听文件相关操作和Socket相关操作的调度源。
- Process Dispatch Source：监听进程相关状态的调度源。
- Mach port Dispatch Source：监听Mach相关事件的调度源。
- Custom Dispatch Source：监听自定义事件的调度源。

一般来说，`DispatchSource`的使用步骤就是：创建一个想要监听的事件类型对应的dispatch source,然后给这个source指定一个闭包,指定一个`Dispatch Queue`。当source监听到相应的事件时，就会将该闭包自动加到queue中执行。

对应到我们的timer,我们选择的就是Timer Dispatch Source类型。

基于`DispatchSource`构建Timer，代码简洁优雅，核心代码不过数十行。

~~~swift
class SwiftTimer {
    
    private let internalTimer: DispatchSourceTimer
    
    init(interval: DispatchTimeInterval, repeats: Bool = false, queue: DispatchQueue = .main , handler: () -> Void) {
        
        internalTimer = DispatchSource.makeTimerSource(queue: queue)
        internalTimer.setEventHandler(handler: handler)
        if repeats {
            internalTimer.scheduleRepeating(deadline: .now() + interval, interval: interval)
        } else {
            internalTimer.scheduleOneshot(deadline: .now() + interval)
        }
    }
    
    deinit() {
    	//事实上，不需要手动cancel. DispatchSourceTimer在销毁时也会自动cancel。
    	internalTimer.cancel()
    }
    
    func rescheduleRepeating(interval: DispatchTimeInterval) {
    	internalTimer.scheduleRepeating(deadline: .now() + interval, interval: interval)
    }
    
}
~~~

使用也非常的方便：

~~~swift
let timer = SwiftTimer(interval: .seconds(1)) { [weak self]
    print("hello singleTimer")
    self?.someMethod()
}
timer.start()
  
let timer = SwiftTimer(interval: .seconds(1), repeats: true) {
	print("hello repeatic timer")
}
timer.start()
~~~

让我们再回过头来审视上面五个问题:

1. 循环引用问题

	如上面的代码示例，我们只需在闭包中弱引用self即可。
	
	同时，SwiftTimer被释放后。`DispatchSourceTimer`会自动cancel。
	
	因此，再也不需要考虑像NSTimer的循环引用问题。
	
2. RunLoop问题

	基于`DispatchSource`实现的Timer,不依赖于RunLoop进行时间分发。因此再也不需要设置RunLoop mode。不需要考虑麻烦的边际情况。simple and stupid是最好的。
	
3. 线程问题

	~~~swift
	let timer = SwiftTimer(interval: .seconds(2), repeats: false, queue: .global()) {
        print( "hello background queue" )
    }
    timer.start()
	~~~
	
	我们可以指定在后台队列或自定义队列进行定时任务。同样，simple and elegant。
	
4. 动态调整间隔问题

	如果有些场景需要我们修改时间间隔，比如想提高轮询的速度，直接调用`rescheduleRepeating(interval: DispatchTimeInterval)`修改时间间隔即可。


	~~~swift
	let timer = SwiftTimer.repeaticTimer(interval: .seconds(5)) { timer in
    	print("doSomething")
	}
	timer.start()  // print doSomething every 5 seconds
	
	func speedUp(timer: SwiftTimer) {
	    timer.rescheduleRepeating(interval: .seconds(1))
	}
	speedUp(timer) // print doSomething every 1 second 
	~~~

5. 不支持闭包

	很显然，问题得到了解决。

##拓展

同时，我们基于`DispatchSource`开发的SwiftTimer具备很强的扩展性。

比如实现throttle功能。也就是用一个时间阈值来限制调用方法的频率。比如用于过滤过于频繁的搜索请求。

~~~swift
extension SwiftTimer {
    private static var timers = [String:DispatchSourceTimer]()
    
    static func throttle(interval: DispatchTimeInterval, identifier: String, queue: DispatchQueue = .main , handler: () -> Void ) {
        
        if let previousTimer = timers[identifier] {
            previousTimer.cancel()
        }
        
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.scheduleOneshot(deadline: .now() + interval)
        timer.setEventHandler {
            handler()
            timer.cancel()
            timers.removeValue(forKey: identifier)
        }
        timer.resume()
        timers[identifier] = timer
    }
}
~~~

用法：

~~~swift
  let timer = SwiftTimer.repeaticTimer(interval: .seconds(1)) {
        
	    SwiftTimer.throttle(interval: .seconds(1.5), identifier: "not pass") {
	        print("should not pass")
		}
   }
~~~


最后，附上项目地址： [SwiftTimer](https://github.com/100mango/SwiftTimer)


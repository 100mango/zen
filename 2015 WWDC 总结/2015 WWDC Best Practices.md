#2015 WWDC Best Practices

这篇文章主要记录观看学习2015 WWDC视频总结的iOS最佳实践。一个个session记录学习过于繁琐。因此决定用简单的篇幅,尽可能总结重点。


##Cocoa Touch Best Practices


1. App Lifecycle

	**如何使应用启动更快。**
	
	要点在于：
	> Return quickly from applicationDidFinishLaunching
	
	在applicationDidFinishLaunching不要花费时间进行读取数据等工作,尽快地返回。如果有必要的话,让它在后台执行,不阻塞主线程。
	
	例如：
	
	~~~swift
	func application(application: UIApplication, didFinishLaunchingWithOptionslaunchOptions: [NSObject: AnyObject]?) -> Bool {    globalDataStructure = MyCoolDataStructure()    let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)    dispatch_async(globalQueue) { // defer work until later        globalDataStructure.fetchDataFromDatabase()    }return true 
}
	~~~
	
2. Views and View Controllers

	**利用UIViewControllerTransitionCoordinator在UIViewController的转场动画中获取更精准的控制。**Session只简单地提了一下,没有展开。
	
	但是看到Session的这里,却引起了我的思考。让我想到了从iOS7开始,系统为UINavigationController添加了一个返回手势,只要我们在边缘用手势就能够返回。
	
	但是有时会遇到一种情况,那就是我们在`viewWillAppear`里面做了一些工作。而一旦用户在手势滑动的过程中如果中途取消了。那么我们`viewWillAppear`里面的工作已经被触发了,但是下一次用户再滑动返回,仍然会触发一次。
	
	这个时候,你可能会说,那我们把工作放在`viewDidAppear`里面做不久行了吗。先抛开一些我们只能在`viewWillAppear`里面进行作业的情况，即使我们把代码移到`viewDidAppear`,问题仍然会出现,因为viewDidAppear有时不会被调用。
	
	这是为什么呢,顺藤摸瓜我找到了WWDC 2013 的Session *《Custom Transitions Using View Controllers》* 里面提到
	> you cannot assume a viewDidDisappear will be followed by viewWillDisappear. The same goes to viewWillAppear and viewDidAppear
	
	= =听起来的确有点蛋疼,这位UIKit的工程师也被同事无情的取笑 ：） 说viewWill Appear 应该被叫做 view might appear或view will probably appear, 或是I really wish this view would appear. 笑。
	
	
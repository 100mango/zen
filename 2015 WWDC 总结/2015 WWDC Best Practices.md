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
	func application(application: UIApplication, didFinishLaunchingWithOptions    launchOptions: [NSObject: AnyObject]?) -> Bool {
    globalDataStructure = MyCoolDataStructure()
    let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    dispatch_async(globalQueue) {
        globalDataStructure.fetchDataFromDatabase()    }    return true
}
	~~~
	
2. Views and View Controllers

	**利用UIViewControllerTransitionCoordinator在UIViewController的转场动画中获取更精准的控制。**Session只简单地提了一下,没有展开。
	
	但是看到Session的这里,却引起了我的思考。让我想到了从iOS7开始,系统为UINavigationController添加了一个返回手势,只要我们在边缘用手势就能够返回。
	
	但是有时会遇到一种情况,那就是我们在`viewWillAppear`里面做了一些工作。而一旦用户在手势滑动的过程中如果中途取消了。那么我们`viewWillAppear`里面的工作已经被触发了,但是下一次用户再滑动返回,仍然会触发一次。
	
	举一个例子,直到我写下这篇总结的当前iOS最新版本iOS8.4仍然有的问题。
	
	那就是打开iOS设置界面,随便点一个比如蓝牙一栏进去,然后我们滑动返回,能看到有个美妙的cell从selected到deselected的过渡动画。但是注意,如果我们中途取消返回,第二次返回的时候,就没有这个效果了。
	
	![](swipe.png)
	
	原因就在于第一次`viewWillAppear`的时候已经取消了选择。
	
	这个问题我们就能通过`UIViewControllerTransitionCoordinator`来进行精确协调。
	
	> An object that adopts the UIViewControllerTransitionCoordinator protocol provides support for animations associated with a view controller transition. Typically, you do not adopt this protocol in your own classes. When you present or dismiss a view controller, UIKit creates a transition coordinator object automatically and assigns it to the view controller’s transitionCoordinator property. That transition coordinator object is ephemeral and lasts for the duration of the transition animation.


	
	
	
	
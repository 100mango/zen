#WWDC 2014 
###Core iOS Application Architectural Patterns （session 224）
--
今年春节抽空看了几个WWDC session.分别简单总结一下。

这个Session主要讲了iOS框架使用的最常用的模式。Cocoa框架很多，但不需要担心学不过来，如果把基本模式了解了，会发现许多东西都是共通的。

该Session比较简单，复习和巩固了iOS的经典模式。

1. Target/Action  
   consistent way to connect controls to custom logic  
	
	无论Control是什么类，一个Button或是一个BarButtonItem,都是通过这种模式来将control与custom logic 连接起来。
	
2. Responder Chain  
   Handle events without knowledge of which object will be used
   
![]()
 
#Swift学习：Swift与Objective-C


近来初学Swift。对于编程语言,我只是一个门外汉。编程语言的设计对我来说太遥远,编译器设计对我来说则太困难晦涩。那么本来静静地学习就好了,安心写代码即可。不过还是觉得学习这一新的语言,还是得更用心,因此决定写下这篇文章来总结与拓展学习Swift。

自己因为已经使用Objective-C有一些经验,因此在学习的过程作个对比,加深印象,也希望能够帮助已经有Objective-C经验的同仁们更快地了解Swift,尽一点绵薄之力。


###1.变量,常量,属性(property)和实例变量(instance variable)

在Cocoa世界开发的过程中,我们最常打交道的是property.

典型的声明为:

~~~objective-c
@property (strong,nonatomic) NSString *string;
~~~

而在Swift当中,摆脱了C的包袱后,变得更为精炼,我们只需直接在类中声明即可

~~~swift
class Shape {
    var name = "shape"
}
~~~

注意到这里,我们不再需要@property指令,而在Objective-C中,我们可以指定property的attribute,例如strong,weak,readonly等。

而在Swift的世界中,我们通过其他方式来声明这些property的性质。

需要注意的几点:

- strong: 在Swift中是默认的
- weak: 通过weak关键词申明     

	~~~swift
	weak var delegate: UITextFieldDelegate? 
	~~~
	
- readonly,readwrie  直接通过声明变量var,声明常量let的方式来指明
- copy 通过@NSCopying指令声明。 

	*值得注意的是string,array和Dictionary在Swift是以值类型(value type)而不是引用类型(reference type)出现,因此它们在赋值,初始化,参数传递中都是以拷贝的方式进行* 
	
	[延伸阅读：Value and Reference Types](https://developer.apple.com/swift/blog/?id=10)
	
- nonatomic,atomic 目前Swift没有相关的特性,但是我们在线程安全上已经有许多机制,例如NSLock,GCD相关API等。个人推测原因是苹果想把这一个本来就用的很少的特性去掉,线程安全方面交给平时我们用的更多的机制去处理。


然后值得注意的是,在Objective-C中,我们可以跨过property直接与instance variable打交道,而在Swift是不可以的。

例如：我们可以不需要将someString声明为property,直接使用即可。即使我们将otherString声明为property,我们也可以直接用_otherString来使用property背后的实例变量。

~~~objective-c
@interface SomeClass : NSObject {
  NSString *someString;
}
@property(nonatomic, copy) NSString* otherString;
~~~

而在Swift中,我们不能直接与instance variable打交道。也就是我们声明的方式简化为简单的一种,简单来说在Swift中,我们只与property打交道。

> A Swift property does not have a corresponding instance variable, and the backing store for a property is not accessed directly

因此之前使用OC导致的一些[开发争议](http://blog.devtang.com/blog/2015/03/15/ios-dev-controversy-1/)就不再需要争执了,在Swift的世界里,我们只与property打交道。个人觉得这看似小小一点变动使Swift开发变得更加安全以及在代码的风格更为统一与稳定。


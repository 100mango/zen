#Swift学习：Swift与Objective-C


近来初学Swift,对于编程语言,我只是一个门外汉。编程语言的设计对我来说太遥远,编译器设计对我来说则太困难晦涩。那么本来静静地学习就好了,安心写代码即可。不过还是觉得学习这一新的语言,还是得更用心,因此决定写下这篇文章来总结与拓展学习Swift。

自己因为已经使用Objective-C有一些经验,因此觉得在学习的过程作个对比,加深印象,也希望能够帮助已经有Objective-C经验的同仁们更快地了解Swift,尽一点绵薄之力。


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

- strong: 在Swift中是默认的
- weak: 通过weak关键词申明     

	~~~swift
	weak var delegate: UITextFieldDelegate? 
	~~~
	
- readonly,readwrie  直接通过声明变量var,声明常量let的方式来指明
- copy 通过@NSCopying指令声明。 

	*值得注意的是string,array和Dictionary在Swift是以值类型(value type)而不是引用类型(reference type)出现,因此它们都是以拷贝的方式进行传递。* 
	
	[延伸阅读：Value and Reference Types](https://developer.apple.com/swift/blog/?id=10)
	
- 
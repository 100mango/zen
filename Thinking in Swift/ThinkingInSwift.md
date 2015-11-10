#Thinking in Swift

从Objective-C转到Swift,我们往往脑袋里还带着旧的一套编程套路。为了利用Swift写出更优雅,更健壮的代码。让我们用初心者的心态来学习新的编程范式,新的可能。

##1.拥抱`Optional`。哲学: 一个值要么有值,要么就是optional。

> Optionals are an example of the fact that Swift is a type safe language. Swift helps you to be clear about the types of values your code can work with. If part of your code expects a String, type safety prevents you from passing it an Int by mistake. This restriction enables you to catch and fix errors as early as possible in the development process.


Swift引进了一个新的概念`Optional`,以及相关的一系列语法:
	
- `?` 与 `!`  声明Optional
-  `if let`   Optional binding
- `guard`     Early Exit
- `as?` 与 `as!` 
- `try?`

Optional的核心在于类型安全,在于和Nil做斗争。在于在运行前就处理好所有值为空或不为空的情况,如果有错误的话,直接在编译的时候就给出error,不等到运行的时候才crash。
	
在Swift的世界里,如果我们不声明一个对象为Optional,则它一定是有值的。这一点是非常有价值的,避免了我们对空对象进行操作。虽然在Objective-C中对空对象发送消息不会导致crash。**但是有许多情况下对空对象操作会导致Crash,比如向数组插入空对象等许多操作操作。**（详情查阅:[Crash in Cocoa](https://github.com/100mango/zen/blob/master/iOS%E5%A4%AF%E5%AE%9E%EF%BC%9ACrash%20in%20Cocoa/Crash%20in%20Cocoa.md)）

更重要的是,我们更希望达到一种状态,就是我操作对象和数据的时候,我能够确信它不为空。这种哲学避免了许多冗杂无用的判断Nil操作,同时也大大减少了忘记判断nil导致的crash。
	
那Swift究竟通过什么途径来保证一个对象如果不是Optional,他就一定有值呢？
	
1. 如果我们使用了没被初始化的变量和常量,编译器会抛出error。
	
	~~~swift
	var testString:String
	print(testString)
	//error: variable 'testString' used before being initialized
	~~~
	
2. 类和结构体的实例在创建时,一定要为所有存储型属性设置初始值。我们可以在`initializer`或是定义属性的时候为其设置默认值,否则编译器会抛出error.
		
	~~~swift
	class testClass {
    var a:String
    
	    init(){ 
	    }
	    //	error:return from initializer without initializing all stored properties
	
	}
	~~~

由此我们也引出了`optional`的概念。Optional表示一个值可能为空。要么有值,要么为空(nil)。

那么这时候你可能会问,在Objective-C也是这样,一个对象要么有值,要么为nil。

从最简单的语法入手：

~~~swift
var optionalInt:Int?
~~~


1. 首先,在OC中,nil只针对对象而已,对于结构体,枚举类型,基本的C类型来说,是没有nil的。我们不能直接判断它们是否有值。在OC中,nil是一个指向不存在对象的指针,在Swift中,nil不是指针,它是一个确定的值,用来表示值为空。 (事实上,nil是一个枚举值)

	> [Swift之 ? 和 !](http://joeyio.com/ios/2014/06/04/swift---/)

	而Swift的Optional让我们能明确地标注一个值有没有可能为空。并且值的类型没有限制。
	
2. Swift的`Optional Binding`机制确保我们在使用Optional值时先判断值是否为空。

	在Objective-C中,判空操作不是强制和必须的。判空是一个良好的习惯,但是因为没有约束和规范。很多时候判空操作都被遗漏了,导致了许多潜在的问题。
	
	但在Swift中,我们在使用一个Optional值之前必须先unwarp它。
	
	语法：
	
	~~~swift
	if let constantName = someOptional {
	  //use constant
	}
	~~~


	比较绕的一点：
	
	~~~swift
	
	let optionalLet:String?
	var optionalVar:String?
	
	//标记为optional的let,一定要在使用前赋值,要么永远为nil,要么永远有值
	//标记为optional的var,不需要要在使用前赋值,因为它可能有时有值,有时没值
	
	if let unwarp = optionalLet{
	//error: variable used before being initalized
	}
	
	if let unwarp = optionalVar{
	    //OK
	}
	~~~

参考 [why use optional let](http://stackoverflow.com/questions/29662836/swift-use-of-optional-with-let)


##2.学习泛型。抽象的魅力。

泛型编程,简单地总结。就是让我们在保持type safety的同时写出不局限于单一类型的代码,也即灵活与安全。

####泛型函数(`Generic Functions`)：

举个最简单的例子：交换。对比以下两种写法,一种是只针对Int类型的交换。而我们用泛型改写后,适用于其它所有类型。

~~~swift
func oldSwap(inout a:Int ,inout _ b:Int){
    let temp = a
    a = b
    b = temp
}

func genericSwap<T>(inout a:T,inout _ b:T){
    let temp = a
    a = b
    b = temp
}
~~~

泛型在提供灵活抽象的同时,也保持了类型安全,占位类型`T`代表了一种类型,使得交换限制在同种类型上,比如我们尝试交换数字和字符串swap(1,"2"),那么编译器就会报错。

####泛型类型(`Generic Types`)：

Swift也允许我们自定义自己的泛型类型,像Swift标准库提供的Array,Dictionary都是泛型类型。

泛型类型一般是容器类型,利用好它,我们能创造出灵活通用的类型。

这里举一个简单但却强大的例子:

![](mvvm.png)

在MVVM模式里,有个很重要的核心内容就是如何将ViewModel里的变化传递给View进行更新,苹果官方在iOS上没有提供一个绑定机制,我们可以使用delegate,KVO,Notification等系统途径来通知View进行更新,但很多时候都显得非常繁琐。

在这里我们简单地造一个绑定工具。

~~~swift
class DynamicString {
  typealias Listener = String -> Void
  var listener: Listener?

  func bind(listener: Listener?) {
    self.listener = listener
  }

  var value: String {
    didSet {
      listener?(value)
    }
  }

  init(_ v: String) {
    value = v
  }
}
~~~

上面这段代码很简单,利用了Swift的property observer,在每次Model设置的时候,调用闭包,我们可以在闭包里面做视图的更新,用起来像是这样：

~~~swift
let nameModel = DynamicString("Mango")
let nameLabel = UILabel()

nameModel.bind{ nameLabel.text = $0 }
nameModel.value = "100Mango"  //修改model的值
print(nameLabel.text) // 输出 "100mango" , UI的值得到了更新
~~~



我们很快就能够发现问题所在,对于一个String类型,我们要创造一个DynamicString。那么Int,NSdate...等等各种类型呢？

这个时候我们便可以利用Swift的泛型类型进行改造:

~~~swift
class Dynamic<T> {
  typealias Listener = T -> Void
  var listener: Listener?

  func bind(listener: Listener?) {
    self.listener = listener
  }
  
  var value: T {
    didSet {
      listener?(value)
    }
  }

  init(_ v: T) {
    value = v
  }
}
~~~

通过上面我们的改造,我们的简单绑定机制就能对各种类型的数据都起作用。

~~~swift
let text = Dynamic("Steve")
let bool = Dynamic(false)
let Int =  Dynamic(1)
~~~

参考引用:[bindings-generics-swift-and-mvvm](http://rasic.info/bindings-generics-swift-and-mvvm/)

##3.Protocol Oriented Programming 与value types

下面我们用Protocol Oriented 

	
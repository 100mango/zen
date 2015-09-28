#Thinking in Swift

从Objective-C转到Swift,我们往往脑袋里还带着旧的一套编程套路。为了利用Swift写出更优雅,更健壮的代码。让我们用初心者的心态来学习新的编程范式,新的可能。

##1.拥抱`Optional`。哲学: 一个值要么有值,要么就是optional。

> Optionals are an example of the fact that Swift is a type safe language. Swift helps you to be clear about the types of values your code can work with. If part of your code expects a String, type safety prevents you from passing it an Int by mistake. This restriction enables you to catch and fix errors as early as possible in the development process.


Swift引进了一个新的概念`Optional`,以及相关的一系列语法:
	
- `?` 与 `!`  声明Optional
-  `if let`   Optional binding
- `guard`
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


1. 首先,在OC中,nil只针对对象而已,对于结构体,枚举类型,基本的C类型来说,是没有nil的。我们不能直接判断它们是否有值。在OC中,nil是一个指向不存在对象的指针,在Swift中,nil不知指针,它是一个确定的值,用来表示值为空。 (事实上,nil是一个枚举值)

	> [Swift之 ? 和 !](http://joeyio.com/ios/2014/06/04/swift---/)

	而Swift的Optional让我们能明确地标注一个值有没有可能为空。并且值的类型没有限制。
	
2. Swift的Optional Binding机制确保我们在使用Optional值时先判断值是否为空。


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

	
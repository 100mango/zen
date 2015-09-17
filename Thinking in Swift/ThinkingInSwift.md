#Thinking in Swift

从Objective-C转到Swift,我们往往脑袋里还带着旧的一套编程套路。为了利用Swift写出更优雅,更健壮的代码。让我们用初心者的心态来学习新的编程范式,新的可能。

1. 拥抱`Optional`。哲学: 一个值要么有值,要么就是optional。

	> Optionals are an example of the fact that Swift is a type safe language. Swift helps you to be clear about the types of values your code can work with. If part of your code expects a String, type safety prevents you from passing it an Int by mistake. This restriction enables you to catch and fix errors as early as possible in the development process.


	Swift引进了一个新的概念`Optional`,以及相关的一系列语法:
	
	- `?` 与 `!`
	-  `if let`
	- `guard`
	- `as?` 与 `as!`
	- `try?`

	Optional的核心在于类型安全,在于和Nil做斗争。在于在运行前就处理好所有值为空或不为空的情况,如果有错误的话,直接在编译的时候就给出error,不等到运行的时候才crash。
	
	在Swift的世界里,如果我们不声明一个对象为Optional,则它一定是有值的。这一点是非常有价值的,避免了我们对空对象进行操作。虽然在Objective-C中对空对象发送消息不会导致crash。但是有许多情况下对空对象操作会导致Crash,比如向数组插入空对象等操作。更重要的是,我们更希望达到一种状态,就是我操作对象和数据的时候,我能够确信它不为空。这种哲学避免了许多冗杂无用的判断Nil操作,同时也大大减少了忘记判断nil导致的crash。
	
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

	
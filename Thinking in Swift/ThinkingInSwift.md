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

###泛型函数(`Generic Functions`)：

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

###泛型类型(`Generic Types`)：

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

###类型约束（`Type Constraints`）:

我们上面的泛型函数**inout**和泛型类型**Dynamic**能够应用到任何类型中。但是有时候,对泛型函数和泛型方法应用的类型进行约束,会非常的有用。

类型约束可以指定一个类型参数(`Type Parameters`)继承自指定类,或者遵循某个协议或一系列协议。

语法:

~~~swift
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
}
~~~

- 泛型函数的类型约束：

比如我们要自己写一个方法找出数组中最大的元素 
> Swift2:已引入了`maxElement`方法 :)

~~~swift
func findLargestInArray<T : Comparable>(array: Array<T>) -> T? {
    
    guard array.count > 0 else{
        return nil
    }
    
    var largest : T = array[0]
    for i in 1..<array.count {
        largest = array[i] > largest ? array[i] : largest
    }
    return largest
}
~~~

注意到这里我们标注了`T : Comparable`,这是因为只有遵循Comparable协议的类型才能够进行比较,如果我们在这里没有进行类型约束,则直接会编译不通过,因为不是所有类型都能进行大小的比较。类型约束在这里让我们的泛型方法变得更安全和更有针对性。


- 泛型类型的类型约束：

比如Swift的字典的定义:

~~~swift
struct Dictionary<Key : Hashable, Value>
~~~

我们看到Dictionary的Key被约束为遵循`Hashable`协议。学过数据结构的我们知道,字典实际上是一个哈希表`hash table`。字典的键需要遵循`Hashable`协议,否则我们不能得到哈希表相关的插入,查找等特性。因此`Dictionary`这个泛型类型,需要通过类型约束来限制它的类型参数`Key`遵循`Hashable`协议。


###关联类型（`Associated Types`）:

我们在上面看到了在函数和类型中的泛型编程,而`Protocol`作为Swift中重要的组成部分,自然也是支持泛型这个编程概念的。

~~~swift
protocol Container {
    typealias ItemType
    mutating func append(item: ItemType)
}
~~~

我们直接用官方的一个例子说明,假设我们定义了一个Container协议,我们希望遵循我们协议的类型能够实现一个添加新元素的功能。我们希望这个协议是广泛使用的,不限制元素的类型。这里我们通过`typealias`这个关键词来声明关联类型。等到实现协议的时候再去确定真正的类型。

~~~swift
class myContainer:Container{
    typealias ItemType = String
    func append(item: String) {
    }
}
~~~

我们简单地实现了一个遵循Container协议的类,我们确定了类型是String。在这里

~~~swift
typealias ItemType = String
~~~

这一句代码是可以不写的,Swift的类型推导系统能够在`append`方法的参数类型里获得ItemType的具体类型。



- 强大的`where`语句

	


参考引用: [swift-generics-pt-2](http://austinzheng.com/2015/09/29/swift-generics-pt-2/)



##3.Protocol Oriented Programming 与value types

protocol-oriented programming 的核心在于

1. 用组合替代继承。
2. 

protocol extension 能够解决一些继承带来的问题。

**prefer composition over inheritance**

1. 庞大的基类

[mixins-and-traits-in-swift-2](http://matthijshollemans.com/2015/07/22/mixins-and-traits-in-swift-2/)

2. 非常深的继承树

需要思考的问题： protocol oriented programming 与 简单的对类进行Extension有什么区别。类的Extension也可以做到组合化。

自己的一点思考： extension是针对具体某个类的。而protocol oriented则是直接把一个功能加进来。但是protocol也可以限制对象。
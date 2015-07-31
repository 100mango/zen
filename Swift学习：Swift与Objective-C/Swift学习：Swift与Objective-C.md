#Swift学习：Swift与Objective-C


近来初学Swift。对于编程语言,我只是一个门外汉。编程语言的设计对我来说太遥远,编译器设计对我来说则太困难晦涩。那么本来静静地学习就好了,安心写代码即可。不过还是觉得学习这一新的语言,还是得更用心,因此决定写下这篇文章来总结与拓展学习Swift。

自己因为已经使用Objective-C有一些经验,因此决定在学习的过程将常用的语法作个对比,加深印象,尽可能地突出重点。也希望能够帮助已经有Objective-C经验的同仁们更快地了解Swift,尽一点绵薄之力。


重点：

1. 从Objective-C到Swift的语法差异。我们熟悉Objective-C特性在Swift中如何展现。
2. 从Objective-C到Swift的进步改进。研究对比Swift在安全性,易用性上的提升,给我们带来的新编程范式。

目录：  

- [1.变量,常量,属性(property)和实例变量(instance variable)](#1)
- [2.控制流](#2)
- [3.函数](#3)
- [4.类与初始化(Initializers)](#4)


<h2 id="1">1.变量,常量,属性(property)和实例变量(instance variable)</h2>

###Objective-C property in Swift world

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

注意到这里,我们不再需要`@property`指令,而在Objective-C中,我们可以指定property的attribute,例如strong,weak,readonly等。

而在Swift的世界中,我们通过其他方式来声明这些property的性质。

需要注意的几点:

- `strong`: 在Swift中是默认的
- `weak`: 通过weak关键词申明     

	~~~swift
	weak var delegate: UITextFieldDelegate? 
	~~~
	
- `readonly`,`readwrie`  直接通过声明变量`var`,声明常量`let`的方式来指明
- `copy` 通过`@NSCopying`指令声明。 

	**值得注意的是string,array和Dictionary在Swift是以值类型(value type)而不是引用类型(reference type)出现,因此它们在赋值,初始化,参数传递中都是以拷贝的方式进行** 
	
	[延伸阅读：Value and Reference Types](https://developer.apple.com/swift/blog/?id=10)
	
- `nonatomic`,`atomic` 目前Swift没有相关的特性,但是我们在线程安全上已经有许多机制,例如NSLock,GCD相关API等。个人推测原因是苹果想把这一个本来就用的很少的特性去掉,线程安全方面交给平时我们用的更多的机制去处理。


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

因此之前使用OC导致的像巧哥指出的[开发争议](http://blog.devtang.com/blog/2015/03/15/ios-dev-controversy-1/)就不再需要争执了,在Swift的世界里,我们只与property打交道。个人觉得这看似小小一点变动使Swift开发变得更加安全以及在代码的风格更为统一与稳定。

###Swift property延伸：
- `Stored Properties`和`Computed properties`

在Swift中,property被分为两类：`Stored Properties`和`Computed properties`
简单来说,就是stored properties 能够保存值,而conmuted properties只提供getter与setter,利用stored properties来生成自己的值。个人感觉Computed properties更像方法,而不是传统意义的属性。但是这样一个特性存在,使得我们更容易组织我们的代码。

延伸阅读：[computed property vs function](http://stackoverflow.com/questions/24035276/computed-read-only-property-vs-function-in-swift)

- `Type Properties`


Swift提供了语言级别定义类变量的方法。

> In C and Objective-C, you define static constants and variables associated with a type as global static variables.In Swift, however, type properties are written as part of the type’s definition, within the type’s outer curly braces, and each type property is explicitly scoped to the type it supports.
> 

在Objective-C中,我们只能通过单例,或者static变量加类方法来自己构造类变量：

~~~objective-c
@interface Model
+ (int) value;
+ (void) setValue:(int)val;
@end

@implementation Model
static int value;
+ (int) value
{ @synchronized(self) { return value; } }
+ (void) setValue:(int)val
{ @synchronized(self) { value = val; } }
@end
~~~

~~~objective-c
// Foo.h
@interface Foo {
}

+(NSDictionary*) dictionary;

// Foo.m
+(NSDictionary*) dictionary
{
  static NSDictionary* fooDict = nil;

  static dispatch_once_t oncePredicate;

  dispatch_once(&oncePredicate, ^{
        // create dict
    });

  return fooDict;
}
~~~

而在Swift中我们通过清晰的语法便能定义类变量：

通过static定义的类变量无法在子类重写,通过class定义的类变量则可在子类重写。

~~~swift
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}
~~~

同时利用类变量我们也有了更优雅的单例模式实现：

~~~swift
class singletonClass {
    static let sharedInstance = singletonClass()
    private init() {} // 这就阻止其他对象使用这个类的默认的'()'初始化方法
}
 
~~~

Swift单例模式探索：[The Right Way to Write a Singleton](http://krakendev.io/blog/the-right-way-to-write-a-singleton?utm_campaign=This%2BWeek%2Bin%2BSwift&utm_medium=web&utm_source=This_Week_in_Swift_45)


- 延伸：

目前Swift支持的type propertis中的`Stored Properties`类型不是传统意义上的类变量(class variable)，暂时不能通过class 关键词定义,通过static定义的类变量类似java中的类变量,是无法被继承的,父类与子类的类变量指向的都是同一个静态变量。

延伸阅读： [Class variables not yet supported](http://stackoverflow.com/questions/24015207/class-variables-not-yet-supported)

~~~
class SomeStructure {
    class var storedTypeProperty = "Some value."
}

//Swift 2.0 
Error: Class stored properties not yet supported in classes
~~~

通过编译器抛出的错误信息,相信在未来的版本中会完善`Type properties`。


<h2 id="2">2.控制流</h2>

Swift与Objective-C在控制流的语法上关键词基本是一致的,除此之外新增了少许新内容,强化了功能和增加了安全性。

主要有三种类型的语句

1. if,switch和新增的guard
2. for,while
3. break,continue

主要差异有：

***
###关于if

**语句里的条件不再需要使用`()`包裹了。**

~~~swift
let number = 23
if number < 10 {
    print("The number is small")
} 
~~~

**但是后面判断执行的的代码必须使用`{}`包裹住。**
 
为什么呢,在C,C++等语言中,如果后面执行的语句只有语句,我们可以写成:
 
~~~objective-c
  int number = 23
	if (number < 10)
	 	NSLog("The number is small")
~~~

但是如果有时要在后面添加新的语句,忘记添加`{}`,灾难就很可能发送。

：） 像苹果公司自己就犯过这样的错误。下面这段代码就是著名的goto fail错误,导致了严重的安全性问题。

~~~C
  if ((err = SSLHashSHA1.update(&hashCtx, &signedParams)) != 0)
    goto fail;
    goto fail;  // :)注意 这不是Python的缩减
  ... other checks ...
  fail:
    ... buffer frees (cleanups) ...
    return err;
~~~

：）    
最终在Swift,苹果终于在根源上消除了可能导致这种错误的可能性。

**if 后面的条件必须为Boolean表达式**

也就是不会隐式地与0进行比较,下面这种写法是错误的,因为number并不是一个boolean表达式,number != 0才是。

~~~objective-c
int number = 0
if number{
} 
~~~

***
### 关于for

for循环在Swift中变得更方便,更强大。

得益于Swift新添加的范围操作符`...`与`...<`

我们能够将之前繁琐的for循环：

~~~
for (int i = 1; i <= 5; i++)
{
    NSLog(@"%d", i);
}
~~~

改写为：

~~~swift
for index in 1...5 {
    print(index)
}
~~~

当然,熟悉Python的亲们知道Python的range函数很方便,我们还能自由选择步长。
像这样：

~~~python

>>> range(1,5) #代表从1到5(不包含5)
[1, 2, 3, 4]
>>> range(1,5,2) #代表从1到5，间隔2(不包含5)
[1, 3]
~~~

虽然在《The Swift Programming Language》里面没有提到类似的用法,但是在Swift中我们也有优雅的方法办到。

~~~swift
for index in stride(from: 1, through: 5, by: 2) {
    print(index)
}// through是包括5
~~~

然后对字典的遍历也增强了.在Objective-c的快速枚举中我们只能对字典的键进行枚举。

~~~objective-c
NSString *key;
for (key in someDictionary){
     NSLog(@"Key: %@, Value %@", key, [someDictionary objectForKey: key]);
}
~~~

而在Swift中,通过tuple我们可以同时枚举key与value:

~~~swift
let dictionary = ["firstName":"Mango","lastName":"Fang"]
for (key,value) in dictionary{
    print(key+" "+value)
}
~~~

***
### 关于Switch

Swich在Swift中也得到了功能的增强与安全性的提高。

**不需要Break来终止往下一个Case执行**

也就是下面这两种写法是等价的。

~~~swift
let character = "a"

switch character{
    case "a":
        print("A")
    break
    case "b":
        print("B")
    break
default: print("character")
~~~


~~~swift
let character = "a"

switch character{
    case "a":
        print("A")
    case "b":
        print("B")
default: print("character")
~~~

这种改进避免了忘记写break造成的错误,自己深有体会,曾经就是因为漏写了break而花了一段时间去debug。

如果我们想不同值统一处理,使用逗号将值隔开即可。

~~~swift
switch some value to consider {
case value 1,value 2:
    statements
}
~~~

**Switch支持的类型**

在OC中,Swtich只支持int类型,char类型作为匹配。

而在Swift中,Switch支持的类型大大的拓宽了。实际上,苹果是这么说的。
>  A switch statement supports any kind of data 

这意味在开发中我们能够能够对字符串,浮点数等进行匹配了。

之前在OC繁琐的写法就可以进行改进了:

~~~objective-c
if ([cardName isEqualToString:@"Six"]) {
    [self setValue:6];
} else if ([cardName isEqualToString:@"Seven"]) {
    [self setValue:7];
} else if ([cardName isEqualToString:@"Eight"]) {
    [self setValue:8];
} else if ([cardName isEqualToString:@"Nine"]) {
    [self setValue:9];
} 
~~~

~~~swift
switch carName{
    case "Six":
        self.vaule = 6
    case "Seven":
        self.vaule = 7
    case "Eight":
        self.vaule = 8
    case "Night":
        self.vaule = 9   
}
~~~

<h2 id="3">3.函数</h2>

对于在OC中,方法有两种类型,类方法与实例方法。方法的组成由方法名,参数,返回值组成。

在Swift中函数的组成基本一样。

主要区别为：

1. 通过`func`关键词定义函数
2. 返回值在`->`关键词后标注

各举一个类方法与实例方法例子。

~~~objevtive-c
+ (UIColor*)blackColor
- (void)addSubview:(UIView *)view
~~~

对应的swift版本

~~~swift
   	class func blackColor() -> UIColor //类方法, 通过 class func 关键词声明
	func addSubview(view: UIView) //实例方法
~~~

在Swift中,函数的最重要的改进就是函数作为一等公民(first-class),和对象一样可以作为参数进行传递,可以作为返回值,函数式编程也成为了Swift支持的编程范式。

> In computer science, a programming language is said to have first-class functions if it treats functions as first-class citizens. Specifically, this means the language supports passing functions as arguments to other functions, returning them as the values from other functions, and assigning them to variables or storing them in data structures

让我们初略感受一下函数式编程的魅力:

举一个例子,我们要筛选出一个数组里大于4的数字。

在OC中我们可能会用快速枚举来进行筛选。

~~~objective-c
   NSArray *oldArray = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    NSMutableArray *newArray;
    for (NSNumber* number in oldArray) {
        if ([number compare:@4] == NSOrderedDescending ) {
            [newArray addObject:number];
        }
    }
~~~

而在Swift中,我们用两行代码解决这个问题：

~~~swift
let oldArray = [1,2,3,4,5,6,7,8,9,10]
let newArray = oldArray.filter({$0 > 4})
~~~

进一步了解Swift的函数式编程可以通过这篇优秀的博客[Functional Reactive Programming in Swift](http://blog.callmewhy.com/2015/05/11/functional-reactive-programming-1/#)


<h2 id="4">4.类与初始化（Initializers）</h2>

- 文件结构与访问控制

在swift中,一个类不再分为`interface`（.h）与`implementation`(.m)两个文件实现,直接在一个.swift文件里进行处理。好处就是我们只需管理一份文件,以往两头奔波修改的情况就得到解放了,也减少了头文件与实现文件不同步导致的错误。

这时我们会想到,那么我们如何来定义私有方法与属性呢,在OC中我们通过在`class extension`中定义私有属性,在.m文件定义私有方法。

而在Swift中,我们通过`Access Control`来进行控制。

>properties, types, functions等能够进行版本控制的统称为实体。

>- Public：可以访问自己模块或应用中源文件里的任何实体，别人也可以访问引入该模块中源文件里的所有实体。通常情况下，某个接口或Framework是可以被任何人使用时，你可以将其设置为public级别。
- Internal：可以访问自己模块或应用中源文件里的任何实体，但是别人不能访问该模块中源文件里的实体。通常情况下，某个接口或Framework作为内部结构使用时，你可以将其设置为internal级别。
- Private：只能在当前源文件中使用的实体，称为私有实体。使用private级别，可以用作隐藏某些功能的实现细节


一个小技巧,如果我们有一系列的私有方法,我们可以把它们组织起来,放进一个extension里,这样就不需要每个方法都标记private,同时也便于管理组织代码：

~~~swift
// MARK: Private
private extension ViewController {
    func privateFunction() {
    }
}
~~~

- 创建对象与`alloc`和`init`

关于初始化,在Swift中创建一个对象的语法很简洁：只需在类名后加一对圆括号即可。

~~~swift
var shape = Shape()
~~~

而在Swift中,initializer也与OC有所区别,Swift的初始化方法不返回数据。而在OC中我们通常返回一个self指针。

> Unlike Objective-C initializers, Swift initializers do not return a value. Their primary role is to ensure that new instances of a type are correctly initialized before they are used for the first time.

Swift的初始化方法让我们只关注对象的初始化。之前在OC世界中[为什么要self = [super init]？](http://www.zhihu.com/question/22295642)。这种问题得以避免。Swift帮助我们处理了alloc的过程。也让我们的代码更简洁明确。

而在Swift中,`init`也有了更严格的规则。

- 对于所有`Stored Properties`,都**必须**在对象被创建出来前设置好。也就是我们必须在init方法中赋好值,或是直接给属性提供一个默认值。

	如果有property可以被允许在初始出来时没有值,也就是需要在创建出来后再赋值,或是在程序运行过程都可能不会被赋值。那么这个property必须被声明为`optional`类型。该类型的属性会在init的时候初始化为nil.

- initializer严格分为`Designated Initializer`和`Convenience Initializer`
并且有语法定义。

	而在Objective-C中没有明确语法标记哪个初始化方式是convenience方法。关于`Designated Initializer`可参阅之前的:[Objective-C 拾遗：designated initializer](https://github.com/100mango/zen/blob/master/Objective-C%20%E6%8B%BE%E9%81%97%EF%BC%9Adesignated%20initializer/Objective-C%20%E6%8B%BE%E9%81%97%EF%BC%9Adesignated%20initializer.md)

	~~~swift
	init(parameters) {
		statements
	}

	convenience init(parameters) {
	 	statements
	}
	~~~
	


<h2 id="5">5.枚举与结构体</h2>

- 枚举

	在Swift中,枚举是一等公民。(first-class)。能够拥有方法,computed properties等以往只有类支持的特性。
	
	在C中,枚举为每个成员指定一个整型值。而在Swift中,枚举更强大和灵活。我们不必给枚举成员提供一个值。如果我们想要为枚举成员提供一个值(raw value),我们可以用字符串,字符,整型或浮点数类型。
	
	~~~swift
	enum CompassPoint {
  case North
  case South
  case East
  case West
	}

	var directionToHead = CompassPoint.West

	~~~


--
参考：

1. [《The Swift Programming Language》](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html#//apple_ref/doc/uid/TP40014097-CH12-ID145)
2. [Apple Swift Blog](https://developer.apple.com/swift/blog/)
	
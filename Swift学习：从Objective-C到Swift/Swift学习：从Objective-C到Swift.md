# 从 Objective-C 到 Swift


结论放在开头:

我认为 Swift 比 Objective-C 更优雅, 更安全同时也更现代, 更性感。

文章组织脉络：

1. 从 Objective-C 到 Swift 的语法差异。我们熟悉的 Objective-C 特性在 Swift 中如何展现。
2. 从 Objective-C 到 Swift 的进步改进。研究对比 Swift 在安全性, 易用性上的提升, 给我们带来的新编程范式。

目录：

- [1. 属性 (property) 和实例变量(instance variable)](#1)
- [2. 控制流](#2)
- [3. 函数](#3)
- [4. 类与初始化 (Initializers)](#4)
- [5. 枚举与结构体](#5)
- [6. 协议 (Protocols) 与扩展(Extensions)](#6)
- [7.Swift 与 Cocoa](#7)
- [8. 总结](#8)


<h2 id="1">1. 属性 (property) 和实例变量(instance variable)</h2>

### Objective-C property in Swift world

在 Cocoa 世界开发的过程中, 我们最常打交道的是 property.

典型的声明为:

```objective-c
@property (strong,nonatomic) NSString *string;
```

而在 Swift 当中, 摆脱了 C 的包袱后, 变得更为精炼, 我们只需直接在类中声明即可

```swift
class Shape {
    var name = "shape"
}
```

注意到这里, 我们不再需要 `@property` 指令, 而在 Objective-C 中, 我们可以指定 property 的 attribute, 例如 strong,weak,readonly 等。

而在 Swift 的世界中, 我们通过其他方式来声明这些 property 的性质。

需要注意的几点:

- `strong`: 在 Swift 中是默认的
- `weak`: 通过 weak 关键词申明

	```swift
	weak var delegate: UITextFieldDelegate?
	```

- `readonly`,`readwrite`：

	Swift 没有这两个 attribute, 如果是定义一个 `stored property`, 通过 `let` 定义它只读, 通过 `var` 定义它可读可写。

	如果想实现类似 Objective-C 中, 对外在头文件. h 声明 property 为 `readonly`，对内在. m 声明 property 为 `readwrite`, 这种情况在 Swift 通过 `Access Control` 来实现:

	```swift
	private(set) var property: Int
	```

	关于 `Access Control`（在本文 [类与初始化(Initializers)](#4) 会提到）

- `copy`: 不同于 `Objective-C` 中对象都是引用类型。在 Swift 中，许多基础类型都是值类型。比如 String,Array 和 Dictionary 在 Swift 是以值类型 (value type) 而不是引用类型( reference type ) 出现, 因此它们在赋值, 初始化, 参数传递中都是以拷贝的方式进行（简单来说, String,Array,Dictionary 在 Swift 中是通过 `struct` 实现的）

	[延伸阅读：Value and Reference Types](https://developer.apple.com/swift/blog/?id=10)

- `nonatomic`,`atomic` 所有的 Swift properties 都是 nonatomic。但是我们在线程安全上已经有许多机制, 例如 NSLock,GCD 相关 API 等。个人推测原因是苹果想把这一个本来就用的很少的特性去掉, 线程安全方面交给平时我们用的更多的机制去处理。


然后值得注意的是, 在 Objective-C 中, 我们可以跨过 property 直接与 instance variable 打交道, 而在 Swift 是不可以的。

例如：我们可以不需要将 someString 声明为 property, 直接使用即可。即使我们将 otherString 声明为 property, 我们也可以直接用_otherString 来使用 property 背后的实例变量。

```objective-c
@interface SomeClass : NSObject {
  NSString *someString;
}
@property(nonatomic, copy) NSString* otherString;
```

而在 Swift 中, 我们不能直接与 instance variable 打交道。也就是我们声明的方式简化为简单的一种, 简单来说在 Swift 中, 我们只与 property 打交道。

> A Swift property does not have a corresponding instance variable, and the backing store for a property is not accessed directly

### 小结

- 因此之前使用 OC 导致争议：[类的成员变量应该如何定义](http://blog.devtang.com/blog/2015/03/15/ios-dev-controversy-1/)  就不再需要争执了, 在 Swift 的世界里, 我们只与 property 打交道。

- 并且我们在 OC 中 `init` 和 `dealloc` 不能使用属性 `self.property = XXX` 来进行设置的情况得以解决和统一。

> 不知道这一条规定, 在 init 直接用 self.property = value 的同学请自觉阅读 [iOS 夯实：内存管理](https://github.com/100mango/zen/blob/master/iOS%E5%A4%AF%E5%AE%9E%EF%BC%9A%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/iOS%E5%A4%AF%E5%AE%9E%EF%BC%9A%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86.md)


个人觉得这看似小小一点变动使 Swift 开发变得更加安全以及在代码的风格更为统一与稳定。

### Swift property 延伸：
- `Stored Properties` 和 `Computed properties`

在 Swift 中, property 被分为两类：`Stored Properties` 和 `Computed properties`
简单来说, 就是 stored properties 能够保存值, 而 computed properties 只提供 getter 与 setter, 利用 stored properties 来生成自己的值。个人感觉 Computed properties 更像方法, 而不是传统意义的属性。但是这样一个特性存在, 使得我们更容易组织我们的代码。

延伸阅读：[computed property vs function](http://stackoverflow.com/questions/24035276/computed-read-only-property-vs-function-in-swift)

- `Type Properties`


Swift 提供了语言级别定义类变量的方法。

> In C and Objective-C, you define static constants and variables associated with a type as global static variables.In Swift, however, type properties are written as part of the type’s definition, within the type’s outer curly braces, and each type property is explicitly scoped to the type it supports.
>

在 Objective-C 中, 我们只能通过单例, 或者 static 变量加类方法来自己构造类变量：

```objective-c
@interface Model
+ (int) value;
+ (void) setValue:(int)val;
@end

@implementation Model
static int value;
+ (int) value
{@synchronized(self) { return value; } }
+ (void) setValue:(int)val
{@synchronized(self) { value = val; } }
@end
```

```objective-c
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
```

> 更新：Xcode8 Release Note : Objective-C now supports class properties, which interoperate with Swift type properties. They are
declared as: @property (class) NSString *someStringProperty;. They are never synthesized.  也就是从 Xcode8 之后, Objective-C 也有了类变量的定义, 不过 getter 和 setter 都需要我们自己编写。这是一个典型的 Swift 反推 Objective-C 发展的例子。

而在 Swift 中我们通过清晰的语法便能定义类变量：

通过 static 定义的类变量无法在子类重写, 通过 class 定义的类变量则可在子类重写。

```swift
class Aclass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}
```

同时利用类变量我们也有了更优雅的单例模式实现：

```swift
class singletonClass {
    static let sharedInstance = singletonClass()
    private init() {} // 这就阻止其他对象使用这个类的默认的'()'初始化方法
}

```

Swift 单例模式探索：[The Right Way to Write a Singleton](http://krakendev.io/blog/the-right-way-to-write-a-singleton?utm_campaign=This%2BWeek%2Bin%2BSwift&utm_medium=web&utm_source=This_Week_in_Swift_45)


- 延伸：

目前 Swift 支持的 type propertis 中的 `Stored Properties` 类型不是传统意义上的类变量 (class variable)，暂时不能通过 class 关键词定义, 通过 static 定义的类变量类似 java 中的类变量, 是无法被继承的, 父类与子类的类变量指向的都是同一个静态变量。

延伸阅读： [Class variables not yet supported](http://stackoverflow.com/questions/24015207/class-variables-not-yet-supported)

```
class SomeStructure {
    class var storedTypeProperty = "Some value."
}

//Swift 2.0
Error: Class stored properties not yet supported in classes
```

通过编译器抛出的错误信息, 相信在未来的版本中会完善 `Type properties`。(截止至Swift5,还是不支持，基本可以认为这个 feature 已被废弃)


<h2 id="2">2. 控制流 </h2>

Swift 与 Objective-C 在控制流的语法上关键词基本是一致的, 但是扩展性和安全性得到了很大的提升。

主要有三种类型的语句

1. if,switch 和新增的 guard
2. for,while
3. break,continue

主要差异有：

***
### 关于 if

** 语句里的条件不再需要使用 `()` 包裹了。**

```swift
let number = 23
if number < 10 {
    print("The number is small")
}
```

** 但是后面判断执行的的代码必须使用 `{}` 包裹住。**

为什么呢, 在 C,C++ 等语言中, 如果后面执行的语句只有语句, 我们可以写成:

```objective-c
  int number = 23
	if (number < 10)
	 	NSLog("The number is small")
```

但是如果有时要在后面添加新的语句, 忘记添加 `{}`, 灾难就很可能发生。

：） 像苹果公司自己就犯过这样的错误。下面这段代码就是著名的 goto fail 错误, 导致了严重的安全性问题。

```C
  if ((err = SSLHashSHA1.update(&hashCtx, &signedParams)) != 0)
    goto fail;
    goto fail;  // :) 注意 这不是 Python 的缩减
  ... other checks ...
  fail:
    ... buffer frees (cleanups) ...
    return err;
```

：）
最终在 Swift, 苹果终于在根源上消除了可能导致这种错误的可能性。

**if 后面的条件必须为 Boolean 表达式 **

也就是不会隐式地与 0 进行比较, 下面这种写法是错误的, 因为 number 并不是一个 boolean 表达式, number != 0 才是。

```objective-c
int number = 0
if number{
}
```

***
### 关于 for

for 循环在 Swift 中变得更方便, 更强大。

得益于 Swift 新添加的范围操作符 `...` 与 `..<`

我们能够将之前繁琐的 for 循环：

```
for (int i = 1; i <= 5; i++)
{
    NSLog(@"%d", i);
}
```

改写为：

```swift
for index in 1...5 {
    print(index)
}
```

当然, 熟悉 Python 的亲们知道 Python 的 range 函数很方便, 我们还能自由选择步长。
像这样：

```python

>>> range(1,5) #代表从 1 到 5(不包含 5)
[1, 2, 3, 4]
>>> range(1,5,2) #代表从 1 到 5，间隔 2(不包含 5)
[1, 3]
```

虽然在《The Swift Programming Language》里面没有提到类似的用法, 但是在 Swift 中我们也有优雅的方法办到。

```swift
for index in  0.stride(through: 10, by: 2) {
    print(index) // 0 2 4 6 8 10
}
```

然后对字典的遍历也增强了. 在 Objective-c 的快速枚举中我们只能对字典的键进行枚举。

```objective-c
NSString *key;
for (key in someDictionary){
     NSLog(@"Key: %@, Value %@", key, [someDictionary objectForKey: key]);
}
```

而在 Swift 中, 通过 tuple 我们可以同时枚举 key 与 value:

```swift
let dictionary = ["firstName":"Mango","lastName":"Fang"]
for (key,value) in dictionary{
    print(key+" "+value)
}
```

***
### 关于 Switch

Switch 在 Swift 中也得到了功能的增强与安全性的提高。

** 不需要 Break 来终止往下一个 Case 执行 **

也就是下面这两种写法是等价的。

```swift
let character = "a"

switch character{
    case "a":
        print("A")
    break
    case "b":
        print("B")
    break
default: print("character")
```


```swift
let character = "a"

switch character{
    case "a":
        print("A")
    case "b":
        print("B")
default: print("character")
```

这种改进避免了忘记写 break 造成的错误, 自己深有体会, 曾经就是因为漏写了 break 而花了一段时间去 debug。

如果我们想不同值统一处理, 使用逗号将值隔开即可。

```swift
switch some value to consider {
case value 1,value 2:
    statements
}
```

**Switch 支持的类型 **

在 OC 中, Switch 只支持 int 类型, char 类型作为匹配。

而在 Swift 中, Switch 支持的类型大大的拓宽了。实际上, 苹果是这么说的。
>  A switch statement supports any kind of data

这意味在开发中我们能够能够对字符串, 浮点数等进行匹配了。

之前在 OC 繁琐的写法就可以进行改进了:

```objective-c
if ([cardName isEqualToString:@"Six"]) {
    [self setValue:6];
} else if ([cardName isEqualToString:@"Seven"]) {
    [self setValue:7];
} else if ([cardName isEqualToString:@"Eight"]) {
    [self setValue:8];
} else if ([cardName isEqualToString:@"Nine"]) {
    [self setValue:9];
}
```

```swift
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
```

<h2 id="3">3. 函数 </h2>

对于在 OC 中, 方法有两种类型, 类方法与实例方法。方法的组成由方法名, 参数, 返回值组成。

在 Swift 中函数的定义基本与 OC 一样。

主要区别为：

1. 通过 `func` 关键词定义函数
2. 返回值在 `->` 关键词后标注

各举一个类方法与实例方法例子。

```objevtive-c
+ (UIColor*)blackColor
- (void)addSubview:(UIView *)view
```

对应的 swift 版本

```swift
   	class func blackColor() -> UIColor // 类方法, 通过 class func 关键词声明
	func addSubview(view: UIView) // 实例方法
```

### 改进：

- 在 Swift 中, 函数的最重要的改进就是函数作为一等公民 (first-class), 和对象一样可以作为参数进行传递, 可以作为返回值, 函数式编程也成为了 Swift 支持的编程范式。

> In computer science, a programming language is said to have first-class functions if it treats functions as first-class citizens. Specifically, this means the language supports passing functions as arguments to other functions, returning them as the values from other functions, and assigning them to variables or storing them in data structures

让我们初略感受一下函数式编程的魅力:

举一个例子, 我们要筛选出一个数组里大于 4 的数字。

在 OC 中我们可能会用快速枚举来进行筛选。

```objective-c
   NSArray *oldArray = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    NSMutableArray *newArray;
    for (NSNumber* number in oldArray) {
        if ([number compare:@4] == NSOrderedDescending ) {
            [newArray addObject:number];
        }
    }
```

而在 Swift 中, 我们用两行代码解决这个问题：

```swift
let oldArray = [1,2,3,4,5,6,7,8,9,10]
let newArray = oldArray.filter({$0> 4})
```

进一步了解 Swift 的函数式编程可以通过这篇优秀的博客 [Functional Reactive Programming in Swift](http://blog.callmewhy.com/2015/05/11/functional-reactive-programming-1/#)

- 个人觉得另外一个很棒的改进是：`Default parameter values`

	在我们的项目中, 经常会不断进行功能的增添。为了新增特性, 许多方法在开发的过程中不断变动。举一个例子：我们开始有一个 tableViewCell, 它的设置方法一开始简单地需要一个 Model 参数：

	```swift
	func configureCellWithModel(Model: model)
	```

	不久之后, 我们想对部分 Cell 增添一个设置背景颜色的功能。方法需要再接收多一个参数：

	```swift
	func configureCellWithModel(Model: model,color:UIColor)
	```

	这个时候方法改变, 所以涉及到这些方法的地方都需要修改。给我们造成的困扰
	一是：需要做许多重复修改的工作。
	二是：无法做得很好的扩展和定制, 有些地方的 cell 需要设置颜色, 有些不需要。但是在 OC 里, 我们只能对所有的 cell 都赋值。你可能觉得我们可以写两个方法, 一个接收颜色参数, 一个不接受。但是我们知道这不是一个很好的解决方法, 会造成冗余的代码, 维护起来也不方便。

	而在 Swift 中,`default parameter values` 的引入让我们能够这样修改我们的代码：

	```swift
	func configureCellWithModel(Model: model,color:UIColor = UIColor.whiteColor())
	```

	这样的改进能让我们写出的代码更具向后兼容性, 减少了我们的重复工作量, 减少了犯错误的可能性。



<h2 id="4">4. 类与初始化（Initializers）</h2>

- 文件结构与访问控制

在 swift 中, 一个类不再分为 `interface`（.h）与 `implementation`(.m) 两个文件实现, 直接在一个. swift 文件里进行处理。好处就是我们只需管理一份文件, 以往两头奔波修改的情况就得到解放了, 也减少了头文件与实现文件不同步导致的错误。

这时我们会想到, 那么我们如何来定义私有方法与属性呢, 在 OC 中我们通过在 `class extension` 中定义私有属性, 在. m 文件定义私有方法。

而在 Swift 中, 我们通过 `Access Control` 来进行控制。

>properties, types, functions 等能够进行版本控制的统称为实体。

>- Public：可以访问自己模块或应用中源文件里的任何实体，别人也可以访问引入该模块中源文件里的所有实体。通常情况下，某个接口或 Framework 是可以被任何人使用时，你可以将其设置为 public 级别。
- Internal：可以访问自己模块或应用中源文件里的任何实体，但是别人不能访问该模块中源文件里的实体。通常情况下，某个接口或 Framework 作为内部结构使用时，你可以将其设置为 internal 级别。
- Private：只能在当前源文件中使用的实体，称为私有实体。使用 private 级别，可以用作隐藏某些功能的实现细节


一个小技巧, 如果我们有一系列的私有方法, 我们可以把它们组织起来, 放进一个 extension 里, 这样就不需要每个方法都标记 private, 同时也便于管理组织代码：

```swift
// MARK: Private
private extension ViewController {
    func privateFunction() {
    }
}
```

- 创建对象与 `alloc` 和 `init`

关于初始化, 在 Swift 中创建一个对象的语法很简洁：只需在类名后加一对圆括号即可。

```swift
var shape = Shape()
```

而在 Swift 中,`initializer` 也与 OC 有所区别, Swift 的初始化方法不返回数据。而在 OC 中我们通常返回一个 self 指针。

> Unlike Objective-C initializers, Swift initializers do not return a value. Their primary role is to ensure that new instances of a type are correctly initialized before they are used for the first time.

Swift 的初始化方法让我们只关注对象的初始化。之前在 OC 世界中 [为什么要 self = [super init]？](http://www.zhihu.com/question/22295642)。这种问题得以避免。Swift 帮助我们处理了 alloc 的过程。也让我们的代码更简洁明确。

而在 Swift 中,`init` 也有了更严格的规则。

- 对于所有 `Stored Properties`, 都 ** 必须 ** 在对象被创建出来前设置好。也就是我们必须在 init 方法中赋好值, 或是直接给属性提供一个默认值。

	如果有 property 可以被允许在初始出来时没有值, 也就是需要在创建出来后再赋值, 或是在程序运行过程都可能不会被赋值。那么这个 property 必须被声明为 `optional` 类型。该类型的属性会在 init 的时候初始化为 nil.

- initializer 严格分为 `Designated Initializer` 和 `Convenience Initializer`
并且有语法定义。

	而在 Objective-C 中没有明确语法标记哪个初始化方式是 convenience 方法。关于 `Designated Initializer` 可参阅之前的:[Objective-C 拾遗：designated initializer](https://github.com/100mango/zen/blob/master/Objective-C%20%E6%8B%BE%E9%81%97%EF%BC%9Adesignated%20initializer/Objective-C%20%E6%8B%BE%E9%81%97%EF%BC%9Adesignated%20initializer.md)

	```swift
	init(parameters) {
		statements
	}

	convenience init(parameters) {
	 	statements
	}
	```



<h2 id="5">5. 枚举与结构体 </h2>

- 枚举

	在 Swift 中, 枚举是一等公民。(first-class)。能够拥有方法, computed properties 等以往只有类支持的特性。

	在 C 中, 枚举为每个成员指定一个整型值。而在 Swift 中, 枚举更强大和灵活。我们不必给枚举成员提供一个值。如果我们想要为枚举成员提供一个值 (raw value), 我们可以用字符串, 字符, 整型或浮点数类型。

	```swift
	enum CompassPoint {
  case North
  case South
  case East
  case West
	}

	var directionToHead = CompassPoint.West
	```

- 结构体

	Struct 在 Swift 中和类有许多相同的地方, 可以定义属性, 方法, 初始化方法, 可通过 extension 扩展等。

	不同的地方在于 struct 是值类型. 在传递的过程中都是通过拷贝进行。

	在这里要提到在前面第一节处提到了 `String`,`Array` 和 `Dictionary` 在 Swift 是以值类型出现的。这背后的原因就是 `String`,`Array`,`Dictionary` 在 Swift 中是通过 `Struct` 实现的。而之前在 Objective-C 它们都是通过 class 实现的。

	Swift 中强大的 Struct 使得我们能够更多与值类型打交道。Swift 的值类型增强了 ` 不可变性 (Immutabiliity)`。而不可变性提升了我们代码的稳定性, 多线程并发的安全性。

	在 WWDC2014《Advanced iOS Application Architecture and Patterns》中就有一节的标题是 * Simplify with immutability*。

	延伸阅读：[WWDC 心得：Advanced iOS Application Architecture and Patterns](https://github.com/100mango/zen/blob/master/WWDC%E5%BF%83%E5%BE%97%EF%BC%9AAdvanced%20iOS%20Application%20Architecture%20and%20Patterns/WWDC%E5%BF%83%E5%BE%97%EF%BC%9AAdvanced%20iOS%20Application%20Architecture%20and%20Patterns.md)


<h2 id="6">6. 协议 (Protocols) 与扩展(Extensions)</h2>

### 协议（Protocol）

语法:

在 Objective-C 中我们这么声明 Protocol:

```objective-c
@protocol SampleProtocol <NSObject>
- (void)someMethod;
@end
```

而在 Swift 中：

```swift
protocol SampleProtocol
{
    func someMethod()
}
```

在 Swift 遵循协议:

```swift
class AnotherClass: SomeSuperClass, SampleProtocol
{
    func someMethod() {}
}
```


`protocol` 和 `delegate` 是紧密联系的。那么我们在 Swift 中如何定义 Delegate 呢？

```swift
protocol MyDelegate : class {
}

class MyClass {
    weak var delegate : MyDelegate?
}
```

注意到上面的 protocol 定义后面跟着的 class。这意味着该 protocol 只能被 class 类型所遵守。

并且只有遵守了 class protocol 的 delegate 才能定义为 weak。这是因为在 Swift 中, 除了 class 能够遵守协议, 枚举和结构同样能够遵守协议。而枚举和结构是值类型, 不存在内存管理的问题。因此只需要 class 类型的变量声明为 weak 即可。

利用 Swift 的 optional chaining, 我们能够很方便的检查 delegate 是否为 Nil, 是否有实现某个方法:

以前我们要在 Objective-C 这样检查：

```objective-c
 if (self.dataSource && [self.dataSource respondsToSelector:@selector(titleForSegmentAtIndex:)]) {
        thisSegmentTitle = [self.dataSource titleForSegmentAtIndex:index];
    }
```

在 Swift 中, 非常的优雅简洁。

```swift
if let thisSementTitle = dataSource?.titleFroSegmentAtIndex?(index){
}
```


新特性:

在 Swift 中, protocol 变得更加强大, 灵活：

1. `class`,`enum`,`structure` 都可以遵守协议。

2. `Extension` 也能遵守协议。利用它, 我们不需要继承, 也能够让系统的类也遵循我们的协议。

	例如：

	```swift
	protocol myProtocol {
   	 func hello() -> String
	}

	extension String: myProtocol{
   	 func hello() -> String {
   	     return "hello world!"
   	 }
	}
	```

	我们还能够用这个特性来组织我们的代码结构, 如下面的代码所示, 将 UITableViewDataSource 的实现移到了 Extension。使代码更清晰。

	```swift
	// MARK: - UITableViewDataSource
	extension MyViewcontroller: UITableViewDataSource {
  	// table view data source methods
	}
	```

3. `Protocol Oriented Programming`

	随着 Swift2.0 的发布, 面向协议编程正式也加入到了 Swift 的编程范式。Cool.

	这种编程方式通过怎样的语法特性支撑的呢？

	那就是我们能够对协议进行扩展 (`protocol extensions`), 也就是我们能够提供协议的默认实现, 能够为协议添加新的方法与实现。

	用前面的 myProtocol 为例子, 我们在 Swift 里这样为它提供默认实现。

	```swift
	extension myProtocol{
        func hello() -> String {
            return "hello world!"
        }
	}
	```

	我们还能对系统原有的 protocol 进行扩展, 大大增强了我们的想象空间。Swift2.0 的实现也有很多地方用 extension protocol 的形式进行了重构。

	面向协议编程能够展开说很多, 在这里这简单地介绍了语法。有兴趣的朋友可以参考下面的资料：

	[Session 408: Protocol-Oriented Programming in Swift](https://developer.apple.com/videos/wwdc/2015/?id=408)

	[IF YOU'RE SUBCLASSING, YOU'RE DOING IT WRONG.](http://krakendev.io/blog/subclassing-can-suck-and-heres-why)

### 扩展（Extension）

`Extension` 在 Swift 在类似 Objective-C 的 `Category`。在 Objective-C 中, 我们用它来为已有的类添加新的方法实现。在 Swift 中, 我们不仅可以对类进行扩展, 而且能对结构体, 枚举类型, 协议进行扩展。

语法：

Objective-C：

```objective-c
#import "MyClass.h"

@interface MyClass (MyClassAddition)
- (void)hello;
@end
```

Swift：

```swift
extension SomeType {
	func hello(){}
}
```

与 Objective-C 的 Category 不同的是, Swift 的 `Extension` 没有名字。

我们还可以利用该特性来整理代码: 比如将私有方法集合在一起

```swift
private extension ViewController {
//... 私有方法
}
```

<h2 id="7">7.Swift 与 Cocoa</h2>

一门语言的的强大与否, 除了自身优秀的特性外, 很大一点还得依靠背后的框架。Swift 直接采用苹果公司经营了很久的 Cocoa 框架。现在我们来看看使用 Swift 和 Cocoa 交互一些需要注意的地方。

1. `id` 与 `AnyObject`

	在 Swift 中, 没有 `id` 类型, Swift 用一个名字叫 `AnyObject` 的 protocol 来代表任意类型的对象。

	```objective-c
	 id myObject = [[UITableViewCell alloc]init];
	```

	```swift
	 var myObject: AnyObject = UITableViewCell()
	```

	我们知道 id 的类型直到运行时才能被确定, 如果我们向一个对象发送一条不能响应的消息, 就会导致 crash。

	我们可以利用 Swift 的语法特性来防止这样的错误:

	```swift
	myObject.method?()
	```

	如果 myObject 没有这个方法, 就不会执行, 类似检查 delegate 是否有实现代理方法。

	在 Swift 中, 在 `AnyObject` 上获取的 property 都是 `optional` 的。

2. 闭包

	OC 中的 `block` 在 Swift 中无缝地转换为闭包。函数实际上也是一种特殊的闭包。

3. 错误处理

	之前 OC 典型的错误处理步骤:

	```objective-c
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *URL = [NSURL fileURLWithPath:@"/path/to/file"];
	NSError *error = nil;
	BOOL success = [fileManager removeItemAtURL:URL error:&error];
	if (!success) {
   	 NSLog(@"Error: %@", error.domain);
	}
	```

	在 Swift 中：

	```swift
	let fileManager = NSFileManager.defaultManager()
	let URL = NSURL.fileURLWithPath("/path/to/file")
	do {
   	 try fileManager.removeItemAtURL(URL)
	} catch let error as NSError {
   	 print("Error: \(error.domain)")
	}
	```

4. KVO

	Swift 支持 KVO。但是 KVO 在 Swift, 个人觉得是不够优雅的, KVO 在 Swift 只限支持继承 NSObject 的类, 有其局限性, 在这里就不介绍如何使用了。

	网上也出现了一些开源库来解决这样的问题。有兴趣可以参考一下:

	[Observable-Swift](https://github.com/slazyk/Observable-Swift)

	KVO 在 OS X 中有 Binding 的能力, 也就是我们能够将两个属性绑定在一起, 一个属性变化, 另外一个属性也会变化。对与 UI 和数据的同步更新很有帮助, 也是 MVVM 架构的需求之一。之前已经眼馋这个特性很久了, 虽然 Swift 没有原生带来支持, Swift 支持的泛型编程给开源界带来许多新的想法。下面这个库就是实现 binding 的效果。

	[Bond](https://github.com/SwiftBond/Bond)


<h2 id="8">8. 总结 </h2>

到这里就基本介绍完 Swift 当中最基本的语法和与 Objective-C 的对比和改进。

事实上 Swift 的世界相比 OC 的世界还有很多新鲜的东西等待我们去发现和总结, Swift 带来的多范式编程也将给我们编程的架构和代码的组织带来更来的思考。而 Swift 也是一个不断变化, 不断革新的语言。相信未来的发展和稳定性会更让我们惊喜。这篇文章也将随着 Swift 的更新而不断更新, 同时限制篇幅, 突出重点。

希望这篇文章能够给各位同行的小伙伴们快速了解和学习 Swift 提供一点帮助。有疏漏错误的地方欢迎直接提出。感谢。



--
参考：

1. [《The Swift Programming Language》](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language)
2. [Apple Swift Blog](https://developer.apple.com/swift/blog/)
3.  [Using Swift with Cocoa and Objective-C](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/BuildingCocoaApps/)


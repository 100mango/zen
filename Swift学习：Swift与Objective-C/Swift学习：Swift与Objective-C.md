#Swift学习：Swift与Objective-C


近来初学Swift。对于编程语言,我只是一个门外汉。编程语言的设计对我来说太遥远,编译器设计对我来说则太困难晦涩。那么本来静静地学习就好了,安心写代码即可。不过还是觉得学习这一新的语言,还是得更用心,因此决定写下这篇文章来总结与拓展学习Swift。

自己因为已经使用Objective-C有一些经验,因此决定在学习的过程将常用的语法作个对比,加深印象,尽可能地突出重点。也希望能够帮助已经有Objective-C经验的同仁们更快地了解Swift,尽一点绵薄之力。


##1.变量,常量,属性(property)和实例变量(instance variable)

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

	**值得注意的是string,array和Dictionary在Swift是以值类型(value type)而不是引用类型(reference type)出现,因此它们在赋值,初始化,参数传递中都是以拷贝的方式进行** 
	
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

因此之前使用OC导致的像巧哥指出的[开发争议](http://blog.devtang.com/blog/2015/03/15/ios-dev-controversy-1/)就不再需要争执了,在Swift的世界里,我们只与property打交道。个人觉得这看似小小一点变动使Swift开发变得更加安全以及在代码的风格更为统一与稳定。


##2.控制流

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


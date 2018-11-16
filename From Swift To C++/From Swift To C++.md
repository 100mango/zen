# From Swift To C++


[姊妹篇: 从 Objective-C 到 Swift](https://github.com/100mango/zen/blob/master/Swift%E5%AD%A6%E4%B9%A0%EF%BC%9A%E4%BB%8EObjective-C%E5%88%B0Swift/Swift%E5%AD%A6%E4%B9%A0%EF%BC%9A%E4%BB%8EObjective-C%E5%88%B0Swift.md)

C++ 除了在操作系统内核，编译器等高性能领域中发挥着关键作用，同时也是跨平台开发中不可或缺的角色。值得对底层优化和跨平台开发有兴趣的同学了解与学习。

Swift 和 C++ 初看起来是两种差异较大的语言。但是随着逐步深入了解，我们会发现他们有一个最大的共同点，那就是多范式编程。

这篇文章就按照编程范式（programming paradigm）来组织脉络（非严格划分，事实上不同编程范式都会用到许多相同的语法特性），下面就让我们从一个客户端工程师的角度来品味和对比这两门语言。

目录：

- [面向过程](#1)
	- 控制流
	- 函数
- [面向对象](#2)
	- 封装
	- 继承
	- 多态
	- 访问控制
	- 消息传递机制
- [类型系统](#3)
	- 强类型，静态类型
	- 类型推导
	- 值语义 引用语义
	- 类型转换 
- [内存管理](#4)
	- 智能指针
	- Optional
- [泛型编程](#5)
	- 实现模型
	- 泛型函数
	- 泛型类型
	- 类型约束
- [函数式编程](#6)
	- 闭包
- [并发编程](#7)


<h2 id="1">面向过程（Procedure Oriented Programming）</h2>


### 控制流（Control Flow ）

#### Selection: 

C++ 拥有 `if`  `switch` 语法。

而Swift除了拥有`if`和`else`, 还有`gurad`用于提前返回。

#### Loop:

C++ 拥有`do while` `while` `for(::)` `range-based for` 。

而Swift则拥有`repeat while` `while` 和 `for in`.
​	
值得一提的是， [Swift从 3.0 版本已经去掉了 C-Style 的 `for` 循环](https://github.com/apple/swift-evolution/blob/master/proposals/0007-remove-c-style-for-loops.md)
​	
而 C++11 加入的`range-based for` 和 Swift 的 `for in` 基本是异曲同工的。 
​	
```c++
std::map<string, int> testMap;

for (auto& item : testMap)
{
    cout << item.first << ":" << item.second << endl;
}
```

```swift
vat map: Dictionary<String:Int>;
for (key,value) in map {
}
```

另外 c++ 的 `switch` 能力也比较弱，只能够对整型，枚举或一个能隐式转换为整型或枚举类型的class进行判断. 而 Swift 的 `switch` 能力强大得多，基本能够判断所有类型，包括字符串，浮点数等等。

### 函数

C++ 的函数定义语法和 C 是一脉相承的。

C++ 和 Swift 一样，也支持指定参数的默认值(Default Parameter Values)：

```c++
int sum(int a, int b=20)
{
  int result;
 
  result = a + b;
  
  return result;
}
```

不过 C++ 因为缺少像 Swift 的 `Function Argument Labels`, 因此定义方法需要遵循：若给某一参数设置了默认值，那么在参数表中其后所有的参数都必须也设置默认值

调用时需要：若给已经设置默认值的参数传递实际值，则在参数表中被取代参数的左边所定义的所有参数，无论是否有默认值，都必须传递实际参数。

```c++
　void func(int a=1,int b，int c=3, int d=4)； //error
　void func(int a， int b=2，int c=3，int d=4)； //ok
　//不能直接选择给 a 和 c 赋值
　func(2,15,20)； 
```

而 Swift 则可以灵活地选择给哪个参数赋值：

```c++
func test(a :Int = 1, b:Int, c:Int = 3, d:Int = 4 ) {}
test(b:3, d: 5);
```

C++ 的函数初看没有什么可以挖掘的地方，但是当涉及面向对象，模板（泛型编程）时，就会有更多强大的语法特性显现出来。让我们继续耐心阅读下去。


#### 参考链接

[Swift Control Flow](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html)

[Range-based for loops](https://docs.microsoft.com/en-us/cpp/cpp/range-based-for-statement-cpp)



<h2 id="2">面向对象 (Object Oriented Programming)</h2>


### 封装

- 定义class:
	
	```c++
	class Person {
	  public:
	    int x;
	    void foo();
		
	  private:
	    float z;
	    void bar();
	}
	```

- 构造函数和析构函数（Constructors and Destructors）

  相当于Swift的Initialization和Deinitialization。

  ```c++
  class Foo {
    private:
      int x;
  
    public:
      Foo() : x(0) {
      }
  
      Foo(int x) : x(x) {
      }
      //上下两个构造方法是等价的。
      Foo(int x) {
      	this->x = x;
      }
  };
  ```
  注意到C++有个特殊构造方法语法叫`Initialization Lists`,用于初始化成员变量。

-	变量初始化语法：
	
	```c++
	//小括号初始化
	string str("hello");

	//赋值初始化
	string str = "hello";
	
	//花括号初始化  c++11后 都推荐这种初始化方法 uniform initialization
	vector<int> vec = {1,2,3}; //c++ 11 独有的  
	```
	
	[uniform initialization](https://mbevin.wordpress.com/2012/11/16/uniform-initialization/)
	

​
​	C++和Swift有个很大的区别，那就 C++ 如果定义变量时没有指定初值，则变量被默认初始化（default initialized），也就是会被自动赋值。个人觉得这不是一个好的语言特性, 最好还是像 Swift 一样强制需要显式初始化，这样代码不隐晦，一看就知道真正的初始化值。

### 继承

```swift
//Swift
class Person {}
class Employee: Person {}
```

```c++
//C++
class Person {
};
	
class Employee : public Person {
};
```
注意到 C++ 多了一个`public`关键词，这代表了 Person 类的 public members 在Employee 中还是 public 的。如果将`public`替换成`private`,则外界调用 Employee 时,父类 Person 的 public members 是不可见的。
​	
C++ 支持多继承。而 Swift 则可以通过 Protocol 和 Protocol Extension 来实现类似多继承的特性。

### 多态（Polymorphism）

我们来看看下面这段代码：

```c++
class Foo {
  public:
    int value() { return 5; }
};
	
class Bar : public Foo {
  public:
    int value() { return 10; }
};
	
Bar *b = new Bar();
Foo *f = (Foo*)b;
printf(“%i”, f->value());
// Output = 5
```

我们惊奇地发现，返回值是5,这和 Swift 的行为是不同的。这在 C++ 叫做 Static Binding。方法的调用在编译期就确定了。我们需要利用 C++ 的语法特性`virtual function`来实现多态。让方法的调用在运行时确定（dynamic binding）。
​	
```c++
class Foo {
  public:
    virtual int value() { return 5; }
};
	
class Bar : public Foo {
  public:
    virtual int value() override { return 10; }
};
	
Bar *b = new Bar();
Foo *f = (Foo*)b;
printf(“%i”, f->value());
// Output = 10
```

类似于 Swift 的 Protocol。在C++中，我们是通过 pure virtual function (or abstract function)来定义接口的。
​	
```c++
class Base
{
   int x;
public:
	//pure virtual function
    virtual void fun() = 0;
    int getX() { return x; }
};
 
// This class ingerits from Base and implements fun()
class Derived: public Base
{
    int y;
public:
	//c++11 用override显式表示重载虚函数
    virtual void fun() override { cout << "fun() called"; }
};
```

### 访问控制(Access Control)：

  c++也有访问控制，分为`public`,`private`,`protected`,`friend`。

  区别在于Swift是没有`protected`的,`protected`指子类也能访问和修改。

  `friend`是一个比较特别的控制语法，大多数编程语言都没有这个特性，C++中的友元机制允许类的非公有成员被一个类或者函数访问。

  值得注意的是：

  1. 在C++中，class 的默认访问控制是`private`,而 struct 或 union 则是`public`。

  2. 继承也需要指定访问控制。

    ```c++
    class Derived : Base  
    //上下是等价的。
    class Derived : private Base  
    ```

	如果不指定 public, 我们是无法在子类中使用父类的方法的。
    
参考链接：

[苹果对于为什么不支持protected的看法](https://developer.apple.com/swift/blog/?id=11)

### 消息传递机制 (Method Dispatch/Message passing)

C++ 和 Swift 都有 static dispatch 和 dynamic dispatch 两种消息传递机制。
​	
对于前者，Swift 和 C++ 都是编译时（compilation time）就确定了调用地址。
​	
对于后者，Swift 的 dynamic dispatch 有两种形式，一种是通过Objective-C的runtime进行分发。一种是通过和C++类似的`vtable`进行分发。
​	
除了标记为`final`,`private`,`@objc dynamic`的方法。Swift的方法都类似C++标记了`vitrual`的方法。


[How does iOS Swift Runtime work](https://stackoverflow.com/questions/37315295/how-does-ios-swift-runtime-work)

[Dynamic Dispatch in Object Oriented Languages](http://condor.depaul.edu/ichu/csc447/notes/wk10/Dynamic2.htm)



<h2 id="3">类型系统（Type System）</h2>


### 强类型，静态类型

和Swift一样，C++也是一个强类型（strongly typed），静态类型（statically typed）的编程语言。

从语法的角度来看：

强类型：一旦变量被指定某个数据类型，如果不经转换，即永远是此数据类型。

静态类型：变量类型在编译时就确定.
​	
静态类型又可以细分为：`manifest type`和`type-inferred`语言。`manifest type`需要我们显式指定变量的类型，如：int a。 而`type-inferred`则可以由编译器来帮我们推导类型。

### 类型推导 （Type Inference）

C++ 和 Swift 都具备类型推导的能力。

```c++
//c++
auto a = 1;
```

```swift
//swift
let a = 1 
```

C++ 的类型推导能力还能用在函数的返回类型中：

```c++
//c++14起支持
template<class T, class U>
auto add(T t, U u) { return t + u; } 
//the return type is the type of operator+(T, U)
```



### 值语义 引用语义 （value semantics and reference semantics）

C++ 不像 Swift 将类型明确分为 Reference Type 和 Value Type 。而是通过指针和引用来实现引用语义。**在C++中，classes 默认是 value types.**
​	
```c++
class Foo {
  public:
    int x;
};
	
void changeValue(Foo foo) {
    foo.x = 5;
}
	
Foo foo;
foo.x = 1;
changeValue(foo);
// foo.x still equals 1
```

需要指定pass a variable “by reference”.
​	
```c++
void changeValue(Foo &foo) {
    foo.x = 5;
}
	
Foo foo;
foo.x = 1;
changeValue(foo);
// foo.x equals 5
```

###  类型转换 ( Type Conversions ) 

1. 隐式类型转换 ( Implicit type conversions )

	Swift是没有隐式类型转换的，而C++有。
	
	```c++
	//成立
	float a = 1, double b = a; 
	//精度损失，会有warning
	double a = 1, float b = a;
	```
	
	个人不是很赞同隐式类型转换，我认为一个强类型语言的所有类型转换都应该是显式的。这样更统一和规范，也许隐式类型转换能够带来一点编写代码的便利性，但也隐藏了问题，特别是有精度损失的隐式转换。也许最好的做法是保留隐式类型转换，但是只允许`Widening conversions`，也即提高精度的转换。
	
2. 显示类型转换 ( Explicit conversions )

	现代C++通过`static_cast`，`dynamic_cast`, `const_cast`来进行显式类型转换。
	
	`dynamic_cast` 就类似Swift的 `as?`, 是安全的类型转换操作。
	
	```c++
	Base* b = new Base();  
	// Run-time check to determine whether b is actually a Derived*  
	Derived* d3 = dynamic_cast<Derived*>(b);  
	// If b was originally a Derived*, then d3 is a valid pointer.  
	if(d3)  
	{  
		d3->DoSomethingMore();
	}  
	```

参考链接：

[C++值语义](http://www.cnblogs.com/Solstice/archive/2011/08/16/2141515.html)

[面向对象编程中引用和const的结合](https://blog.csdn.net/lcj1105/article/details/50838441)

[类型系统](https://www.jianshu.com/p/336f19772046)


<h2 id="4">内存管理</h2>


### 智能指针

```c++
myPerson = nullptr;
myPerson->doSomething(); // crash!
```

在传统 C++里,一般用`new`和`delete`这两个语法进行内存管理，稍有不慎就会导致内存泄露等问题。
好在C++11也引入了引用计数进行内存管理。具体的语法关键词是使用`std::shared_ptr`，`std::weak_ptr`，`unique_ptr`。

`unique_ptr` : 只能有一个unique指针指向内存, 不存在多个unique指针指向同块内存

```c++
unique_ptr<T> myPtr(new T);       // Okay
unique_ptr<T> myOtherPtr = myPtr; // Error: Can't copy unique_ptr
```

`shared_ptr` 

```c++
// 初始化
shared_ptr<int> y = make_shared<int>();
shared_ptr<Resource> obj = make_shared<Resource>(arg1, arg2); // arg1, arg2是Resource构造函数的参数
```


`weak_ptr`

C++中提供了lock函数来实现该功能。如果对象存在，lock()函数返回一个指向共享对象的`shared_ptr`，否则返回一个空`shared_ptr`。

```c++
auto sharedPtr = make_shared<XXXDelegate>();
auto delegate =  weak_ptr<XXXDelegate>(sharedPtr);
if (auto unwrap = delegate->lock()) {
    unwrap->XXX();
}
```


C++ 开发者在使用智能指针的过程中总结出四句原则:

- 用`shared_ptr`，不用`new`

- 使用`weak_ptr`来打破循环引用

- 用`make_shared`来生成`shared_ptr`

- 继承`enable_shared_from_this`来使一个类能获取自身的`shared_ptr`

在自己实际开发的过程中，还总结出一个：如果一个对象在整个生命周期中会需要被智能指针所管理，那么一开始就要用智能指针管理。


参考链接：

[cpp-dynamic-memory](http://notes.maxwi.com/2016/03/25/cpp-dynamic-memory/)

[shared_ptr 原理及事故](https://heleifz.github.io/14696398760857.html)



### Optional:


```c++
optional<int> o = str2int(s); // 'o' may or may not contain an int
if (o) {                      // does optional contain a value?
  return *o;                  // use the value
}
```

c++的判断不是编译期强制的。没有像Swift一样的 unwrap 语法。还是需要自己判空，和指针判空类似，但是 Optional 的优点是能够表达一个非指针的对象是否为空。


<h2 id="5">泛型编程</h2>


C++ 有着比 Swift 更强大的泛型编程能力，但是代价就是语法和代码会更加晦涩。

### 实现模型（Implementation Model）

实际上 Swift 的泛型和 C++ 的泛型的实现模型有着本质区别。C++ 的泛型（模板）是在编译期生成每个类型具体的实现。而 Swift 则是利用类型信息和 Swift runtime来实现。 这个话题非常宏大艰深，涉及到编译器的底层细节，有兴趣的读者可以加以研究并分享。

在这里我们简单通过一个泛型函数来简单感受一下：

```c++
template <typename T>
T f(T t) {
    T copy = t;
    return copy;
}

f(1);
f(1.2);
```

c++ 的编译时会生成两份代码：

```c++
int f(int t) {
    int copy = t;
    return copy;
}

float f(float t) {
	float copy = t;
	return copy;
}
```

而 Swift：

```swift
func f<T>(_ t: T) ->T {
	let copy = t
	return copy
}
```

编译器实现则类似以下，不会为每个类型生成单独一份实现。

```c
void f(opaque *result,opaque *result,type *T) {
	//vwt: value witness table
	//利用类型信息来实现
	T->vwt->XXX(X);
}
```



### 泛型函数

Swift：

```swift
func genericSwap<T>(inout a:T,inout _ b:T){
    let temp = a
    a = b
    b = temp
}
```


C++:

```c++
template <typename T>
void swap(T &a, T &b) {
    T temp = a;
    a = b;
    b = temp;
}
```

### 泛型类型

```c++
template <typename T>
class Triplet {
  private:
    T a, b, c;

  public:
    Triplet(T a, T b, T c) : a(a), b(b), c(c) {}

    const T& getA() { return a; }
    const T& getB() { return b; }
    const T& getC() { return c; }
};
Triplet<int> intTriplet(1, 2, 3);
Triplet<float> floatTriplet(3.141, 2.901, 10.5);
```

c++通过在方法或类型前面定义`template <typename T>`，来定义类型参数（`type parameter`）

在Swift中泛型类型我们需要通过 typealias 暴露类型参数给外面。
在C++中，需要用typedef暴露给外面使用。

```c++
template <typename Reqest,typename Response>
class kindaBaseCgi {
public:   
    typedef Reqest RequestType;
    typedef Response ResponseType;
 }
```


### 类型约束

Swift有类型约束（`Type Constraints`）来约束类型参数继承某个类或遵循某个协议。

目前C++中，没有特别的语法来实现这个效果。我们需要借助`static_assert`在编译中检查类型：

```c++
template<typename T>
class YourClass {
    YourClass() {
        // Compile-time check
        static_assert(std::is_base_of<BaseClass, T>::value, "type parameter of this class must derive from BaseClass");
    }
}
```

在编写 C++ 模板代码的过程中，其实我觉得类型约束这个的重要性并不大。这归结于我们上面提到的语言对泛型的实现模式的不同。

考虑到如下的模板函数：

```c++
template <typename T>
T test(T a, T b) {
    return a + b;
}

test(1,2); //编译的时候，会为 int 生成实现

int test(int a, int b) {
    return a + b;
}

//而这个实例化（instantiation）后的函数是正确的，所以编译成功
```

而在 Swift 中：

```swift
//编译报错：Binary operator '+' cannot be applied to two 'T' operands
func test<T>(a:T, b:T) -> T {
    return a + b
}
```

Swift 因为需要靠类型信息和 runtime 来实现泛型。因此它需要知道 T 这个类型能够进行 `+` 操作。

```swift
//编译成功
func test<T:Numeric>(a:T, b:T) -> T {
    return a + b
}
```

C++ 编译成功与否决定于模板实例化的时候。这一特性非常强大，我们不需要一开始就提供所有信息给编译器。直到实例化时，编译器才会检查实现是否正确，是否该类型能够支持`+`操作。

C++ 还有一个Swift没有的强大特性，那就是`SFINEA`。 同时也引入了一个新的编程范式。那就是`Compile-time Programming`，这里暂不展开。


参考链接：

[Metaprogramming as a non-goal](https://forums.swift.org/t/design-question-metaprogramming-as-a-non-goal/1175)

[Implementing Swift Generics](https://www.youtube.com/watch?v=ctS8FzqcRug)

[c++20类型约束有望得到提升](http://en.cppreference.com/w/cpp/language/constraints)

[](https://stackoverflow.com/questions/16976819/sfinae-static-assert-vs-stdenable-if)




<h2 id="6">函数式编程</h2>

C++11 后，引入了闭包概念，使得 C++ 的函数式编程变得更简单清晰。

### 闭包（Closures）

在C++, 闭包被称为`lambda`.

```c++
auto y = [] (int first, int second)  
{  
    return first + second;  
};  

//显式声明
function<int(int, int)> f2 = [](int x, int y) { return x + y; };  
```

一个简单的闭包语法：

```
[ captures ] ( params ) -> ret { body }	
```

- Capturing Values：

在Swift中，闭包能够自动帮助我们捕获values。

```swift
let i = 10
let closure = { print(i) }
closure()
```

而c++需要开发者显式指定捕获变量。

```c++
auto i = 1;
auto closure = [] { std::cout << i << std::endl;};
//error: 'i' is not captured
```

```c++
auto i = 1;
auto closure = [=] { std::cout << i << std::endl;};
closure();
//编译成功
```



参考链接：

[C/C++语言中闭包的探究及比较](https://coolshell.cn/articles/8309.html)

[C++函数指针、函数对象与C++11 function对象对比分析](https://blog.csdn.net/skillart/article/details/52336303)

[](http://www.modernescpp.com/index.php/first-class-functions)


<h2 id="7">并发编程（ Concurrency Programming）</h2>

Swift 目前没有语言级别的并发编程机制，在业务开发中，我们通常通过`Grand Central Dispatch(GCD)` 进行并发编程，在此不再赘述。

从 C++11 开始，C++ 标准第一次承认多线程在语言中的存在，并在标准库中为多线程提供了组件。

我们可以通过这样的一个例子感受一下：

```c++
//Calling std::async with lambda function
std::future<std::string> resultFromDB = std::async([](std::string recvdData){
 
						std::this_thread::sleep_for (seconds(5));
						//Do stuff like creating DB Connection and fetching Data
						return "DB_" + recvdData;
 
					}, "Data");
```

但是深入使用，我们会非常 C++ 的并发编程使用起来会非常晦涩。比如并没有一个原生的线程池机制来保证性能和健壮性。也没有一个直观的机制在其他线程回调主线程，这在`GCD`中，只需要我们 disptach 到 mainQueue 即可。

针对客户端的跨平台开发，如果涉及到异步，Timer的时候，建议还是可以利用各个平台的上层组件。C++ 层负责定义接口，上层负责实现。

参考链接：

[std::async Tutorial & Example](https://thispointer.com/c11-multithreading-part-9-stdasync-tutorial-example/)

[Swift Concurrency Manifesto](https://gist.github.com/lattner/31ed37682ef1576b16bca1432ea9f782)

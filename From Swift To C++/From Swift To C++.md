# From Swift To C++

Swift 和 C++ 初看起来是两种差异比较大的语言，但是随着逐步深入了解。我们会发现他们有一个最大的共同点，那就是多范式编程。

这篇文案就按照编程范式来组织脉络，下面就让我们来品味和对比这两门语言。

## 面向对象

- 封装

	定义class:
	
	~~~c++
	class Person {
	  public:
	    int x;
	    void foo();
	
	  private:
	    float z;
	    void bar();
	}
	~~~

- 继承

	~~~swift
	//Swift
	class Person {}
	class Employee: Person {}
	~~~
	
	~~~c++
	//C++
	class Person {
	};
	
	class Employee : public Person {
	};
	~~~
	注意到C++多了一个public关键词，这代表了Person类的public members在Employee中还是public的。如果将public替换成private,则外界调用Employee时,父类Person的public members是不可见的。
	
	C++支持多继承。Swift则可以通过Protocol和Protocol Extension来实现类多继承。

- 多态（Polymorphism）

	~~~c++
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
	~~~
	
	我们惊奇地发现，返回值是5,这和Swift的行为是不同的。这在C++叫做Static Binding。方法的调用在编译期就确定了。我们需要利用C++的语法特性`virtual function`来实现类似Swift的行为。让方法的调用在Runtime确定（dynamic binding）。
	
	~~~c++
	class Foo {
	  public:
	    virtual int value() { return 5; }
	};
	
	class Bar : public Foo {
	  public:
	    virtual int value() { return 10; }
	};
	
	Bar *b = new Bar();
	Foo *f = (Foo*)b;
	printf(“%i”, f->value());
	// Output = 10
	~~~
	
	类似于Swift的Protocol。在C++中，我们是通过 pure virtual function (or abstract function)来定义接口的。
	
	~~~c++
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
	~~~

- 	访问控制(Access Control)：
	
	c++也有访问控制，分为`public`,`private`,`protected`。
	
	区别在于Swift是没有`protected`的,`protected`指子类也能访问和修改。
	
	值得注意的是：
	
	1. 在C++中，class的默认访问控制是`private`,而struct或union则是`public`。
	
	2. 继承也需要指定访问控制。

		~~~c++
		class Derived : Base  
		//上下是等价的。
		class Derived : private Base  
		~~~
		
		如果不指定public, 我们是无法在子类中使用父类的方法的。

		
	
	参考链接：
	
	[苹果对于为什么不支持protected的看法](https://developer.apple.com/swift/blog/?id=11)
	

- Method Dispatch/Message passing 消息传递机制

	Swift有static dispatch和dynamic dispatch两种消息传递机制。
	对于前者，Swift和C++都是编译时（compilation time）就确定了调用地址。
	对于后者，Swift的dynamic dispatch有两种形式，一种是通过Objective-C的runtime进行分发。一种是通过和C++类似的`vtable`进行分发。
	
	除了标记为final,private,dynamic(@objc)的方法或继承了NSObject的类的方法（Pure Swift，没利用Objective-C的Runtime）。Swift的方法都类似C++标记了`vitrual`的方法。


	[How does iOS Swift Runtime work](https://stackoverflow.com/questions/37315295/how-does-ios-swift-runtime-work)

- Constructors and Destructors
	
	相当于Swift的Initialization和Deinitialization。
	
	~~~c++
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
	~~~
	注意到C++有个特殊构造方法语法叫`Initialization Lists`,用于初始化成员变量。
	
	
	初始化语法：
	
	~~~c++
	//小括号初始化
	string str("hello");

	//赋值初始化
	string str = "hello";
	
	//花括号初始化  c++11后 都推荐这种初始化方法 uniform initialization
	vector<int> vec = {1,2,3}; //c++ 11 独有的  
	~~~
	
	[uniform initialization](https://mbevin.wordpress.com/2012/11/16/uniform-initialization/)
	
​
​	C++和Swift有个很大的区别，那就c++如果定义变量时没有指定初值，则变量被默认初始化（default initialized），也就是会被自动赋值。个人觉得这不是一个好的语言特性。

### 函数

c++和Swift一样，也支持指定参数的默认值(Default Parameter Values)：

~~~c++
int sum(int a, int b=20)
{
  int result;
 
  result = a + b;
  
  return result;
}
~~~

在 C++11 中，如果你愿意，你可以将返回值放在函数声明的最后，将auto放在返回值的位置：

~~~c++
auto sum(int a, int b) -> int;
~~~

为什么要怎么做呢？主要用于泛型编程。目前我们先了解有这个语法，避免看到代码时一脸懵逼。


### Standard Template Library (STL)

类似Swift的Foundation框架。C++也有它的基础框架，叫STL。在里面有许多完备的容器类型，基础类型供使用。


## 类型系统（Type System）

和Swift一样，C++也是一个强类型（strongly typed），静态类型（statically typed）的编程语言。

从语法的角度来看：

强类型：一旦变量被指定某个数据类型，如果不经转换，即永远是此数据类型。

静态类型：变量类型在编译时就确定.
​	
静态类型又可以细分为：`manifest type`和`type-inferred`语言。`manifest type`需要我们显式指定变量的类型，如：int a。 而`type-inferred`则可以由编译器来帮我们推导确定类型，如Swift中 let a = 1, C++中 auto a = 1;


- value semantics and reference semantics:

	C++不像Swift将类型明确分为 Reference Type 和 Value Type 。而是通过指针和引用来实现引用语义。**在C++中，classes 默认是 value types.**
	
	~~~c++
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
	~~~
	
	需要指定pass a variable “by reference”.
	
	~~~c++
	void changeValue(Foo &foo) {
	    foo.x = 5;
	}
	
	Foo foo;
	foo.x = 1;
	changeValue(foo);
	// foo.x equals 5
	~~~
	
	[C++值语义](http://www.cnblogs.com/Solstice/archive/2011/08/16/2141515.html)

-  类型转换 ( Type Conversions ) 

1. 隐式类型转换 ( Implicit type conversions )

	Swift是没有隐式类型转换的，而C++有。
	
	~~~c++
	//成立
	float a = 1, double b = a; 
	//精度损失，会有warning
	double a = 1, float b = a;
	~~~
	
	个人不是很赞同隐式类型转换，我认为一个强类型语言的所有类型转换都应该是显式的。这样更统一和规范，也许隐式类型转换能够带来一点编写代码的便利性，但也隐藏了问题，特别是有精度损失的隐式转换。也许最好的做法是保留隐式类型转换，但是只允许`Widening conversions`，也即提高精度的转换。
	
2. 显示类型转换 ( Explicit conversions )

	现代C++通过`static_cast`，`dynamic_cast`, `const_cast`来进行显式类型转换。
	
	`dynamic_cast` 就类似Swift的 `as?`, 是安全的类型转换操作。
	
	~~~c++
	Base* b = new Base();  
	// Run-time check to determine whether b is actually a Derived*  
	Derived* d3 = dynamic_cast<Derived*>(b);  
	// If b was originally a Derived*, then d3 is a valid pointer.  
	if(d3)  
	{  
		d3->DoSomethingMore();
	}  
	~~~


## 内存管理


### 智能指针

~~~c++
myPerson = NULL;
myPerson->doSomething(); // crash!
~~~

在传统 C++里,一般用`new`和`delete`这两个语法进行内存管理，稍有不慎就会导致内存泄露等问题。
好在C++11也引入了引用计数进行内存管理。具体的语法关键词是使用`std::shared_ptr`，`std::weak_ptr`，`unique_ptr`。

`unique_ptr` : 只能有一个unique指针指向内存, 不存在多个unique指针指向同块内存

~~~c++
unique_ptr<T> myPtr(new T);       // Okay
unique_ptr<T> myOtherPtr = myPtr; // Error: Can't copy unique_ptr
~~~

`shared_ptr` 

~~~c++
// 初始化
shared_ptr<int> y = make_shared<int>();
shared_ptr<Resource> obj = make_shared<Resource>(arg1, arg2); // arg1, arg2是Resource构造函数的参数
~~~


`weak_ptr`

C++中提供了lock函数来实现该功能。如果对象存在，lock()函数返回一个指向共享对象的`shared_ptr`，否则返回一个空`shared_ptr`。

~~~c++
auto sharedPtr = make_shared<XXXDelegate>();
auto delegate =  weak_ptr<XXXDelegate>(sharedPtr);
if (auto unwrap = delegate->lock()) {
    unwrap->XXX();
}
~~~


有四句原则可以记住:

- 用`shared_ptr`，不用`new`

- 使用`weak_ptr`来打破循环引用

- 用`make_shared`来生成`shared_ptr`

- 继承`enable_shared_from_this`来使一个类能获取自身的`shared_ptr`

在自己实际开发的过程中，还总结出：如果一个对象在整个生命周期中会需要被智能指针所管理，那么一开始就要用智能指针管理。

[cpp-dynamic-memory](http://notes.maxwi.com/2016/03/25/cpp-dynamic-memory/)

[shared_ptr 原理及事故](https://heleifz.github.io/14696398760857.html)



### Optional:

https://www.boost.org/doc/libs/1_66_0/libs/optional/doc/html/index.html

https://stackoverflow.com/questions/35296505/why-use-boostoptional-when-i-can-return-a-pointer

~~~c++
boost::optional<int> o = str2int(s); // 'o' may or may not contain an int
if (o) {                                 // does optional contain a value?
  return *o;                             // use the value
}
~~~

c++的判断不是编译期强制的。没有像Swift一样的unwrap语法。还是需要自己手写，C++中和指针判空的好处在于，能够表达一个非指针的对象是否为空。

## 错误处理机制


## 泛型编程

C++和Swift一样有着强大的泛型编程能力。

- 泛型函数

Swift：

~~~swift
func genericSwap<T>(inout a:T,inout _ b:T){
    let temp = a
    a = b
    b = temp
}
~~~


C++:

~~~c++
template <typename T>
void swap(T a, T b) {
    T temp = a;
    a = b;
    b = temp;
}
~~~

- 泛型类型

~~~c++
template <typename T>
class Triplet {
  private:
    T a, b, c;

  public:
    Triplet(T a, T b, T c) : a(a), b(b), c(c) {}

    T getA() { return a; }
    T getB() { return b; }
    T getC() { return c; }
};
Triplet<int> intTriplet(1, 2, 3);
Triplet<float> floatTriplet(3.141, 2.901, 10.5);
~~~

c++通过在方法或类型前面定义`template <typename T>`，来定义类型参数（`type parameter`）

在Swift中泛型类型我们需要通过typealias 暴露类型参数给外面。
在C++中，需要用typedef暴露给外面使用。

~~~c++
template <typename Reqest,typename Response>
class kindaBaseCgi {
public:   
    typedef Reqest RequestType;
    typedef Response ResponseType;
 }
~~~


- 类型约束

Swift有类型约束（`Type Constraints`）来约束类型参数继承某个类或遵循某个协议。

目前C++中，没有特别的语法来实现这个效果。我们需要借助`static_assert`在编译中检查类型：

~~~c++
template<typename T>
class YourClass {
    YourClass() {
        // Compile-time check
        static_assert(std::is_base_of<BaseClass, T>::value, "type parameter of this class must derive from BaseClass");
    }
}
~~~

[](https://stackoverflow.com/questions/16976819/sfinae-static-assert-vs-stdenable-if)
[未来的c++类型约束有望得到提升](http://en.cppreference.com/w/cpp/language/constraints)


c++有一个Swift没有的强大特性，那就是`SFINEA`。 同时也引入了一个新的编程范式。那就是`Compile-time Programming`.


- 类型推导


[c++类型推导](https://github.com/racaljk/EffectiveModernCppChinese/blob/master/1.DeducingTypes/item1.md)

### Control Flow 控制流

#### 定义变量

~~~c++
int x[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };  
for( auto &y : x ) { 
	print(y)  
}  
~~~

#### 循环

[Range-based for loops](https://docs.microsoft.com/en-us/cpp/cpp/range-based-for-statement-cpp)

~~~c++
std::map<string, string> testMap;

for (auto& item : testMap)
{
    cout << item.first << "-----" << item.second << endl;
}
~~~


### 闭包（Closures）

在C++, 闭包被称为`lambda`.

~~~c++
auto y = [] (int first, int second)  
{  
    return first + second;  
};  

//显式声明
function<int(int, int)> f2 = [](int x, int y) { return x + y; };  
~~~

一个简单的闭包语法：

~~~
[ captures ] ( params ) -> ret { body }	
~~~

- Capturing Values：

在Swift中，闭包能够自动帮助我们捕获values。

~~~swift
let i = 10
let closure = { print(i) }
closure()
~~~

而c++需要开发者显式指定捕获变量。

~~~c++
auto i = 1;
auto closure = [] { std::cout << i << std::endl;};
//error: 'i' is not captured
~~~

~~~c++
auto i = 1;
auto closure = [=] { std::cout << i << std::endl;};
closure();
//编译成功
~~~

[C/C++语言中闭包的探究及比较](https://coolshell.cn/articles/8309.html)




### DSL 

User-defined literals




#### 参考资料

https://docs.microsoft.com/en-us/cpp/cpp/cpp-type-system-modern-cpp


类型系统：https://www.jianshu.com/p/336f19772046
# a glance at java


## 面向过程

### loop

类似 C++ 的 `range-based for`, Swift 的 `for in`

~~~java
int[] numbers = 
     {1,2,3,4,5,6,7,8,9,10};
for (int item : numbers) {
 System.out.println("Count is: " + item);
}
~~~


### 函数

- Variadic Parameters




## 面向对象

### 封装

- 定义class

	~~~java
	class Person {
	    public String name;
	    private int age;
	    public String name;
	 }
	~~~
	
	和 Swift 的区别是，`Access Control`语法需要在每个字段，方法上面填加。如果不添加，则默认为 `package` 作用域。  和 Swift 的 `Internl` 作用域类似。
	
	
	一个Java源文件中最多只能有一个public类，当有一个public类时，源文件名必须与之一致，否则无法编译。



- 构造函数和析构函数（Constructors and Destructors）

这里要注意的是，因为 Java 的内存管理机制是` garbage collected `类型的，因此并没有对应 C++，Swift 的析构函数。

Java 有一个类似的方法：`finalize`, 不过在安卓实际的编程里面，我们基本都只依赖框架提供的 `onDestroy` 等方法来监听界面的生命周期。

### 继承

~~~java
class Student extends Person {
~~~

java 是单继承的。


另外一个特别的地方，就是 Java 的构造方法是不支持继承的。

~~~java

class A {
    
    public int a;
    A(int a) {
        this.a = a;
    }
    
}

class B extends A {
/*不写就会报错 */
    B(int a) {
        super(a);
    }
}
~~~

> If a constructor does not explicitly invoke a superclass constructor, the Java compiler automatically inserts a call to the no-argument constructor of the superclass. If the super class does not have a no-argument constructor, you will get a compile-time error. Object does have such a constructor, so if Object is the only superclass, there is no problem.



### 多态

~~~java
class Person {
    public void run() {
        System.out.println("Person.run");
    }
}

class Student extends Person {
    @Override
    public void run() {
        System.out.println("Student.run");
    }
}
~~~

covariant return type


#### Java 的 interface

类似于 Swift 的 Protocol, Java 对应的Interface.

Java8  后， Java的Interface 能够提供默认实现。


`anonymous class`


[](https://sylvanassun.github.io/2017/07/30/2017-07-30-JavaClosure/)


### Java 的 Nested Class

Java 关于 `Nested Classes` 有自己的一套规则。

Java 的 `Nested Classes` 分为两类：

- static Nested Classes.


Static Nested Classes 就类似 Swift 定义的嵌套类：

~~~swift
//Swift
class outer{
  var test = 2;

  class inner {
     init(){
       let example = test; //编译不通过
     }
   }
 }
~~~

~~~java
//java
class OuterClass {
    static class inner {
        //,,,,
    }
}
~~~


static nested classes 和 outer class 是独立的关系。outer class 在这里相当于提供一个命名空间。

- nonstatic Nested Classes (inner classes)

Java 比较独特的是他的 nonstatic nested class

~~~java
class OuterClass {
    int test = 2;
    class InnerClass {
    	void hello() {
    		print(test); //OK
    	}
    }
}
~~~

nonstatic Nested Classes 的生命周期是和 outer class 保持一致的。并且有outer class 成员变量的访问权限。

我们创建 nonstatic Nested Classes 实例，需要先创建出 outer class 实例、

~~~java
OuterClass.InnerClass innerObject = outerObject.new InnerClass();
~~~

### local classes,anonymous classes. 

local classes,anonymous classes 是两类特殊的 inner class


Java 的anonymous class 类似 C++ 中只能 capture by value 的lambda. 



为什么匿名类捕获需要是Final: [郭晋宇的回答比较清晰](https://www.zhihu.com/question/21395848)

[为什么必须是final的呢？ 里面给了Scala，C#是可以捕获的原因](https://cuipengfei.me/blog/2013/06/22/why-does-it-have-to-be-final/)


在 Java8 后，Java 支持了 `Lambda Expression`， 捕获机制和匿名类仍然一致。



## 命名空间

Java定义了一种名字空间，称之为包：package。一个类总是属于某个包，类名（比如Person）只是一个简写，真正的完整类名是包名.类名。


## 类型系统


### 强类型，静态类型



### 值语义 引用语义 （value semantics and reference semantics）

在Java中， 类型分为两种。

-  基本数据类型 （Primitive Data Types)

包括 `byte`、`short`、`int`、`long`、`float`、`double`、`boolean`、`char`。八种类型。

基本数据类型具备值语义。


- 引用类型  (Reference Data Types)

除基本类型外，所有类型都是引用类型，并且都是 `java.lang.Object` 的子类。


#### 不可变对象 

这个其实就类似 OC 的 NSString, 理解很简单，就是不能对这个对象做任何的修改。

~~~
String s1 = "ab";
String s2 = s1;
s1 = s1 + "c";  // 实际上这里， s1 已经指向了一个新的字符串对象了
System.out.println(s1 + " " + s2);     
//  abc ab    
~~~






## Java 的 Annotations

和其他语言比，算是一个比较新鲜的特性：

~~~
The predefined annotation types defined in java.lang are @Deprecated, @Override, and @SuppressWarnings.
~~~



## 泛型 Generics

In a nutshell, generics enable types (classes and interfaces) to be parameters when defining classes, interfaces and methods. Much like the more familiar formal parameters used in method declarations, type parameters provide a way for you to re-use the same code with different inputs. The difference is that the inputs to formal parameters are values, while the inputs to type parameters are types.


这段解释还不错。

Java 的泛型是 invariant 的




#### 参考资料：



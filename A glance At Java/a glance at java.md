# a glance at java



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


## 命名空间

Java定义了一种名字空间，称之为包：package。一个类总是属于某个包，类名（比如Person）只是一个简写，真正的完整类名是包名.类名。


## 类型系统


### 强类型，静态类型



### 值语义 引用语义 （value semantics and reference semantics）




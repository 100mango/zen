# Kotlin vs Swift


# Null safety

~~~kotlin
val b: String? = "Kotlin"
if (b != null && b.length > 0) {
    print("String of length ${b.length}")
} else {
    print("Empty string")
}
~~~

一个有意思的点：

> Note that this only works where b is immutable (meaning it is a local variable that is not modified between the check and its usage or it is a member val that has a backing field and is not overridable), because otherwise it could be the case that b changes to null after the check.


所以这个其实不是完全安全的。



kotlin 没有直接和  Swift `Optional Binding` 概念等价的语法。 

if let:

不过我们可以通过 ?.let  来判空并操作非空值。

~~~kotlin
item?.let { println(it) } 
~~~

guard let:

~~~kotlin
val parent = node.getParent() ?: return null
~~~

https://stackoverflow.com/questions/46723729/swift-if-let-statement-equivalent-in-kotlin
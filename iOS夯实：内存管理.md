#iOS夯实：内存管理

###基本信息
#####Objective-C 提供了两种内存管理方式。

1. MRR （manual retain-release） 手动内存管理  
	这是基于reference counting实现的,由NSObject与runtime environment共同工作实现。
	
2. ARC （Automatic Reference Counting）自动引用技术  
 	ARC使用了基于MBR同样的reference counting机制，区别在于系统在编译的时候帮助我们插入了合适的memory management method。
 	
#####Good Practices能有效的避免内存相关问题
基于内存，主要有两种错误 
 
1. 清空或覆盖了还在使用的内存  
	这种清空通常会导致应用崩溃，甚至用户数据遭到改写  
2. 没有清空已经不需要的内存会导致内存泄露  
   会导致系统性能下降，应用遭到系统终止
 
实际上，我们不应该只从reference counting的角度来管理内存，这样会让我们纠结于底层细节。我们应该站在object ownership and object graphs的角度来管理内存

可以用一幅这样的图来阐明：

![](memory_management.png)

###内存管理准则
基本的内存管理准则：为我们提供了这些准则

-  You own any object you create  
	我们通过名字前缀为“alloc”, “new”, “copy”, or “mutableCopy”的方法创建对象
	
- You can take ownership of an object using retain  
  通过retain来获取对象的ownership,使用retain主要有两种场景  
  1. 在accessor method 或 init method。来获取你想存储的对象的所有权
  2. 在某些场景里避免一个对象被移除，我们可以对它进行retain

- When you no longer need it, you must relinquish ownership of an object you own  
  当我们需要释放一个对象所有权时,我们通过对它发送release或autorelaese消息。
  
- You must not relinquish ownership of an object you do not own  
  不要释放你没有拥有的对象所有权
  
 关于dealloc:
 

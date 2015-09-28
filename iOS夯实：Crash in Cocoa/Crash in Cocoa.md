Crash in Cocoa

Cocoa中会导致Carsh的地方：

参考：

[Understanding and Analyzing iOS Application Crash Reports](https://developer.apple.com/library/ios/technotes/tn2151/_index.html)

[iOS Crash文件的解析](http://www.cnblogs.com/smileEvday/p/Crash1.html)

##Exceptions类型
##1. 集合类越界或插入Nil：

- 数组类型
 
	越界访问会crash
	
- 字典类型

	查询时: 
	
	~~~objective-c
	- (nullable ObjectType)objectForKey:(KeyType)aKey;
	~~~
	当key为nil。能够正常运行。
	
	插入时: 
	
	~~~objective-c
	- (void)setObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey;
	~~~
	插入时object和key任一为nil,都会crash

- 字符串类型

	获取substring时,越界访问会crash.
	
	包括:
	
	~~~objective-c
	- (NSString *)substringFromIndex:(NSUInteger)from;
	- (NSString *)substringToIndex:(NSUInteger)to;
	- (NSString *)substringWithRange:(NSRange)range;  
	~~~

##2. 访问悬挂指针（Dangling pointer）

悬挂指针,通常也被称为野指针。野指针,指的是指向不正确内存的指针。如果我们访问了不正确的内存,则会导致Crash。

那么什么情况下会导致野指针呢？

- 访问了已被release,但尚未置空的指针

	在MRC时代,如果我们提前释放了对象,并且没有把对象置空,再访问这个对象,则会Crash。
	
	~~~objective-c
	Person *mango = [[Person alloc]init];
	[mango release]; //object此时为野指针
	[mango setName:@"mango"]; // Crash:访问了野指针
	
	//正确做法
	Person *mango = [[Person alloc]init];
	[mango release] //object此时为野指针
	mango = nil;
	[mango setName:@"mango"]; //向nil发送消息,没有问题
	~~~

	在ARC时代,编译器会我们进行引用计数的管理。声明为strong,weak的属性,在对象引用计数为零后,自动释放内存,同时将指针置为nil。
	
	那是否就万事大吉了呢。
	
	事实上由于历史原因,UIKit等官方框架里,许多delegate还是声明为assgin而不是weak。(Apple:其实是我懒得改了 ：)
	
	声明为assgin和unsafe_unretained的对象,内存被释放后,编译器不会自动将指针置为nil。
	
	像`NSNetServices`的delegate,官方的头文件是这样：

	~~~objective-c
	@property (assign) id <NSNetServiceBrowserDelegate> delegate;
	~~~
	
	类似这样声明的delegate,如果delegate提前被释放,但是我们没有帮助官方的类将delegate置空,如果此时官方的类需要调用到delegate,则同样会造成Crash。
	
	解决方案: 
	
	遇到这种旧时代的官方delegate,为了安全起见,我们在dealloc将delegate置为nil
	
	~~~objective-c
	- (void)setService:(NSNetService *)service
	{
	    _service = service;
	    
	    self.service.delegate = self;
	    [self.service resolveWithTimeout:5];
	}
	
	- (void)dealloc
	{
	    // 避免悬挂指针
	    self.service.delegate = nil;
	}
	~~~

##3. 为不可为空的函数参数赋值nil

例如:
	
~~~objective-c
- (NSString *)stringByAppendingString:(NSString *)aString
//aString:
//The string to append to the receiver. This value must not be nil

//NSNotificationCenter
- (void)postNotification:(NSNotification * _Nonnull)notification
//notification
//The notification to post. This value must not be nil.

等等......
~~~
	
这种情况在Swift中已经不会再发生。Swift中Optional机制的引入。让我们不会因为忘记判空而导致Crash。
	
~~~swift
let cool = testStr.stringByAppendingString(nil)
//error: nil is not compatible with expected argument type 'String'
~~~
	
Crash in Cocoa

Cocoa中会导致Carsh的地方：

##1. 集合类越界：

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



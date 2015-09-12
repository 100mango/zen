Crash in Cocoa

Cocoa中会导致Carsh的地方：

##1. 集合类越界：

- 数组类型

	越界访问会crash
	
- 字典类型

	查询时: 
	objectForKey,key为nil。能够正常运行。
	
	插入时: 
	setObject:forKey:。object和key任一为nil,都会crash

- 字符串类型

	获取substring时,越界访问会crash.
	
	包括:
	
	~~~objective-c
	- (NSString *)substringFromIndex:(NSUInteger)from;
	- (NSString *)substringToIndex:(NSUInteger)to;
	- (NSString *)substringWithRange:(NSRange)range;  
	~~~



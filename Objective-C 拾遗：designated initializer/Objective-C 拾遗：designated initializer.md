#Objective-C 拾遗：designated initializer
--
###designated initializer是什么

> The initializer of a class that takes the full complement of initialization parameters is usually the designated initializer. [^1]

来自官方文档的介绍是designated initializer 通常是接收最多初始化参数的一个initializer


###designated initializer的作用
一个类通常会有一个提供便利初始化的initializer,它通常接收最多的初始化参数。而这个initializer便通常是designated initializer,一个类里面最重要的initializer。主要的implementation都写在这里。其他initializer则调用它即可,不需要重复写相关代码。

例如一个Task类，它有三个initializer

~~~objective-c
- (id)init;
- (id)initWithTitle:(NSString *)aTitle;
- (id)initWithTitle:(NSString *)aTitle date:(NSDate *)aDate;
~~~

则designated initializer便是

~~~objective-c
- (id)initWithTitle:(NSString *)aTitle date:(NSDate *)aDate;
~~~

其他初始化方法则是convenience initializer,通过调用designated initializer或其他initializer来完成初始化工作。

~~~objective-c
- (id)initWithTitle:(NSString *)aTitle {
    return [self initWithTitle:aTitle date:[NSDate date]];
}
 
- (id)init {
    return [self initWithTitle:@”Task”];
}
~~~

###designated initializer的使用
事实上 Swift同样也使用了designated initializer这样的概念。

而且更加严格地定义了designated initializer和它的使用规则。
详情可以查阅《The Swift Programming Language》。目前由于Swift还没有足够稳定,还没有花时间在上面。但是可以想象得到Swift有着非常好的前景。

使用的规则是基本一致的，我们在OC也是遵循这样的规则的。
>Rule 1
A designated initializer must call a designated initializer from its immediate superclass.

>Rule 2
A convenience initializer must call another initializer from the same class.

>Rule 3
A convenience initializer must ultimately call a designated initialize[^2]

规则可以用这样一幅图显示:

![](Designated Initializers and Convenience Initializers.png)

###个人心得

在自己的开发过程中,合理地遵守和运用designated initializer会减少许多重复代码。

并且理解了这一个概念,对整个Cocoa框架的理解也有帮助。
例如UIViewController的Designated initializer是

~~~objective-c
- (instancetype)initWithNibName:(NSString *)nibName
                         bundle:(NSBundle *)nibBundle
~~~

但是可能有人会发现,如果你直接使用 [[viewController alloc]init]来生产Controller,且你是使用XIB来组织界面的,那么最后你得到的ViewController的View还是来自XIB的。

这背后的原因就是Designated initializer帮你完成了这个工作。


> If you specify nil for the nibName parameter and you do not override the loadView method, the view controller searches for a nib file using other means.[^3]

不断学习,不断收获。深化与挖掘的结果不仅仅对开发有利,也满足了好奇心与求知欲。加油！

[^1]: [Cocoa Core Competencies](https://developer.apple.com/library/ios/documentation/General/Conceptual/DevPedia-CocoaCore/MultipleInitializers.html#//apple_ref/doc/uid/TP40008195-CH33-SW1)

[^2]: [Designated Initializers and Convenience Initializers](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html#//apple_ref/doc/uid/TP40014097-CH18-ID222)

[^3]: [UIViewController Class Reference](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/index.html#//apple_ref/occ/instp/UIViewController/nibName)
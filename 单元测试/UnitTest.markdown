# iOS单元测试入门指南

这篇文章主要帮助大家了解什么是单元测试，为什么要编写单元测试，如何编写单元测试，如何写出更好的单元测试。

## What

单元测试（unit testing）是指对软件中的最小可测试单元进行检查和验证。在 Objectice-C，Swift 中通常指对一个类，一个方法进行测试。

## Why

- 验证代码的正确性

	我们编写的代码基本上不能像数学一样通过形式证明（Formal proof）来保证正确性。但是我们能借助单元测试来保证代码的正确性。单元测试将我们的模块和代码分割成一个个的测试案例，我们通过无法发现错误来证明我们代码的正确性。正如Bob大叔在他的《Clean Architecture》一书所说的：“software is like a science. We show correctness by failing to prove incorrectness”

- 更好的代码

	我们希望借助单元测试来帮助我们设计良好可读的接口，写出高内聚，低耦合的代码。
当我们写完一个模块，经常会被其他人调用的接口时。就可以借助单元测试来验证我们代码是否如期运行。如果发现自己的接口和功能很难通过单元测试去验证，我们就需要审视我们的接口写得好不好，代码是否有提升的空间。

- 更好的文档

	一个好的单元测试就是一份优秀的文档。使用者只需看单元测试的代码，就能够明白如何使用这个模块，这个API。

- 更好的Debug

	单元测试能够帮助我们快速定位到bug，因为单元测试颗粒度小，我们能具体定位到是哪个函数，哪个测试案例出现了问题。如果当前的单元测试不能发现问题，我们可以写新的单元测试来验证问题，修复以后，以后就能每次对问题进行验证，防止问题重现。
	
- 更好的重构

	单元测试能够保证代码在修改后，仍然保持预期的功能，让重构和修改代码变得更稳健。
	

## How

在Xcode中进行单元测试是一件十分容易的事情，我们通过XCTest框架来进行单元测试。

1. 添加一个新的测试Target

	![](test.gif)


2. 编写单元测试

	~~~objective-c
	@interface WeChatTests : XCTestCase
	@end
	
	@implementation WeChatTests
	
	- (void)testOnePlusOne {
	    //Given
	    NSInteger a = 1;
	    NSInteger b = 1;
	    //When
	    NSInteger result = a + b;
	    //then
	    XCTAssertTrue(result == 2);
	}
	@end
	~~~
	
	可以看到编写单元测试的步骤是非常简单的。

	- 我们的单元测试是在`XCTestCase`的子类中进行
	- 每个以 test 为开头，无参数，无返回值的方法都是一个测试用例。
	- 我们通过断言来判断测试结果是否正确。 如上面的`XCTAssertTrue`。

	XCTest框架的详细使用教程，请查看：[XCTest简明指南](https://github.com/100mango/zen/blob/master/%E5%8D%95%E5%85%83%E6%B5%8B%E8%AF%95/XCTestCookBook.markdown)


## Guideline

我们知道如何编写单元测试后，更重要的是知道如何编写更好的单元测试。

### 代码组织

我们可以借助`BDD（行为驱动开发）`的理念来组织代码和思路：

`Given-When-Then` 模式:

以我们上面的简单测试为例：

~~~objective-c
- (void)testOnePlusOne {
    //Given
    NSInteger a = 1;
    NSInteger b = 1;
    //When
    NSInteger result = a + b;
    //then
    XCTAssertTrue(result == 2);
}
~~~

可以看到代码是以这样的顺序来组织的：

- Given：测试所需要的环境，相当于一个前置条件。

- When：触发被测事件，类似上面的算术运算。

- Then：验证结果，在这里就是我们的断言。


### 如何编写出优秀的单元测试
	
**FIRST** 原则

- Fast: 每个单元测试需要足够快，为了达到这个目的，我们的测试代码需要足够的精简。

- Isolated/Independent: 测试之间是独立的，一个测试不依赖另外一个测试，不依赖外部环境。

- Repeatable: 同一个测试，每次的测试结果是相同的。

- Self-validating：不需要人工检查来判断测试是正确还是错误的。在XCTest框架中，意味着我们通过断言来判断测试是否正确，不需要靠看日志等人工检查的方式。

- Thorough and Timely: 覆盖完整的的代码路径，包括错误的情况。理想的情况下，编写代码前，就先准备好单元测试（TDD）。

其他指南

- 单元测试需要由最熟悉代码的人（代码的编写者）来写。

	我们不能把测试的责任推脱给测试人员，作为代码的编写者，我们更能把握好代码的细节，边界情况。
	
- 单元测试应该集成到自动测试的框架中。

	以XCTest框架为例，我们可以把我们的测试继承到Jenkins中，每天定时运行，自动和及时发现问题。

### 何时需要单元测试

理想的情况下，我们所有的代码都有对应的单元测试。这是不现实的，但是有些单元测试的性价比是很高的，值得我们去做。

1. 频繁被调用或频繁变更的代码

	- 越是频繁被其他模块使用的代码，就越值得测试。像是最近我编写的XML和JSON的序列化和反序列化统一解决方案，就值得去做单元测测。这能保证我们底层模块，基础模块的稳定性和健壮性。
	- 越是频繁变更的代码，就越值得测试。这能够保证我们在修改代码时的稳定性和健壮性。

2. Debug

	- 在开发的过程中，单元测试可以用来测试易错的地方和边界情况。
	
	- 在维护的过程中，单元测试用来验证bug, 一旦修复后，我们可以确保这个Bug是修复了，并且以后也能一直被追踪。


## 总结

测试是工具而不是目的。我们希望通过测试来使得代码变得更健壮，更优雅，让Debug和重构变得更简单。

#### 参考资料

- Robert C. Martin.  《Clean Architecture:》
- [XCTest 测试实战](https://objccn.io/issue-15-2/)
- [INTRODUCING BDD](https://dannorth.net/introducing-bdd/)
- [Testing with Xcode](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/01-introduction.html)
- [单元测试要做多细？](https://coolshell.cn/articles/8209.html)
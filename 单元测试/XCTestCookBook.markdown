# XCTest试简明指南

## 创建测试

![](test.gif)


## 运行测试

点击运行测试的按钮，或快捷键cmd + U

![](runtest.png)


## 编写逻辑测试

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

- 我们的单元测试是在`XCTestCase`的子类中进行
- 每个以 test 为开头，无参数，无返回值的方法都是一个测试用例。
- 我们通过断言来判断测试结果是否是正确的。 如上面的`XCTAssertTrue`。


常用的断言有： 

~~~objective-c
 //直接输出错误
 XCTFail(...)
 //expression为空时通过  
 XCTAssertNil(expression, ...)
 //expresion不为空时通过
 XCTAssertNotNil(expression, ...)
 //expression为true时通过
 XCTAssert(expression, ...)
 //expression为true时通过
 XCTAssertTrue(expression, ...)
 //expression为false时通过
 XCTAssertFalse(expression, ...)
 //expression1和expression1地址相同时通过
 XCTAssertEqualObjects(expression1, expression2, ...)
 //expression1和expression1地址不相同时通过
 XCTAssertNotEqualObjects(expression1, expression2, ...)
 //expression1和expression1相等时通过
 XCTAssertEqual(expression1, expression2, ...)
 //expression1和expression1不相等时通过
 XCTAssertNotEqual(expression1, expression2, ...)
~~~

## 编写异步测试

~~~objective-c
- (void) testAsyncFunction {
    XCTestExpectation *exp = [self expectationWithDescription:@"异步操作出错"];
    
    //Given
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //When
        sleep(2);
        //Then
        XCTAssertEqual(@"a", @"a");
        //如果断言没问题，就调用fulfill宣布测试完成
        [exp fulfill];
    }];
    
    //设置延迟三秒后，如果还没调用fulfill,则报错
    [self waitForExpectationsWithTimeout:3 handler:nil];
}
~~~

异步测试的步骤也是很简单的：

1. 定义一个或者多个`XCTestExpectation`，代表我们想要得到的结果
2. 编写异步代码，断言，在异步代码的最后加上`fulfill`宣布测试完成
3. 调用`waitForExpectationsWithTimeout`设置延迟的时间，超过这段时间，异步测试就会判断为失败



## 编写性能测试

![](measure.png)

性能测试也是很简单的，调用`measureBlock`这个接口，将需要测试的代码作为block传递进去即可。XCTest会跑十遍代码。

console会输出执行的平均时间：

~~~python
Test Case '-[WeChatTests testPerformanceExample]'
measured [Time, seconds] average: 2.000, 
relative standard deviation: 0.018%, 
values: [2.001027, 2.000147, 2.000313, 2.000506, 2.000062, 2.000056, 2.000268, 2.000176, 2.000287, 2.001102]
~~~

我们可以修改`Baseline`来确定最长可执行的时间，修改`Max STDDEV`来确定上下浮动的范围。比如上图，我们修改`Baseline`为1s,而我们sleep了两秒，那么这个测试就失败了。

![](fail.png)
	
	
#### 参考资料

[苹果Testing文档](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/01-introduction.html)
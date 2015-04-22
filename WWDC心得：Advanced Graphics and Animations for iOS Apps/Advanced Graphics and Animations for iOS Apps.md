#WWDC2014
###Advanced Graphics and Animations for iOS Apps(session 419)
--

####1. Core Animation Pipeline

第一部分主要讲解了Core Animation的工作流程和渲染过程。

CoreAnimation的渲染流程可以用下图来概括:

![](rendering_pass.png)

在GPU的渲染过程中,我们能看到顶点着色器与像素着色器参与到图像的处理。

在objc.io中有一篇文章进一步地阐明了顶点着色器与像素着色器
([GPU 加速下的图像处理](http://objccn.io/issue-21-7/))


####2. UIBlurEffect

第二部分主要讲解了iOS8新引入的UIBlurEffect,结合第一部分来阐述UIBlurEffect是如何工作的。
事实上,个人觉得很有趣。就是UIBlurEffect为了优化图像处理效率,并没有

First Header  | Second Header
------------- | -------------
![](1.png)    | ![](2.png)

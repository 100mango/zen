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


####2. UIBlurEffectView

第二部分主要讲解了iOS8新引入的UIBlurEffectView,结合第一部分来阐述UIBlurEffectView是如何工作的,以及它们的性能。

事实上,个人觉得有一点很有趣。就是UIBlurEffect为了优化图像处理效率,并不是用普通的模糊算法过程。虽然Session中没提到模糊算法,我在这里简单地介绍一下简单的模糊算法。

最简单模糊的过程即是用中心像素与其周围像素的颜色算术平均值来代表模糊后的颜色值。我们可以在下面两幅图看到中心像素值的变化。

原始图像       |  中心像素模糊化
------------- | -------------
![](1.png)    | ![](2.png)



那么苹果是怎么做的呢？最有趣的一点是它并不是对原始图像直接模糊,而是先将图像缩放之后再进行模糊。这样的优点就是模糊算法需要处理的像素点就减少了,处理的效率会更快。

看到这里的时候我是笑了的,哈哈,觉得很机智。适当的把思维跳出来,"偷点懒",有时真的会取得很不错的效果。学习,学习。

其次就是水平模糊与竖直模糊后再合成,添加颜色。

![](UIVisualEffectView.png)

最后需要关注和有趣的一点是:苹果为我们提供了三个UIBlurEffect styles,   
分别为Extra light, Light, Dark.但是三者的耗费的资源各为不同。

Extra light耗费最多资源, Light其次, Dark最多。
![](UIVisualEffectView_cost.png)

我在自己的个人项目里也有用到UIBlurEffectView来美好,优化用户体验。两个项目都已经上架,并完整开源。欢迎去看看。

- [TouchColor](https://github.com/100mango/ColorPicker) 

	主要使用在主菜单界面。
	
- [QR Catcher](https://github.com/100mango/QRCatcher) 

	用在了实时蒙版,即类似微信二维码扫描框外的黑色半透明背景,在这里则是实时模糊,更美观。


####3. 图形性能
关于图形性能在之前关注的

- 关于CALayer的shouldRasterize（光栅化）

	当我们开启光栅化后
	- 如果展示的内容更新了,会有大量的offscreen渲染。
		
	CALayer的光栅化选项的开启与否需要我们仔细衡量使用场景。只能用在静态图像的绘制：

	- 避免静态内容的复杂特效的重绘,例如前面讲到的UIBlurEffect
	- 避免多个View嵌套的复杂View的重绘。

	而对于经常变动的内容,这个时候不要开启,否则会造成性能的浪费。




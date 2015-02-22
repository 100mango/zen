#WWDC 2014 
###A Straty For Great Work （session 237）
--
今年春节抽空看了几个WWDC session.分别简单总结一下。

这个session是由资深苹果工程师Ken Kocienda主讲，他参与了Safari，iOS的开发。Session由不同故事组成，不同故事引出了的不同心得。

对于个人来说，在闲暇时刻，是比较喜欢这种宏观层面，抛开代码来讲技术，讲开发的。这些演讲往往凝聚演讲者多年的经验，如果能够体会并运用到日常开发中，还是有非常高的价值的。

总的来说，虽然不是字字珠玑，但也是值得品味的。

>1.Know a good idea when you see it 
   

>2.Don't try to solve every problem at once 

>3.Find smart friends and listen to them 

>4.Work should explain itself

>5.Choose the simplest thing which might work 

>6.Only show your best work

>7.Iterating quickly leads to better work
 
>8.Rewrite 
>
> - Be kind to people, but be honest about work 
> - Separate yourself from your work 
> - You’re never done

值得一说的是，如果只空谈，是没有用的。还是需要实践，在看完Session的第二天，我开始重构一个别人遗留的聊天系统，虽然不是很复杂，但是由于使用的开源库部分API已经被deprecated了，并且需要重新熟悉和重构相关数据库。

刚开始的确觉得一团糟，想着是不是应该先用到的开源库先弄懂熟悉，把所有东西都彻底弄懂再着手写呢？

这个时候，我想到了昨天听到的故事，在Ken Kocienda开发Safari的时候，他们是从零开始的，从探索是否使用开源或商业方案，到一步步走过来，刚开始做的时候，是对KHTML源码进行编译，他们开始仅仅是着手解决头文件的引用问题，缺漏的地方，就用了很久。但是最后还是成功了，若是一开始就想着把东西都弄明白，是成效很慢，且效率低的。

因此，我便开始着手，从数据库开始看起，一边看一边注释，解决疏漏的地方。然后再对deprecated API进行替换完善。一步一步，真的感受到了Don't try to solve every problem at once这个心得。

大致就是如此，继续加油吧。春节假期还是偷懒了很久呢。


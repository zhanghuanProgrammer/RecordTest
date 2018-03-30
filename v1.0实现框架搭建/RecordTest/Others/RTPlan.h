
UI记录测试版本计划

v1.0 利用RAC 实现监听TableView的滚动👌
v1.1 利用Aspects 监听TableView的点击👌
v1.2 利用Aspects 监听按钮的点击👌
v1.2.1 利用Aspects 监听UIGestureRecognizer的点击👌
v1.3 利用RAC 监听UITextView和UITextFiled的文本输入👌

v2.0 实现一个悬浮球,这个悬浮球的功能有:进入设置界面,可以有提示效果,可以手动的点击下一步命令,可以手动的连续执行某些命令,还可以删除一些中间命令(在设置里面里面)等等👌
v2.1 实现进入某个页面后,会出现badge,提示与这个页面相关的可执行命令的个数,当然可以选择下一步,也可以选择连续执行这些命令👌
v2.2 记录事件时,都需要在上方提示记录了一条什么事件👌
v2.3 执行完了就变成绿色,执行失败就显示红色👌

v3.1 利用RAC 监听UISwitch的开关事件
v3.2 利用RAC 监听UISegement的选择事件
v3.3 利用RAC 监听UIProgress的数值滑动

v4.0 最有用的是让它可以自动执行所有命令 可以自动执行某一个,也可以自动执行选中的,也可以自动执行测试全部👌
v4.1 执行完后,记录所有结果,不管是成功还是失败

v5.0 每执行一步,进行截图,然后这些图片都可以查看,这写图片保存的时候必须是执行成功前的截图,否则页面可能会跳转,这样就截取不到图片了,图片保存到一个字典里面,key值是执行名称,value是截图保存的地址,然后依赖于,某个队列名称和操作时间,有两种方式,一种是文字方式,一种是截图模式(文字也有,浏览模式是左右切换)
v5.1 每录制一步,进行截图,并高亮标出控件,和描述文字,这些图片都必须依赖某个Identity和RTOperationQueueModel模型,因为录制的时候,有时候会有覆盖,此时如果不依赖的会出现下标错乱的问题,当添加RTOperationQueueModel时,就添加一个截图路径,当要删除的时候,就删除这个路径,并且把图片也删除,不要漏删,否则APP会变大,当要删除某个Identity时,就遍历里面的RTOperationQueueModel,陆续删除👌
v5.2 有时间把,执行每一步的截图,换成视频录制,这样可能占用存储空间也会大一些
v5.3 截图录制支持30天后自动删除

v6.0 引导页的制作,做个录制引导页的APP,来生成引导页,或者引用引导页的第三方库

v7.0 增加跳转到某个页面的功能,这个是需要记录的,或者使用popToVC来做

v7.1 资源可以导出来

遇到的BUG
0.遇到了难题,首先有些控件明明是这个标识符,可是就是不能准确的执行命令,还有就是如果网络加载慢,那么一秒钟执行一次命令就有点快了,这个时候出现命令丢失,导致后面的命令无法继续执行👌
1.我presentViewController进来的VC在dismiss只会,并不会触发原来vc的viewWillAppear:,所以会受到干扰👌
2.命令是可以删除的,因为有些命令的确没有必要存在,而且可能产生误操作👌
3.录制也是可以删除的👌
4.有些topvc本身没有显示,但是的确存在👌
5.一些命令的确是没用的,不该产生,应该在录制的时候就需要检查,后来检查发现,这些问题可能是kvo所有新控件之前,老控件被复用了,且被滚动等,也有可能是并没有完全显示出来之前,就被kvo了,然后执行操作时,执行到了那些不应该被执行到的控件,暂时通过viewDidAppear:之后,立马kvo所有新控件来解决这个问题👌
6.执行完以后,要自动转为停止执行的状态👌
7.解决多项卡的BUG,因为这样会导致相同的控制器,里面其实是不同的命令,但是全部都放在一起了
8.解决topVC的确存在,但是并没有任何显示出来的迹象(这个很难,因为一旦弄不好,就会导致一系列问题)
9.上下拉刷新问题
10.删除命令行时,正在执行的下标也要注意回退或者修改

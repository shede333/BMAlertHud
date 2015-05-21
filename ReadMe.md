# BMAlertHud

`create by shede333`


模仿系统的 **UIAlertView** ，但是 **UIAlertView** 不支持title 和 message 的文本格式自定义化；  
所以就仿照系统的 **UIAlertView** 原始功能，支持使用 **NSAttributedString** ，这样就可以自定义文本格式了，效果如下图;

###支持的功能：

* 支持 __叠加__ 的弹出 **多个** Alert框；
* 适配 **iOS6、7、8**，
* 弹框支持随着屏幕的 **方向旋转**而旋转

###未实现的功能

* 目前支持0、1、2个按钮，3个以上的按钮暂不支持


###使用方式

很简单，就一行代码，直接调用 **BMAlertHud**里的 **静态方法**即可

**注意**：  
	除了把 **BMAlertHud文件夹**拷贝过去加入你的工程里，还要记得把 **ThirdParty**文件夹也要拷贝过去加入你的工程里，因为 **ThirdParty**里面是我依赖的第三方库

###Other

当然，你也可以再次基础上，重写 **BMAlertView** 实现自己的AlertView，而其余的弹出、隐藏、旋转、适配等工作，你都可以不用做了。


![图片丢失](/show_picture/alert_horizental.png)

![图片丢失](/show_picture/alert_vertical.png)
// this project is my learning material ，this commit is used for my record。
这个项目是我用来学习的，评论文件是为了留下自己的学习记录。

从AppDelegate开始

1.关于KVO的知识，此中为 account.addObserver(self, forKeyPath: "accessToken", options: NSKeyValueObservingOptions(0), context: nil)的实现 ，当accessToken值改变后，会立即执行对应的响应函数

2.关于UICollectionViewController的了解，当其用编码方式实现了它会自动的内部创建一个View对象，通过collectionView属性可以直接访问到它
详情查看官网：https://developer.apple.com/library/ios/documentation/UIKit/Reference/UICollectionViewController_clas/index.html#//apple_ref/doc/uid/TP40012180

3.关于UIViewController 中tabBarItem属性的访问，这个是专门为它在被添加到a tab bar controller时使用，该属性第一次被访问的时候就会被创建，所以当UIViewController没作为tab view controller的孩子时，该属性不应该被访问。
详情查看官网：https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/index.html#//apple_ref/occ/instp/UIViewController/tabBarItem

4.什么在别的controller中可以直接访问AppDelegate中的方法，还有就是属性是否可以直接访问（待研究）

5.TableViewStyle中的两种类型，Plain  多为常规表格， Grouped多用于偏好设置类的表格。对Grouped的可以参考http://shrikar.com/xcode-6-tutorial-grouped-uitableview/

6.UIView的autoresizingMask属性的含义：
    UIViewAutoresizingNone就是不自动调整。
    UIViewAutoresizingFlexibleLeftMargin 自动调整与superView左边的距离，保证与superView右边的距离不变。
    UIViewAutoresizingFlexibleRightMargin 自动调整与superView的右边距离，保证与superView左边的距离不变。
    UIViewAutoresizingFlexibleTopMargin 自动调整与superView顶部的距离，保证与superView底部的距离不变。
    UIViewAutoresizingFlexibleBottomMargin 自动调整与superView底部的距离，也就是说，与superView顶部的距离不变。
    UIViewAutoresizingFlexibleWidth 自动调整自己的宽度，保证与superView左边和右边的距离不变。
    UIViewAutoresizingFlexibleHeight 自动调整自己的高度，保证与superView顶部和底部的距离不变。
    UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin 自动调整与superView左边的距离，保证与左边的距离和右边的距离和原来距左边和右边的距离的比例不变。比如原来距离为20，30，调整后的距离应为68，102，即68/20=102/30。

其它的组合类似。

7.UIButton 的创建（系统和自定义两种）和相关属性设置 详情可查看http://www.hangge.com/blog/cache/detail_529.html

8.UITableViewController中 numberOfSectionsInTableView 省略不写是否默认值为1.（待验证）

9.tableView.dequeueReusableCellWithIdentifier（），不是说有可能为nil吗 那么在什么情况下是nil，在该项目中第一次使用了，为什么可以直接使用  
    猜测：先注册后，再获取时应该是能保证获取实例对象

10.该项目中TextFieldTableViewCell的 extension UITableView 关于扩展的使用和具体含义（待验证）需要记住它的6种扩展规则

11.NSURLSession的使用，同时了解swift中的访问数据的所有方法（待验证）

12.NSJSONSerialization.JSONObjectWithData（） 的使用（待验证）

13.温习一下UIAlertView的使用（待学习）

14.uitableviewcontroller的生命周期

15.String 的 substringToIndex 的用法及advance的用法,count,startIndex ,endIndex
   a)advance(startIndex,stepNum),第一个参数为起始索引，第二个参数为前进步数，当为负值了就从后向前步进
   b)endIndex

16. UIKeyboardType输入键盘的类型有哪些，需要掌握(有11种，详见：http://jingyan.baidu.com/article/e75aca855a7c03142edac6c9.html)

17.UIBarButtonSystemItem的类型有24种 ，详见：http://m.blog.csdn.net/blog/thelma_yuan/39227553

18.键盘交互模式（3种）涉及到键盘的隐藏，响应更多的掌握（待验证）参考一个文档：http://www.tuicool.com/articles/j6VJRr
    case None
    case OnDrag // dismisses the keyboard when a drag begins
    case Interactive
19.图片的翻转UIImageOrientation，有8种，需要掌握(待学习)

20. if message.incoming != (tag == incomingTag) { 非常的不明白这句的含义

21.NSNotificationCenter的使用


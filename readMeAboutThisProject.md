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
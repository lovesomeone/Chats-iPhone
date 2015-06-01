import UIKit

//聚合视图显示所有好友
class UsersCollectionViewController: UICollectionViewController {
    convenience init() {
        //流式布局对象
        let layout = UICollectionViewFlowLayout()
        //布局中的元素项的大小
        layout.itemSize = CGSize(width: userCollectionViewCellHeight, height: userCollectionViewCellHeight)
        //同一行中每个项的最小间距
        layout.minimumInteritemSpacing = 1
        //每一行的最小间距
        layout.minimumLineSpacing = 1
        //内容到视图边缘的距离
        layout.sectionInset = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
        self.init(collectionViewLayout: layout)
        title = "Users"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置视图背景色白色，注册单元格UserCollectionViewCell
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView!.registerClass(UserCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UserCollectionViewCell))
    }

    // MARK: UICollectionViewDataSource

    //（显示元素项）的数量
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return account.users.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //获取单元格
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(UserCollectionViewCell), forIndexPath: indexPath) as! UserCollectionViewCell
        //获取每个单元格的实际填充数据，并进行单元格填充
        let user = account.users[indexPath.item]
        cell.nameLabel.text = user.name
        //如果用户有头像则创建显示图像，没有则置空
        if let pictureName = user.pictureName() {
            (cell.backgroundView as! UIImageView).image = UIImage(named: pictureName)
        } else {
            (cell.backgroundView as! UIImageView).image = nil
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
    //点击单元格后的响应方法
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //获取被点击元素项的数据
        let user = account.users[indexPath.item]
        //新建ProfileTableViewController对象并传递值给它，然后进行压栈
        navigationController?.pushViewController(ProfileTableViewController(user: user), animated: true)
    }
}

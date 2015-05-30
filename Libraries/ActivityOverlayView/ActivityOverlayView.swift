import UIKit
/**
* ActivityOverlayView 为用户操作后的提升小窗口，呈现在窗口的最上层
*它由一个圆角灰黑色矩形背景，一个UIActivityIndicatorView组件、一个UILabel组件
* 首次使用时调用它的静态方法sharedView（）来实例化对象
*/
class ActivityOverlayView: UIView {
    //私有对象，通过view tag 标识来获取
    private var activityIndicatorView: UIActivityIndicatorView {
        return self.viewWithTag(1) as! UIActivityIndicatorView
    }
    //通过view tag来获取对象
    var titleLabel: UILabel {
        return self.viewWithTag(2) as! UILabel
    }
    //静态方法，获取ActivityOverlayView对象
    class func sharedView() -> ActivityOverlayView {
        //获取应用顶层窗口
        let topWindow = UIApplication.sharedApplication().windows.last as! UIWindow
        //通过view tag在顶层窗口查找ActivityOverlayView
        var activityOverlayView = topWindow.viewWithTag(147) as! ActivityOverlayView!
        //如果没找到则新建一个对象实例
        if activityOverlayView == nil {
            activityOverlayView = ActivityOverlayView()
            activityOverlayView.tag = 147
        }
        return activityOverlayView
    }
    //私有构造方法
    private init() {
        //指定本组件的大小 128*128
        super.init(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
        //设置它和父容器间的位置关系：下固定、右固定、上固定、左固定
        autoresizingMask = .FlexibleTopMargin | .FlexibleLeftMargin | .FlexibleBottomMargin | .FlexibleRightMargin
        //设置背景颜色和图像的圆角值
        backgroundColor = UIColor(white: 0, alpha: 0.75)
        layer.cornerRadius = 10
        //创建活动指示器，指定样式，设置中心点和tag属性，把它添加到本组件中
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.center = CGPoint(x: 128/2, y: 128/2)
        activityIndicatorView.tag = 1
        self.addSubview(activityIndicatorView)

        //创建Label,设置它的坐标和大小及各种属性，并把它添加到本组件中
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 128-20-16, width: 128, height: 20))
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(16)
        titleLabel.tag = 2
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(titleLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //显示标题文本
    func showWithTitle(title: String) {
        //获取Application属性并暂停交互响应事件
        let sharedApplication = UIApplication.sharedApplication()
        sharedApplication.beginIgnoringInteractionEvents()
        activityIndicatorView.startAnimating()
        titleLabel.text = title
        //设置本组件的中心点坐标和UIWindow的一致，并把本组件添加到UIWindow中
        let topWindow = sharedApplication.windows.last as! UIWindow
        center = topWindow.center
        topWindow.addSubview(self)
    }

    //解除动画
    func dismissAnimated(animated: Bool) {
        UIView.animateWithDuration(animated ? 0.3 : 0, animations: {
            self.alpha = 0 // fade
        }, completion: { (finished) -> Void in
            //把本组件从UIWindow中移除，继续交互响应事件
            self.removeFromSuperview()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        })
    }
}

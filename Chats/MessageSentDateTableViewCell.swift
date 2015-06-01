import UIKit

//发送消息的时间的显示组件
class MessageSentDateTableViewCell: UITableViewCell {
    let sentDateLabel: UILabel  //常量

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        //创建UILabel并设置它的属性
        sentDateLabel = UILabel(frame: CGRectZero)
        sentDateLabel.backgroundColor = UIColor.clearColor()
        sentDateLabel.font = UIFont.systemFontOfSize(11)
        sentDateLabel.textAlignment = .Center
        sentDateLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)

        //初始化该组件 ，并且把sentDateLabel添加到视图中
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        contentView.addSubview(sentDateLabel)

        //添加sentDateLabel的约束，否则显示不了，因为前面设置成了CGRectZero
        // Flexible width autoresizing causes text to jump because center text alignment doesn't animate
        sentDateLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: sentDateLabel, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: sentDateLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 13))
        contentView.addConstraint(NSLayoutConstraint(item: sentDateLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -4.5))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

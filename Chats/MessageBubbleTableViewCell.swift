import UIKit

let incomingTag = 0, outgoingTag = 1
let bubbleTag = 8

//消息冒泡显示视图
class MessageBubbleTableViewCell: UITableViewCell {
    let bubbleImageView: UIImageView //消息背景视图
    let messageLabel: UILabel        //消息文本

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        //创建视图对象，设置属性，开启交互功能
        bubbleImageView = UIImageView(image: bubbleImage.incoming, highlightedImage: bubbleImage.incomingHighlighed)
        bubbleImageView.tag = bubbleTag
        bubbleImageView.userInteractionEnabled = true // #CopyMesage

        //创建UILabel对象，默认大小为0，设置属性，关闭交互功能
        messageLabel = UILabel(frame: CGRectZero)
        messageLabel.font = UIFont.systemFontOfSize(messageFontSize)
        messageLabel.numberOfLines = 0
        messageLabel.userInteractionEnabled = false   // #CopyMessage

        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None

        //把消息背景视图添加到视图中，把UILabel添加到消息背景视图中
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)

        bubbleImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        messageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 4.5))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Width, relatedBy: .Equal, toItem: messageLabel, attribute: .Width, multiplier: 1, constant: 30))
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -4.5))

        bubbleImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .CenterX, relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterX, multiplier: 1, constant: 3))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .CenterY, relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterY, multiplier: 1, constant: -0.5))
        messageLabel.preferredMaxLayoutWidth = 218
        bubbleImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .Height, relatedBy: .Equal, toItem: bubbleImageView, attribute: .Height, multiplier: 1, constant: -15))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWithMessage(message: Message) {
        messageLabel.text = message.text

        if message.incoming != (tag == incomingTag) {
            var layoutAttribute: NSLayoutAttribute
            var layoutConstant: CGFloat

            if message.incoming {
                tag = incomingTag
                bubbleImageView.image = bubbleImage.incoming
                bubbleImageView.highlightedImage = bubbleImage.incomingHighlighed
                messageLabel.textColor = UIColor.blackColor()
                layoutAttribute = .Left
                layoutConstant = 10
            } else { // outgoing
                tag = outgoingTag
                bubbleImageView.image = bubbleImage.outgoing
                bubbleImageView.highlightedImage = bubbleImage.outgoingHighlighed
                messageLabel.textColor = UIColor.whiteColor()
                layoutAttribute = .Right
                layoutConstant = -10
            }

            let layoutConstraint: NSLayoutConstraint = bubbleImageView.constraints()[1] as! NSLayoutConstraint // `messageLabel` CenterX
            layoutConstraint.constant = -layoutConstraint.constant

            let constraints: NSArray = contentView.constraints()
            let indexOfConstraint = constraints.indexOfObjectPassingTest { (var constraint, idx, stop) in
                return (constraint.firstItem as! UIView).tag == bubbleTag && (constraint.firstAttribute == NSLayoutAttribute.Left || constraint.firstAttribute == NSLayoutAttribute.Right)
            }
            contentView.removeConstraint(constraints[indexOfConstraint] as! NSLayoutConstraint)
            contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: layoutAttribute, relatedBy: .Equal, toItem: contentView, attribute: layoutAttribute, multiplier: 1, constant: layoutConstant))
        }
    }

    // Highlight cell #CopyMessage
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        bubbleImageView.highlighted = selected
    }
}

//消息呈现的图像框
let bubbleImage = bubbleImageMake()

func bubbleImageMake() -> (incoming: UIImage, incomingHighlighed: UIImage, outgoing: UIImage, outgoingHighlighed: UIImage) {
    //创建信息发送出去的背景图片MessageBubble
    let maskOutgoing = UIImage(named: "MessageBubble")!
    //创建信息接受到的背景图片——把上面的图片进行加工处理就好了
    let maskIncoming = UIImage(CGImage: maskOutgoing.CGImage, scale: 2, orientation: .UpMirrored)!
    //新建接受的消息显示的边距 （？？值是怎么来的？）
    let capInsetsIncoming = UIEdgeInsets(top: 17, left: 26.5, bottom: 17.5, right: 21)
    //新建发生的消息显示的边距 （？？值是怎么来的？）
    let capInsetsOutgoing = UIEdgeInsets(top: 17, left: 21, bottom: 17.5, right: 26.5)

    let incoming = coloredImage(maskIncoming, 229/255, 229/255, 234/255, 1).resizableImageWithCapInsets(capInsetsIncoming)
    let incomingHighlighted = coloredImage(maskIncoming, 206/255, 206/255, 210/255, 1).resizableImageWithCapInsets(capInsetsIncoming)
    let outgoing = coloredImage(maskOutgoing, 43/255, 119/255, 250/255, 1).resizableImageWithCapInsets(capInsetsOutgoing)
    let outgoingHighlighted = coloredImage(maskOutgoing, 32/255, 96/255, 200/255, 1).resizableImageWithCapInsets(capInsetsOutgoing)

    return (incoming, incomingHighlighted, outgoing, outgoingHighlighted)
}

//对图像进行RGB处理
func coloredImage(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage! {
    let rect = CGRect(origin: CGPointZero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    CGContextSetRGBFillColor(context, red, green, blue, alpha)
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop)
    CGContextFillRect(context, rect)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

import UIKit

//验证码输入框视图
class CodeInputView: UIView, UIKeyInput {
    //代理申明
    var delegate: CodeInputViewDelegate?
    var nextTag = 1

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Add four digitLabels
        var frame = CGRect(x: 15, y: 10, width: 35, height: 40)
        for index in 1...4 {
            let digitLabel = UILabel(frame: frame)
            digitLabel.font = UIFont.systemFontOfSize(42)
            digitLabel.tag = index
            digitLabel.text = "–"
            digitLabel.textAlignment = .Center
            self.addSubview(digitLabel)
            //每个label间隔15
            frame.origin.x += 35 + 15
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIResponder

    override func canBecomeFirstResponder() -> Bool {
        return true;
    }

    // MARK: - UIKeyInput

    func hasText() -> Bool {
        return nextTag > 1 ? true : false
    }

    //插入文本
    func insertText(text: String) {
        //当四个digitLabel没有全部输入时，通过tag获取它的当前输入label，把它赋值
        if nextTag < 5 {
            (self.viewWithTag(nextTag) as! UILabel).text = text
            ++nextTag
            //当输入最后一个文本时，获取整个文本输入，执行代理函数
            if nextTag == 5 {
                var code = (self.viewWithTag(1) as! UILabel).text!
                for index in 2..<nextTag {
                    code += (self.viewWithTag(index) as! UILabel).text!
                }
                delegate?.codeInputView(self, didFinishWithCode: code)
            }
        }
    }
    //从后向前删除一个输入文本
    func deleteBackward() {
        if nextTag > 1 {
            --nextTag
            (self.viewWithTag(nextTag) as! UILabel).text = "-"
        }
    }
    //清空输入文本
    func clear() {
        while nextTag > 1 {
            deleteBackward()
        }
    }

    // MARK: - UITextInputTraits
    //输入键盘的类型为数字
    var keyboardType: UIKeyboardType { get { return .NumberPad } set { } }
}

protocol CodeInputViewDelegate {
    func codeInputView(codeInputView: CodeInputView, didFinishWithCode code: String)
}

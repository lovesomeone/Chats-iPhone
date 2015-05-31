import UIKit

//验证码输入控制中心，当其为注册时，显示注册时的提示；当为登陆时，显示登陆的提示
class EnterCodeViewController: UIViewController, CodeInputViewDelegate, UIAlertViewDelegate {
    var signingUp = false

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        //创建信息提示标签，当为注册时，和登陆时，分别赋值。设置属性并把它添加到视图中
        let noticeLabel = UILabel(frame: CGRect(x: 20, y: 64, width: view.frame.width-40, height: 178))
        if signingUp {
            noticeLabel.text = "Sign Up\n\nNo user exists with the number above.\n\nTo sign up, enter the code we just sent you."
        } else {
            noticeLabel.text = "Log In\n\nA user exists with the number above.\n\nTo log in, enter the code we just sent you."
        }
        
        noticeLabel.textAlignment = .Center
        noticeLabel.numberOfLines = 0
        view.addSubview(noticeLabel)

        //创建验证码输入框，设置属性，并把它添加到视图中，同时设置输入框为第一响应对象
        let codeInputView = CodeInputView(frame: CGRect(x: (view.frame.width-215)/2, y: 242, width: 215, height: 60))
        codeInputView.delegate = self
        codeInputView.tag = 17
        view.addSubview(codeInputView)
        codeInputView.becomeFirstResponder()
    }

    // MARK: - CodeInputViewDelegate
    //代理协议的实现
    func codeInputView(codeInputView: CodeInputView, didFinishWithCode code: String) {
       //显示验证或者登陆的信息提示框
        let activityOverlayView = ActivityOverlayView.sharedView()
        activityOverlayView.showWithTitle(signingUp ? "Verifying" : "Loging In")

        // Create cod with phone number
        if signingUp {
            //创建服务器访问连接
            var request = formRequest("POST", "/keys", ["phone": title, "code": code])
            let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil) as! Dictionary<String, String>?

                dispatch_async(dispatch_get_main_queue(), {
                    activityOverlayView.dismissAnimated(true)
                    //当返回码为201时即为创建成功
                    switch statusCode {
                    case 201:
                        //根据服务器返回的key和先前的phone值来创建ProfileTableViewController对象，并设置属性，最后压栈到navigationController中
                        let profileTableViewController = ProfileTableViewController(phone: self.title!, key: dictionary!["key"]!)
                        profileTableViewController.setEditing(true, animated: false)
                        self.navigationController?.pushViewController(profileTableViewController, animated: true)
                    default:
                        //显示错误信息
                        UIAlertView(dictionary: dictionary, error: error, delegate: self).show()
                        break
                    }
                })
            })
            dataTask.resume()
        } else {
            //创建服务器访问连接
            var request = formRequest("POST", "/sessions", ["phone": title, "code": code])
            let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil) as! Dictionary<String, String>?

                dispatch_async(dispatch_get_main_queue(), {
                    activityOverlayView.dismissAnimated(true)

                    switch statusCode {
                    case 201:
                          //当返回码为201时即为创建成功,从返回数据中取出access_token的值
                        let accessToken = dictionary!["access_token"] as String!
                        let userIDString = accessToken.substringToIndex(advance(accessToken.endIndex, -33))
                        let userID = UInt(userIDString.toInt()!)
                        account.user = User(ID: userID, username: "", firstName: "", lastName: "")
                        account.accessToken = accessToken
                    default:
                        UIAlertView(dictionary: dictionary, error: error, delegate: self).show()
                        break
                    }
                })
            })
            dataTask.resume()
        }
    }

    // MARK: - UIAlertViewDelegate

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        (view.viewWithTag(17) as! CodeInputView).clear()
    }
}

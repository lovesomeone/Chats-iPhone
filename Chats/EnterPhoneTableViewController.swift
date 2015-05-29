import UIKit

class EnterPhoneTableViewController: UITableViewController {
    //在构造函数中设置默认值，方便外部调用初始化
    convenience init() {
        //设置表格的样式为Grouped类型
        self.init(style: .Grouped)
        //申明一个核查按钮并设置其响应方法，默认不可点击。并把它赋给导航栏的右侧按钮
        let verifyBarButtonItem = UIBarButtonItem(title: "Verify", style: .Done, target: self, action: "verifyAction")
        verifyBarButtonItem.enabled = false
        navigationItem.rightBarButtonItem = verifyBarButtonItem
       //设置UITableViewController的标题
        title = "Enter Phone Number"
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        //注册单元格id
        tableView.registerClass(TextFieldTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TextFieldTableViewCell))
        //声明一个试图，并设置它的属性，最后赋给tableView的footerview
        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44+32))
        tableFooterView.autoresizingMask = .FlexibleWidth
        tableView.tableFooterView = tableFooterView

        //创建一个guest按钮设置大小和坐标，并添加触控监听，并添加到tableFooterView中
        let continueAsGuestButton = UIButton.buttonWithType(.System) as! UIButton
        continueAsGuestButton.addTarget(self, action: "continueAsGuestAction", forControlEvents: .TouchUpInside)
        continueAsGuestButton.autoresizingMask = .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleTopMargin
        continueAsGuestButton.frame = CGRect(x: (view.frame.width-184)/2, y: 32, width: 184, height: 44)
        continueAsGuestButton.setTitle("Continue as Guest", forState: .Normal)
        continueAsGuestButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        tableFooterView.addSubview(continueAsGuestButton)
        
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //获取cell，并设置监听、设置属性
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TextFieldTableViewCell), forIndexPath: indexPath) as! TextFieldTableViewCell
        let textField = cell.textField
        textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
        textField.clearButtonMode = .WhileEditing
        textField.keyboardType = .NumberPad
        textField.placeholder = "Phone Number"
        textField.becomeFirstResponder()
        return cell
    }

    // MARK: - Actions

    func continueAsGuestAction() {
        continueAsGuest()
        
    }

    func textFieldDidChange(textField: UITextField) {
        //输入10个字符才开启验证
        let textLength = count(textField.text)
        navigationItem.rightBarButtonItem?.enabled = (textLength == 10)
    }

    func verifyAction() {
        let activityOverlayView = ActivityOverlayView.sharedView()
        activityOverlayView.showWithTitle("Connecting")

        // Create cod with phone number
        let phone = tableView.textFieldForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))!.text!
        var request = formRequest("POST", "/codes", ["phone": phone])
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            let statusCode = (response as! NSHTTPURLResponse).statusCode

            dispatch_async(dispatch_get_main_queue(), {
                activityOverlayView.dismissAnimated(true)

                switch statusCode {
                case 201, 200: // sign-up, log-in
                    let enterCodeViewController = EnterCodeViewController(nibName: nil, bundle: nil)
                    enterCodeViewController.title = phone
                    enterCodeViewController.signingUp = statusCode == 201 ? true : false
                    self.navigationController?.pushViewController(enterCodeViewController, animated: true)
                default:
                    let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil) as! Dictionary<String, String>?
                    UIAlertView(dictionary: dictionary, error: error, delegate: nil).show()
                }
            })
        })
        dataTask.resume()
    }
}

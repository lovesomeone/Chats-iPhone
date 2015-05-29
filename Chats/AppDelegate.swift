import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        //关注account对象中的accessToken的属性变化，当其变化时，本代理将进行相应的响应
        account.addObserver(self, forKeyPath: "accessToken", options: NSKeyValueObservingOptions(0), context: nil) // always

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        window!.rootViewController = UINavigationController(rootViewController: EnterPhoneTableViewController())
        window!.makeKeyAndVisible()
        return true
    }

    // MARK: NSKeyValueObserving

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
       println("执行了 observeValueForKeyPath")
        // 当accessToken的值不为nil时(即此时表明用户已经登录成功了)，根控制器为UITabBarController；当其为nil时（此时表明没有登录），根控制器为UINavigationController
        if account.accessToken != nil {
            window!.rootViewController = createTabBarController()
        } else {
            window!.rootViewController = UINavigationController(rootViewController: EnterPhoneTableViewController())
        }
    }
}

func createTabBarController() -> UITabBarController {
    // Create `usersCollectionViewController`
    //创建被UINavigationController包裹的UsersCollectionViewController,并声明了在 tab bar controller 中代表自己的图标 Users
    let usersCollectionViewController = UsersCollectionViewController()
    usersCollectionViewController.tabBarItem.image = UIImage(named: "Users")
    let usersNavigationController = UINavigationController(rootViewController: usersCollectionViewController)

    // Create `chatsTableViewController`
    //创建被UINavigationController包裹的ChatsTableViewController,并声明了在 tab bar controller 中代表自己的图标 Chats
    let chatsTableViewController = ChatsTableViewController()
    chatsTableViewController.tabBarItem.image = UIImage(named: "Chats")
    let chatsNavigationController = UINavigationController(rootViewController: chatsTableViewController)

    // Create `profileTableViewController`
    //创建被UINavigationController包裹的ProfileTableViewController，并把登录用户对象传递进去,并声明了在 tab bar controller 中代表自己的图标 Profile
    let profileTableViewController = ProfileTableViewController(user: account.user)
    profileTableViewController.tabBarItem.image = UIImage(named: "Profile")
    let profileNavigationController = UINavigationController(rootViewController: profileTableViewController)

    // Create `settingsTableViewController`
    //创建被UINavigationController包裹的SettingsTableViewController，并声明了在 tab bar controller 中代表自己的图标 Settings
    let settingsTableViewController = SettingsTableViewController()
    settingsTableViewController.tabBarItem.image = UIImage(named: "Settings")
    let settingsNavigationController = UINavigationController(rootViewController: settingsTableViewController)

    //创建被UITabBarController并指定它的viewControllers对象，
    let tabBarController = UITabBarController(nibName: nil, bundle: nil)
    tabBarController.viewControllers = [usersNavigationController, chatsNavigationController, profileNavigationController, settingsNavigationController]
    return tabBarController
}

func continueAsGuest() {
    //给登录账户赋值，作为静态数据值
    account.phone = "2102390602"
    account.user = User(ID: 24, username: "guest", firstName: "Guest", lastName: "User")
    //赋值后会立即执行KVO中的响应函数
    account.accessToken = "guest_access_token"
      
    let minute: NSTimeInterval = 60, hour = minute * 60, day = hour * 24
    account.chats = [
        Chat(user: User(ID: 1, username: "mattdipasquale", firstName: "Matt", lastName: "Di Pasquale"), lastMessageText: "Thatnks for checking out Chats! :-)", lastMessageSentDate: NSDate()),
        Chat(user: User(ID: 2, username: "samihah", firstName: "Angel", lastName: "Rao"), lastMessageText: "6 sounds good :-)", lastMessageSentDate: NSDate(timeIntervalSinceNow: -minute)),
        Chat(user: User(ID: 3, username: "walterstephanie", firstName: "Valentine", lastName: "Sanchez"), lastMessageText: "Haha", lastMessageSentDate: NSDate(timeIntervalSinceNow: -minute*12)),
        Chat(user: User(ID: 23, username: "benlu", firstName: "Ben", lastName: "Lu"), lastMessageText: "I have no profile picture.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -hour*5)),
        Chat(user: User(ID: 4, username: "wake_gs", firstName: "Aghbalu", lastName: "Amghar"), lastMessageText: "Damn", lastMessageSentDate: NSDate(timeIntervalSinceNow: -hour*13)),
        Chat(user: User(ID: 22, username: "doitlive", firstName: "中文 日本語", lastName: "한국인"), lastMessageText: "I have no profile picture or extended ASCII initials.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -hour*24)),
        Chat(user: User(ID: 5, username: "kfriedson", firstName: "Candice", lastName: "Meunier"), lastMessageText: "I can't wait to see you! ❤️", lastMessageSentDate: NSDate(timeIntervalSinceNow: -hour*34)),
        Chat(user: User(ID: 6, username: "mmorits", firstName: "Ferdynand", lastName: "Kaźmierczak"), lastMessageText: "http://youtu.be/UZb2NOHPA2A", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*2-1)),
        Chat(user: User(ID: 7, username: "krystalfister", firstName: "Lauren", lastName: "Cooper"), lastMessageText: "Thinking of you...", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*3)),
        Chat(user: User(ID: 8, username: "christianramsey", firstName: "Bradley", lastName: "Simpson"), lastMessageText: "👍", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*4)),
        Chat(user: User(ID: 9, username: "curiousonaut", firstName: "Clotilde", lastName: "Thomas"), lastMessageText: "Sounds good!", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*5)),
        Chat(user: User(ID: 10, username: "acoops_", firstName: "Tania", lastName: "Caramitru"), lastMessageText: "Cool. Thanks!", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*6)),
        Chat(user: User(ID: 11, username: "tpatteri", firstName: "Ileana", lastName: "Mazilu"), lastMessageText: "Hey, what are you up to?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*7)),
        Chat(user: User(ID: 12, username: "giuliusa", firstName: "Asja", lastName: "Zuhrić"), lastMessageText: "Drinks tonight?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*8)),
        Chat(user: User(ID: 13, username: "liang", firstName: "Sarah", lastName: "Lam"), lastMessageText: "Are you going to Blues on the Green tonight?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*9)),
        Chat(user: User(ID: 14, username: "dhoot_amit", firstName: "Ishan", lastName: "Sarin"), lastMessageText: "Thanks for open sourcing Chats.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*10)),
        Chat(user: User(ID: 15, username: "leezlee", firstName: "Stella", lastName: "Vosper"), lastMessageText: "Those who dance are considered insane by those who can't hear the music.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
        Chat(user: User(ID: 16, username: "elenadissi", firstName: "Georgeta", lastName: "Mihăileanu"), lastMessageText: "Hey, what are you up to?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
        Chat(user: User(ID: 17, username: "juanadearte", firstName: "Alice", lastName: "Adams"), lastMessageText: "Hey, want to hang out tonight?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
        Chat(user: User(ID: 18, username: "teleject", firstName: "Gerard", lastName: "Gómez"), lastMessageText: "Haha. Hell yeah! No problem, bro!", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
        Chat(user: User(ID: 19, username: "oksanafrewer", firstName: "Melinda", lastName: "Osváth"), lastMessageText: "I am excellent!!! I was thinking recently that you are a very inspirational person.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
        Chat(user: User(ID: 20, username: "cynthiasavard", firstName: "Saanvi", lastName: "Sarin"), lastMessageText: "See you soon!", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
        Chat(user: User(ID: 21, username: "stushona", firstName: "Jade", lastName: "Roger"), lastMessageText: "😊", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11))
    ]

    for chat in account.chats {
        account.users.append(chat.user)
    }
     
}

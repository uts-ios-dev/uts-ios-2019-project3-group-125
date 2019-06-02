
import UIKit


private let NavBarTitleFont = UIFont.systemFont(ofSize: 18, weight: .regular)

class MTBaseViewController: UIViewController {
    
    var animatedOnNavigationBar = true
    
    deinit {
        print("👻👻👻------------\(String(describing: self)) deinit")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = MTColor.pageback
        
        if #available(iOS 11.0, *) {
            if let view = self.view.subviews.first {
                if view.isKind(of: UIScrollView.self) {
                    (view as! UIScrollView).contentInsetAdjustmentBehavior = .never
                }
            }
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    
    
    /// 状态栏颜色设置
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage.image(withColor: MTNavigationBarBackgroundColor), for: .default)
        (navigationController as? MTNavigationController)?.titleColor = MTColor.title111
    }
    
}
extension MTBaseViewController {
    // 添加导航左侧按钮
    @discardableResult
    func addNavigationBarLeftButton(_ taget: Any, action: Selector = #selector(popBack), image: UIImage? = AppConfig.backImage) -> UIBarButtonItem {

        var leftItems = [UIBarButtonItem]()
        let backItem = UIBarButtonItem(image: image , style: .plain, target: self, action: action)
        //backItem.tintColor = .white
        leftItems.append(backItem)
        
        navigationItem.leftBarButtonItems = leftItems
        return backItem
    }
    
    // 添加导航右侧按钮
    @discardableResult
    func addNavigationBarRightButton(_ taget: Any, action: Selector, image: UIImage)  -> UIButton {
        let rightButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        rightButton.setImage(image, for: .normal)
        rightButton.addTarget(taget, action: action, for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem?.tintColor = MTColor.title222
        return rightButton
    }
    
    // 添加导航右侧按钮
    @discardableResult
    func addNavigationBarRightButton(_ taget: Any, action: Selector, text: String, color: UIColor? = MTColor.main) -> UIButton {
        let rightButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 68, height: 36))
        rightButton.contentHorizontalAlignment = .right
        rightButton.setTitle(text, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightButton.setTitleColor(color, for: .normal)
        rightButton.setTitleColor(color?.alpha(0.5), for: .highlighted)
        rightButton.addTarget(taget, action: action, for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        return rightButton
    }

}

func showSuccess(_ message: String) {
    AppDelegate.shared.window?.hideAllToasts()
    AppDelegate.shared.window?.makeToast(message, duration: 2.0, position: .center, image: #imageLiteral(resourceName: "toast_success")) { (didTap) in
        
    }
}


/// 显示信息，比如请求api 返回错误
///
/// - Parameters:
///   - message: 信息
///   - during: 时间  默认2秒
func showMessage(_ message: String?, during: Double = 2.0)  {
    guard let mess = message else {return}
    AppDelegate.shared.window?.hideAllToasts()
    ToastManager.shared.isTapToDismissEnabled = true
    var style = ToastStyle()
    style.messageFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    style.messageColor = UIColor.white
    style.messageAlignment = .center
    style.backgroundColor = UIColor.black
    style.cornerRadius = 4
    AppDelegate.shared.window?.makeToast(mess, duration: during, position: .center, style: style)

}



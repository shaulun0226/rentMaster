import UIKit


public protocol PresentMiddleVCProtocol {
    var controllerHeight: CGFloat {get}
    var controllerWidth: CGFloat {get}
}

///// a base class of vc to write bottom view
public class PresentMiddleVC: UIViewController, PresentMiddleVCProtocol {
    public var controllerHeight: CGFloat {
        return 0
    }
    public var controllerWidth: CGFloat {
        return 0
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentMiddleShouldHide), name: NSNotification.Name(PresentMiddleHideKey), object: nil)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(PresentMiddleHideKey), object: nil)
    }
    
    @objc func presentMiddleShouldHide() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
public let PresentMiddleHideKey = "ShouldHidePresentMiddle"


public class PresentMiddle:UIPresentationController {
    
    ///  黑色遮罩
    lazy var blackView: UIView = {
        let view = UIView()
        if let frame = self.containerView?.bounds {
            view.frame = frame
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sendHideNotification))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    /// 調整高度
    public var controllerHeight:CGFloat
    public var controllerWidth:CGFloat
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        //get height from an objec of PresentBottomVC class
        if case let vc as PresentMiddleVC = presentedViewController {
            controllerHeight = vc.controllerHeight
            controllerWidth = vc.controllerWidth
        } else {
            controllerHeight = UIScreen.main.bounds.width
            controllerWidth = UIScreen.main.bounds.height
        }
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    /// 在弹窗即将出现时把遮罩添加到containerView，并通过动画将遮罩的alpha设置为1
    public override func presentationTransitionWillBegin() {
        blackView.alpha = 1
        containerView?.addSubview(blackView)
        UIView.animate(withDuration: 0.1) {
            self.blackView.alpha = 1
        }
    }
    
    ///  在弹窗即将消失时通过动画将遮罩的alpha设置为0
    public override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.1) {
            self.blackView.alpha = 0
        }
//        blackView.removeFromSuperview()
    }
    
    /// 在弹框消失之后将遮罩从containerView上移除
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            blackView.removeFromSuperview()
        }
    }
    
    ///   决定了弹出框的frame
    public override var frameOfPresentedViewInContainerView: CGRect {
        let halfX = UIScreen.main.bounds.width/2
        return CGRect(x:  (UIScreen.main.bounds.width-controllerWidth)/2, y: (UIScreen.main.bounds.height-controllerHeight)/2, width: controllerWidth, height: controllerHeight)
    }

    
    @objc func sendHideNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PresentMiddleHideKey), object: nil)
    }
    
}

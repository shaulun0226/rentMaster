import UIKit

public protocol PresentBottomVCProtocol {
    var controllerHeight: CGFloat {get}
}

///// a base class of vc to write bottom view
public class PresentBottomVC: UIViewController, PresentBottomVCProtocol {
    public var controllerHeight: CGFloat {
        return 0
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentBottomShouldHide), name: NSNotification.Name(PresentBottomHideKey), object: nil)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(PresentBottomHideKey), object: nil)
    }
    
    @objc func presentBottomShouldHide() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


public let PresentBottomHideKey = "ShouldHidePresentBottom"

/// use an instance to show the transition
public class PresentBottom:UIPresentationController {
    
    
    
    ///  黑色遮罩
    lazy var blackView: UIView = {
        let view = UIView()
        if let frame = self.containerView?.bounds {
            view.frame = frame
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sendHideNotification))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    /// 調整高度
    public var controllerHeight:CGFloat
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        //get height from an objec of PresentBottomVC class
        if case let vc as PresentBottomVC = presentedViewController {
            controllerHeight = vc.controllerHeight
        } else {
            controllerHeight = UIScreen.main.bounds.width
        }
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
//    /// 在弹窗即将出现时把遮罩添加到containerView，并通过动画将遮罩的alpha设置为1
    public override func presentationTransitionWillBegin() {
        blackView.alpha = 1
        containerView?.addSubview(blackView)

    }

    ///  在弹窗即将消失时通过动画将遮罩的alpha设置为0
    public override func dismissalTransitionWillBegin() {
        
    }
////
    /// 在弹框消失之后将遮罩从containerView上移除
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            blackView.removeFromSuperview()
        }
    }
    
    ///   决定了弹出框的frame, 它决定了弹出框在屏幕中的位置，由于我们是底部弹出框，我们设定一个弹出框的高度controllerHeight，即可得出弹出框的frame
    public override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: UIScreen.main.bounds.height-controllerHeight, width: UIScreen.main.bounds.width, height: controllerHeight)
    }
  
    
    @objc func sendHideNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PresentBottomHideKey), object: nil)
    }
    
}

// MARK: - add function to UIViewController to call easily
extension UIViewController: UIViewControllerTransitioningDelegate {
    
    /// function to show the bottom view
    ///
    /// - Parameter vc: class name of bottom view
    public func presentBottom(_ vc: PresentBottomVC ) {
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical //由下跳轉的動畫
        self.present(vc, animated: true, completion: nil)
    }
    
    /// - Parameter vc: class name of bottom view
    public func presentMiddle(_ vc: PresentMiddleVC ) {
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve //直接跳轉的動畫
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    // function refers to UIViewControllerTransitioningDelegate
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        if  case let vc as PresentBottomVC = presented {
            let present = PresentBottom(presentedViewController: vc, presenting: presenting)
            return present
        }else if case let vc2 as PresentMiddleVC = presented{
            let present = PresentMiddle(presentedViewController: vc2, presenting: presenting)
            return present
        }

       return nil
    }
}

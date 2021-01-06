//
//  BaseMenuListViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/16.
//

import UIKit
import SideMenu
import SwiftAlertView

class BaseSideMenuViewController: BaseViewController,SideMenuControllerDelegate {
    
    var menu :SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMenu()
        //設定左邊button
        let btnSideMenu = UIButton(type: UIButton.ButtonType.custom)
        //        btnSideMenu.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        btnSideMenu.setBackgroundImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        btnSideMenu.addTarget(self, action:#selector(didTapMenu), for: .touchUpInside)
        btnSideMenu.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
        //設定右邊cart button
        //        let btnCart = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: self, action:#selector(didTapCart))
        let btnCart = UIButton(type: UIButton.ButtonType.custom)
        btnCart.setBackgroundImage(UIImage(systemName: "cart.fill"), for: .normal)
        btnCart.addTarget(self, action:#selector(didTapCart), for: .touchUpInside)//沒選touchUpInside會有重複點擊的可能
        btnCart.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
        //設定右邊ring button
        let btnNotify = UIButton(type: UIButton.ButtonType.custom)
        btnNotify.setBackgroundImage(UIImage(systemName: "bell.fill"), for: .normal)
        btnNotify.addTarget(self, action:#selector(didTapNotify), for: .touchUpInside)
        btnNotify.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
        //設定抽屜圖示的顏色
        btnSideMenu.tintColor = #colorLiteral(red: 0.5254901961, green: 0.8980392157, blue: 0.7960784314, alpha: 1)
        //設定右列圖示的顏色
        btnCart.tintColor = #colorLiteral(red: 0.5254901961, green: 0.8980392157, blue: 0.7960784314, alpha: 1)
        btnNotify.tintColor = #colorLiteral(red: 0.5254901961, green: 0.8980392157, blue: 0.7960784314, alpha: 1)
        let leftBarButton = UIBarButtonItem(customView: btnSideMenu)
        self.navigationItem.leftBarButtonItems = [leftBarButton]
        let rightCartButton = UIBarButtonItem(customView: btnCart)
        let rightNotifyButton = UIBarButtonItem(customView: btnNotify)
        self.navigationItem.rightBarButtonItems = [rightNotifyButton,rightCartButton]
    }
    @objc func didTapMenu() {
        present(menu!, animated: true)
    }
    @objc func didTapCart() {
        //尚未設定跳至何頁
        let storyboard = UIStoryboard(name: Storyboard.product.rawValue, bundle: nil)
        if let view = storyboard.instantiateViewController(withIdentifier: ProductStoryboardController.cartViewController.rawValue) as? CartViewController {
            view.title = "購物車"
            self.show(view, sender: nil);
        }
    }
    @objc func didTapNotify() {
        //設定popover
        let storyboard = UIStoryboard(name: Storyboard.main.rawValue, bundle: nil)
        if let popoverController = storyboard.instantiateViewController(withIdentifier: MainStoryboardController.notifyViewController.rawValue) as? NotifyViewController {
            //設定popoverview backgroundColor
            let layer = Global.setBackgroundColor(view);
            popoverController.view.layer.insertSublayer(layer, at: 0)
            //設定以 popover 的效果跳轉
            popoverController.modalPresentationStyle = .popover
            //設定popover的來源視圖
            popoverController.popoverPresentationController?.sourceView = self.view
            //下面註解掉的這行可以指定箭頭指的座標
            //            popoverController.popoverPresentationController?.sourceRect = buttonFrame
            popoverController.popoverPresentationController?.delegate = self
            //讓 popover 的箭頭指到 rightBarButtonItem。並且方向向上
            popoverController.popoverPresentationController?.permittedArrowDirections = .up
            popoverController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            //設定popover視窗大小
            popoverController.preferredContentSize = CGSize(width: 350, height: 500)
            //跳轉頁面
            present(popoverController, animated: true, completion: nil)
        }
    }
    
    func didSelectMenuItem(titleNamed: SideMenuSelectTitle, itemNamed: SideMenuItem) {
        //關閉抽屜
        menu?.dismiss(animated: true, completion: nil)
        let productStoryboard = UIStoryboard(name: Storyboard.product.rawValue, bundle: nil)
        let mainStoryboard = UIStoryboard(name: Storyboard.main.rawValue, bundle: nil)
        //設定畫面title的文字
        let selectedItem = itemNamed.rawValue
        //        let selectedTitle = titleNamed.rawValue
        //設定換頁
        var view = UIViewController()
        switch itemNamed {
        case .store:
            if(Global.isOnline){
                if (User.token.isEmpty){
                    let alertView = SwiftAlertView(title: "", message: "請先登入!\n", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "登入")
                    alertView.clickedCancelButtonAction = { 
                        alertView.dismiss()
                    }
                    alertView.clickedButtonAction = {[self] index in
                        if(index==1){
                            if let loginView = mainStoryboard.instantiateViewController(identifier:MainStoryboardController.login.rawValue ) as? LoginViewController{
                                //                            }
                                self.present(loginView, animated: true, completion: nil)
                            }
                        }
                    }
                    alertView.messageLabel.textColor = .white
                    alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
                    alertView.button(at: 1)?.backgroundColor = UIColor(named: "Button")
                    alertView.backgroundColor = UIColor(named: "Alert")
                    alertView.buttonTitleColor = .white
                    alertView.show()
                    return
                }
            }
            if let vcMain = productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productListController.rawValue) as? ProductListController{
                vcMain.navigationController?.navigationBar.prefersLargeTitles = true
                vcMain.isMyStore = true
                vcMain.slider.backgroundColor = .white
                vcMain.productType1 = "PS5"//暫時先用這個代替
                view = vcMain
            }
        case .home:
            if let vcMain = mainStoryboard.instantiateViewController(identifier: MainStoryboardController.mainPageViewController.rawValue) as? MainPageViewController{
                view = vcMain
            }
        case .ps4:
            if let vcMain = productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productListController.rawValue) as? ProductListController{
                vcMain.slider.backgroundColor = .blue
                vcMain.productType1 = "PS4"
                vcMain.isMyStore = false
                view = vcMain
            }
        case .ps5:
            if let vcMain = productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productListController.rawValue) as? ProductListController{
                vcMain.slider.backgroundColor = .blue
                vcMain.productType1 = "PS5"
                vcMain.isMyStore = false
                view = vcMain
            }
        case .series:
            if let vcMain = productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productListController.rawValue) as? ProductListController{
                vcMain.slider.backgroundColor = .green
                vcMain.productType1 = "Series"
                vcMain.isMyStore = false
                view = vcMain
            }
        case .one:
            if let vcMain = productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productListController.rawValue) as? ProductListController{
                vcMain.slider.backgroundColor = .green
                vcMain.productType1 = "One"
                vcMain.isMyStore = false
                view = vcMain
            }
        case .Switch:
            if let vcMain = productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productListController.rawValue) as? ProductListController{
                vcMain.slider.backgroundColor = .red
                vcMain.productType1 = "Switch"
                vcMain.isMyStore = false
                view = vcMain
            }
        case .boardgame:
            if let vcMain = productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productListController.rawValue) as? ProductListController{
                vcMain.slider.backgroundColor = .yellow
                vcMain.productType1 = "桌遊"
                vcMain.isMyStore = false
                view = vcMain
            }
        case .changePassword:
            if (User.token.isEmpty){
                let controller = UIAlertController(title: "尚未登入", message: "請先登入", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "登入", style: .default){(_) in
                    if let loginView = mainStoryboard.instantiateViewController(identifier:MainStoryboardController.login.rawValue ) as? LoginViewController{
                        self.show(loginView, sender: nil);
                    }
                }
                controller.addAction(okAction)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                controller.addAction(cancelAction)
                self.present(controller, animated: true, completion: nil)
                return
            }
            if let changePasswordView = Global.mainStoryboard.instantiateViewController(identifier: MainStoryboardController.changePasswordViewController.rawValue) as? ChangePasswordViewController{
                view = changePasswordView
            }
        case .logout:
            if (User.token.isEmpty){
                //設定UIAlertController的title,message
                let alertController = UIAlertController(title: "並未登入", message: "", preferredStyle: .alert)
                //設定ok的action按鈕
                let okAction = UIAlertAction(title: "確定", style: .default)
                //將action加入UIAlertController
                alertController.addAction(okAction)
                //彈出UIAlertController
                self.present(alertController, animated: true, completion: nil)
                return
            }else{
                //設定UIAlertController的title,message
                let controller = UIAlertController(title: "是否登出", message: "", preferredStyle: .alert)
                //設定ok的action按鈕，並加入按下後的動作
                let okAction = UIAlertAction(title: "確定", style: .default){(_) in
                    User.token = ""
                    let logoutController = UIAlertController(title: "帳號已登出", message: "", preferredStyle: .alert)
                    let logoutOkAction = UIAlertAction(title: "確定", style: .default)
                    logoutController.addAction(logoutOkAction)
                    self.present(logoutController, animated: true, completion: nil)
                }
                //將action加入UIAlertController
                controller.addAction(okAction)
                //設定cancel的action按鈕
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                //將action加入UIAlertController
                controller.addAction(cancelAction)
                //彈出UIAlertController
                self.present(controller, animated: true, completion: nil)
                return
            }
        case .memberCenter:
            if(Global.isOnline){
                if(User.token.isEmpty){
                    let alertView = SwiftAlertView(title: "", message: "請先登入!\n", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "登入")
                    alertView.clickedCancelButtonAction = {
                        alertView.dismiss()
                    }
                    alertView.clickedButtonAction = {[self] index in
                        if(index==1){
                            if let loginView = mainStoryboard.instantiateViewController(identifier:MainStoryboardController.login.rawValue ) as? LoginViewController{
                                //                            }
                                self.present(loginView, animated: true, completion: nil)
                            }
                        }
                    }
                    alertView.messageLabel.textColor = .white
                    alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
                    alertView.button(at: 1)?.backgroundColor = UIColor(named: "Button")
                    alertView.backgroundColor = UIColor(named: "Alert")
                    alertView.buttonTitleColor = .white
                    alertView.show()
                    return
                }
            }
            if let vcMain = Global.mainStoryboard.instantiateViewController(identifier: MainStoryboardController.memberCenterViewController.rawValue) as? MemberCenterViewController{
                vcMain.navigationController?.navigationBar.prefersLargeTitles = true
                view = vcMain
            }
        }
        
        //        view.title = selectedItem
        view.title = selectedItem
        self.show(view, sender: nil);
        
    }
    
    private func setMenu(){
        
        var sideMenulist = [SideMenuListModel]();
        //設定menu內容
        sideMenulist.append(SideMenuListModel.init(title: .store, item:[SideMenuItem.store]))
        sideMenulist.append(SideMenuListModel.init(title:.homePage, item: [SideMenuItem.home]))
        sideMenulist.append(SideMenuListModel.init(title:.ps, item: [SideMenuItem.ps5,SideMenuItem.ps4]))
        sideMenulist.append(SideMenuListModel.init(title: .xbox, item:[SideMenuItem.series,SideMenuItem.one]))
        sideMenulist.append(SideMenuListModel.init(title:.Switch, item:[ SideMenuItem.Switch]))
        sideMenulist.append(SideMenuListModel.init(title:.boardgame, item:[ SideMenuItem.boardgame]))
        sideMenulist.append(SideMenuListModel.init(title: .memberCenter, item: [SideMenuItem.memberCenter,SideMenuItem.changePassword,SideMenuItem.logout]))
        
        let menuListController = SideMenuController.init(with: sideMenulist)
        
        menuListController.delegate = self;
        //將menuListController設定進menu裡
        menu = SideMenuNavigationController(rootViewController: menuListController)
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        
        //設定手勢，因為tabbar的關係先關掉
        //        SideMenuManager.default.addPanGestureToPresent(toView: self.view);
        var set = SideMenuSettings()
        
        set.statusBarEndAlpha = 0
        //設定抽屜動畫
        set.presentationStyle = SideMenuPresentationStyle.menuSlideIn
        set.presentationStyle.presentingEndAlpha = 0.5
        
        //設定抽屜長度
        set.menuWidth = min(view.frame.width, view.frame.height) * 0.60
        //menu.sideMenuManager.addScreenEdgePanGesturesToPresent(toView: self.view)
        menu?.settings = set
        //SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
        //設定左邊抽屜為menu
        SideMenuManager.default.leftMenuNavigationController = menu
    }
}
extension BaseSideMenuViewController : UIPopoverPresentationControllerDelegate{
    //如果是iphone的話不會讓popover變成全螢幕
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
extension BaseSideMenuViewController:SwiftAlertViewDelegate{
    
}

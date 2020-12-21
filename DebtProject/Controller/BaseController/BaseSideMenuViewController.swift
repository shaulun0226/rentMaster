//
//  BaseMenuListViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/16.
//

import UIKit
import SideMenu

class BaseSideMenuViewController: BaseViewController,SideMenuControllerDelegate {
    
    var menu :SideMenuNavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setMenu()
        //設定左邊button
        let btnSideMenu = UIButton(type: UIButton.ButtonType.custom)
        btnSideMenu.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        btnSideMenu.addTarget(self, action:#selector(didTapMenu), for: .touchDragInside)
        btnSideMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        //設定右邊cart button
        let btnCart = UIButton(type: UIButton.ButtonType.custom)
        btnCart.setImage(UIImage(systemName: "cart"), for: .normal)
        btnCart.addTarget(self, action:#selector(didTapCart), for: .touchDragInside)
        btnCart.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        //設定右邊ring button
        let btnNotify = UIButton(type: UIButton.ButtonType.custom)
        btnNotify.setImage(UIImage(systemName: "bell"), for: .normal)
        btnNotify.addTarget(self, action:#selector(didTapNotify), for: .touchDragInside)
        btnNotify.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        //設定抽屜圖示的顏色
        btnSideMenu.tintColor = #colorLiteral(red: 0.01798310503, green: 0.9727620482, blue: 0.856649816, alpha: 1)
        //設定右列圖示的顏色
        btnCart.tintColor = #colorLiteral(red: 0.01798310503, green: 0.9727620482, blue: 0.856649816, alpha: 1)
        btnNotify.tintColor = #colorLiteral(red: 0.01798310503, green: 0.9727620482, blue: 0.856649816, alpha: 1)
        let leftBarButton = UIBarButtonItem(customView: btnSideMenu)
        self.navigationItem.leftBarButtonItems = [leftBarButton]
        let rightCartButton = UIBarButtonItem(customView: btnCart)
        let rightNotifyButton = UIBarButtonItem(customView: btnNotify)
        self.navigationItem.rightBarButtonItems = [rightNotifyButton,rightCartButton]
        // Do any additional setup after loading the view.
    }
    @objc func didTapMenu() {
            present(menu!, animated: true)
     }
    @objc func didTapCart() {
        //尚未設定跳至何頁
//            present(menu!, animated: true)
        
     }
    @objc func didTapNotify() {
        //尚未設定跳至何頁
//            present(menu!, animated: true)
        
     }
    
    func didSelectMenuItem(titleNamed: SideMenuSelectTitle, itemNamed: SideMenuItem) {
        //關閉抽屜
        menu?.dismiss(animated: true, completion: nil)
        let productStoryboard = UIStoryboard(name: "Product", bundle: nil)
        //設定畫面title的文字
        let selectedItem = itemNamed.rawValue
//        let selectedTitle = titleNamed.rawValue
        //設定換頁
        switch itemNamed {
        case .store:
            if let vcMain = productStoryboard.instantiateViewController(identifier: "AddProductViewController") as? AddProductViewController{
                vcMain.title = selectedItem
                self.show(vcMain, sender: nil);
            }
        case .home:
                if let vcMain = productStoryboard.instantiateViewController(identifier: "MainPageViewController") as? MainPageViewController{
                    vcMain.title = selectedItem
                    self.show(vcMain, sender: nil);
                }
        case .ps4:
            if let vcMain = productStoryboard.instantiateViewController(identifier: "ProductListView") as? ProductListController{
                vcMain.title = selectedItem
                self.show(vcMain, sender: nil);
            }
        case .ps5:
            if let vcMain = productStoryboard.instantiateViewController(identifier: "ProductListView") as? ProductListController{
                vcMain.title = selectedItem
                self.show(vcMain, sender: nil);
            }
        case .xbox:
            if let vcMain = productStoryboard.instantiateViewController(identifier: "ProductListView") as? ProductListController{
                vcMain.title = selectedItem
                self.show(vcMain, sender: nil);
            }
        case .one:
            if let vcMain = productStoryboard.instantiateViewController(identifier: "ProductListView") as? ProductListController{
                vcMain.title = selectedItem
                self.show(vcMain, sender: nil);
            }
        case .Switch:
            if let vcMain = productStoryboard.instantiateViewController(identifier: "ProductListView") as? ProductListController{
                vcMain.title = selectedItem
                self.show(vcMain, sender: nil);
            }
        }
    }
    
    private func setMenu(){
        
        var sideMenulist = [SideMenuListModel]();
        //設定menu內容
        sideMenulist.append(SideMenuListModel.init(title: .store, item:[SideMenuItem.store]))
        sideMenulist.append(SideMenuListModel.init(title:.homePage, item: [SideMenuItem.home]))
        sideMenulist.append(SideMenuListModel.init(title:.ps, item: [SideMenuItem.ps5,SideMenuItem.ps4]))
        sideMenulist.append(SideMenuListModel.init(title: .xbox, item:[SideMenuItem.xbox,SideMenuItem.one]))
        sideMenulist.append(SideMenuListModel.init(title:.Switch, item:[ SideMenuItem.Switch]))
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
//    @IBAction func didTapMenu(){
//        present(menu!, animated: true)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

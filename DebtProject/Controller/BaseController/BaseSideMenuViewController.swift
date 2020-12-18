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
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.addTarget(self, action:#selector(didTapMenu), for: .touchDragInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //設定抽屜圖示的顏色
        button.tintColor = #colorLiteral(red: 0.01798310503, green: 0.9727620482, blue: 0.856649816, alpha: 1)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
        // Do any additional setup after loading the view.
    }
    @objc func didTapMenu() {
            present(menu!, animated: true)
     }
    
    func didSelectMenuItem(titleNamed: SideMenuSelectTitle, itemNamed: SideMenuItem) {
        menu?.dismiss(animated: true, completion: nil)
        //設定畫面title的文字
        let selectedItem = itemNamed.rawValue
//        let selectedTitle = titleNamed.rawValue
        //設定換頁
        switch itemNamed {
        case .home:
                if let vcMain = self.storyboard?.instantiateViewController(identifier: "MainPageViewController") as? MainPageViewController{
                    vcMain.title = selectedItem
                    self.show(vcMain, sender: nil);
                }
        case .ps4:
            if let vcMain = self.storyboard?.instantiateViewController(identifier: "mainView") as? ProductListController{
                vcMain.title = selectedItem
                self.show(vcMain, sender: nil);
            }
        case .ps5:
            let vcMain = self.storyboard?.instantiateViewController(identifier: "ProductListView");
            vcMain?.title = selectedItem
            self.show(vcMain!, sender: nil);
            
        case .xbox:
            let vcMain = self.storyboard?.instantiateViewController(identifier: "ProductListView");
            vcMain?.title = selectedItem
            self.show(vcMain!, sender: nil);
        case .one:
            let vcMain = self.storyboard?.instantiateViewController(identifier: "ProductListView");
            vcMain?.title = selectedItem
            self.show(vcMain!, sender: nil);
        case .Switch:
            let vcMain = self.storyboard?.instantiateViewController(identifier: "ProductListView");
            vcMain?.title = selectedItem
            self.show(vcMain!, sender: nil);
        }
    }
    
    private func setMenu(){
        
        var sideMenulist = [SideMenuListModel]();
        //設定menu內容
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

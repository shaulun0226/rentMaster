//
//  MemberCenterViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/29.
//

import UIKit
import SwiftAlertView
enum MemberCenterTitle:String,CaseIterable{
    case order = "訂單資訊"
    case userInfo = "帳號資訊"
    case wishList = "願望清單"
    case logout = "登出"
    case forgetPassword = "修改密碼"
    case boardgame = "桌遊"
//    case memberCenter = "會員中心"
}

class MemberCenterViewController: BaseSideMenuViewController {
    let userDefault = UserDefaults()
    @IBOutlet weak var memberCenterTableView: UITableView!
    var titleList = ["帳號資訊","訂單資訊","願望清單","帳號登出"]
    override func viewDidLoad() {
        super.viewDidLoad()
        memberCenterTableView.delegate = self
        memberCenterTableView.dataSource = self
        memberCenterTableView.separatorStyle = .none
    }
}
extension MemberCenterViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.memberCenterTableViewCell.rawValue) as? MemberCenterTableViewCell {
            cell.lbTilte.text = titleList[indexPath.row]
            return cell;
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (User.token.isEmpty && Global.isOnline){
            let alertView = SwiftAlertView(title: "", message: "請先登入!\n", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "登入")
            alertView.clickedCancelButtonAction = {
                alertView.dismiss()
            }
            alertView.clickedButtonAction = {[self] index in
                if(index==1){
                    if let loginView = Global.mainStoryboard.instantiateViewController(identifier:MainStoryboardController.login.rawValue ) as? LoginViewController{
                        self.present(loginView, animated: true, completion: nil)
                    }
                }
            }
            alertView.messageLabel.textColor = UIColor(named: "labelColor")
            alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
            alertView.button(at: 1)?.backgroundColor = UIColor(named: "Button")
            alertView.backgroundColor = UIColor(named: "Card-2")
            alertView.buttonTitleColor = .white
            alertView.show()
            return
        }
        switch indexPath.row {
        case 0:
            if let changeUserInfoView = Global.mainStoryboard.instantiateViewController(identifier: MainStoryboardController.changeUserInfoViewController.rawValue) as? ChangeUserInfoViewController{
                self.show(changeUserInfoView, sender: nil);
            }
        case 1:
            
            if let myOrderListViewController = Global.productStoryboard.instantiateViewController(identifier:ProductStoryboardController.myBuyerOrderListViewController.rawValue) as? MyBuyerOrderListViewController{
                myOrderListViewController.orderStatus = "已立單"
                self.show(myOrderListViewController, sender: nil);
            }
        case 2:
            
            if let wantListView = Global.mainStoryboard.instantiateViewController(identifier: MainStoryboardController.wishListViewController.rawValue) as? WishListViewController{
                self.show(wantListView, sender: nil);
            }
        case 3:
            let alertView = SwiftAlertView(title: "", message: " 是否登出？\n", delegate: nil, cancelButtonTitle: "取消",otherButtonTitles: "確定")
            alertView.messageLabel.textColor = UIColor(named: "labelColor")
            alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
            alertView.button(at: 0)?.backgroundColor = UIColor(named: "CancelButton")
            alertView.button(at: 1)?.backgroundColor = UIColor(named: "Button")
            alertView.backgroundColor = UIColor(named: "Card-2")
            alertView.buttonTitleColor = .white
            alertView.clickedButtonAction = { [self] index in
                if(index==0){//設定取消鍵
                    alertView.dismiss()
                }
                if(index==1){
                    User.token = ""
                    self.userDefault.removeObject(forKey: "Account")
                    self.userDefault.removeObject(forKey: "Password")
                    if let mainView = Global.mainStoryboard.instantiateViewController(identifier: MainStoryboardController.mainPageViewController.rawValue) as? MainPageViewController{
                        self.show(mainView, sender: nil)
                    }
//                    alertView.dismiss()
                }
            }
            alertView.show()
            
        default:
            return
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}

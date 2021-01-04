//
//  MemberCenterViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/29.
//

import UIKit
import SwiftAlertView

class MemberCenterViewController: BaseSideMenuViewController {
    @IBOutlet weak var memberCenterTableView: UITableView!
    var titleList = ["我的訂單","願望清單","帳號資訊","修改密碼","帳號登出"]
    override func viewDidLoad() {
        super.viewDidLoad()
        memberCenterTableView.delegate = self
        memberCenterTableView.dataSource = self
        memberCenterTableView.layer.cornerRadius = 20
        memberCenterTableView.backgroundColor = UIColor(named: "card")
    }
    
}
extension MemberCenterViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.memberCenterTableViewCell.rawValue) as? MemberCenterTableViewCell {
            
            cell.contentView.layer.insertSublayer(Global.setBackgroundColor(cell.contentView), at: 0)
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
            alertView.messageLabel.textColor = .white
            alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
            alertView.button(at: 1)?.backgroundColor = UIColor(named: "Button")
            alertView.backgroundColor = UIColor(named: "Alert")
            alertView.buttonTitleColor = .white
            alertView.show()
            return
        }
        switch indexPath.row {
        case 0:
            if let myOrderListViewController = Global.productStoryboard.instantiateViewController(identifier:ProductStoryboardController.myOrderListViewController.rawValue) as? MyOrderListViewController{
                self.show(myOrderListViewController, sender: nil);
            }
        case 1:
            if let wantListView = Global.mainStoryboard.instantiateViewController(identifier: MainStoryboardController.wantListViewController.rawValue) as? WantListViewController{
                self.show(wantListView, sender: nil);
            }
        case 2:
            if let changeUserInfoView = Global.mainStoryboard.instantiateViewController(identifier: MainStoryboardController.changeUserInfoViewController.rawValue) as? ChangeUserInfoViewController{
                self.show(changeUserInfoView, sender: nil);
            }
        case 3:
            if let changePasswordView = Global.mainStoryboard.instantiateViewController(identifier: MainStoryboardController.changePasswordViewController.rawValue) as? ChangePasswordViewController{
                self.show(changePasswordView, sender: nil);
            }
        case 4:
            let alertView = SwiftAlertView(title: "", message: " 是否登出？\n", delegate: nil, cancelButtonTitle: "取消",otherButtonTitles: "確定")
            alertView.messageLabel.textColor = .white
            alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
            alertView.button(at: 1)?.backgroundColor = UIColor(named: "Button")
            alertView.backgroundColor = UIColor(named: "Alert")
            alertView.buttonTitleColor = .white
            alertView.clickedButtonAction = { index in
                if(index==0){//設定取消鍵
                    alertView.dismiss()
                }
                if(index==1){
                    User.token = ""
                    alertView.dismiss()
                }
            }
            alertView.show()
            
        default:
            return
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
}

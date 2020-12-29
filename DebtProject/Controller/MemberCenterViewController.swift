//
//  MemberCenterViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/29.
//

import UIKit

class MemberCenterViewController: BaseSideMenuViewController {
    @IBOutlet weak var memberCenterTableView: UITableView!
    var titleList = ["我的訂單","修改密碼","帳號登出"]
    override func viewDidLoad() {
        super.viewDidLoad()
        memberCenterTableView.delegate = self
        memberCenterTableView.dataSource = self
    }
    
}
extension MemberCenterViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.memberCenterTableViewCell.rawValue) as? MemberCenterTableViewCell {
            cell.backgroundColor = UIColor(named: "card")
            cell.lbTilte.text = titleList[indexPath.row]
            return cell;
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let myOrderListViewController = Global.productStoryboard.instantiateViewController(identifier:ProductStoryboardController.myOrderListViewController.rawValue) as? MyOrderListViewController{
                self.show(myOrderListViewController, sender: nil);
            }
        case 1:
            if let changePasswordView = Global.mainStoryboard.instantiateViewController(identifier: MainStoryboardController.changePasswordViewController.rawValue) as? ChangePasswordViewController{
                self.show(changePasswordView, sender: nil);
            }
        case 2:
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
        default:
            return
        }
    }
    
}

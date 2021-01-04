//
//  ChangeUserInfoViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/30.
//

import UIKit
import SwiftyJSON
import SwiftAlertView

class ChangeUserInfoViewController:BaseViewController {
    // 願望清單
    @IBOutlet weak var wantExchangeListTV: UITableView!
    @IBOutlet weak var wantExchangeListTVHeight: NSLayoutConstraint!
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        wantExchangeListTV.layer.removeAllAnimations()
        wantExchangeListTVHeight.constant = wantExchangeListTV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    var newCellCount = 0
    var wantExchangeList = [String]()
    // 使用者資料
    @IBOutlet weak var tfEmail: UnderLineTextField!
    @IBOutlet weak var tfName: UnderLineTextField!
    @IBOutlet weak var tfNickName: UnderLineTextField!
    @IBOutlet weak var tfPhone: UnderLineTextField!
    @IBOutlet weak var tfAddress: UnderLineTextField!
    @IBOutlet weak var btnModify: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var user:UserModel?
    @IBOutlet weak var lbErrorHint: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("token     \(User.token)")
        if(Global.isOnline){
            NetworkController.instance().getUserInfo{
                [weak self](responseValue, isSuccess) in
                guard let weakSelf = self else {return}
                if(isSuccess){
                    let jsonArr = JSON(responseValue)
                    print("使用者資訊   \(jsonArr)")
                    weakSelf.parseUser(json: jsonArr)
                    weakSelf.tfEmail.text = weakSelf.user?.email
                    weakSelf.tfName.text = weakSelf.user?.name
                    weakSelf.tfNickName.text = weakSelf.user?.nickName
                    weakSelf.tfPhone.text = weakSelf.user?.phone
                    weakSelf.tfAddress.text = weakSelf.user?.address
                }else{
                    weakSelf.tfEmail.text = "123445"
                    weakSelf.tfName.text = "213"
                    weakSelf.tfNickName.text = "213"
                    weakSelf.tfPhone.text = "555"
                    weakSelf.tfAddress.text = "111"
                }
            }
        }
        //設定KVO
        wantExchangeListTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        wantExchangeList = ["111111","2222222","3333333","4444444"]
        wantExchangeListTV.delegate = self
        wantExchangeListTV.dataSource = self
        wantExchangeListTV.reloadData()
        changeTextFieldEnable(bool:false)
    }
    private func parseUser(json:JSON){
        let id = json["id"].string ?? ""
        let email = json["email"].string ?? ""
        let name = json["name"].string ?? ""
        let nickName = json["nickName"].string ?? ""
        let phone = json["phone"].string ?? ""
        let address = json["address"].string ?? ""
        self.user = UserModel.init(id: id, email: email, name: name, nickName: nickName, phone: phone, address: address, products: [])
    }
    private func setTextFieldUnderLine(size:CGFloat){
        tfName.lineHeight = size
        tfAddress.lineHeight = size
        tfNickName.lineHeight = size
        tfPhone.lineHeight = size
        for index in 0..<wantExchangeList.count{
            if let cell = wantExchangeListTV.cellForRow(at: IndexPath(row: index, section: 0)) as? WantChangeTableViewCell{
                print("進到cell設定")
                cell.tfExchangeProduct.lineHeight = size
                cell.tfExchangeAmount.lineHeight = size
                cell.tfEXchangeWorth.lineHeight = size
            }
        }
        for index in 0..<self.newCellCount{
            if let cell = wantExchangeListTV.cellForRow(at: IndexPath(row: index, section: 0)) as? WantChangeTableViewCell{
                cell.tfExchangeProduct.lineHeight = size
                cell.tfExchangeAmount.lineHeight = size
                cell.tfEXchangeWorth.lineHeight = size
            }
        }
    }
    private func changeTextFieldEnable( bool:Bool){
        tfName.isEnabled = bool
        tfNickName.isEnabled = bool
        tfPhone.isEnabled = bool
        tfAddress.isEnabled = bool
        wantExchangeListTV.isUserInteractionEnabled = bool
    }
    private func setBtnModify(){
        lbErrorHint.textColor = .clear
        changeTextFieldEnable(bool:false)
        setTextFieldUnderLine(size: CGFloat(0))
        btnModify.setTitle("編輯", for:.normal)
        btnCancel.isHidden = true
        self.btnModify.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    @IBAction func btnCancelClick(_ sender: Any) {
        setBtnModify()
        NetworkController.instance().getUserInfo{
            [weak self](responseValue, isSuccess) in
            guard let weakSelf = self else {return}
            if(isSuccess){
                let jsonArr = JSON(responseValue)
                print("使用者資訊   \(jsonArr)")
                weakSelf.parseUser(json: jsonArr)
                weakSelf.tfEmail.text = weakSelf.user?.email
                weakSelf.tfName.text = weakSelf.user?.name
                weakSelf.tfNickName.text = weakSelf.user?.nickName
                weakSelf.tfPhone.text = weakSelf.user?.phone
                weakSelf.tfAddress.text = weakSelf.user?.address
                weakSelf.changeTextFieldEnable(bool:false)
            }else{
                weakSelf.tfEmail.text = "123445"
                weakSelf.tfName.text = "213"
                weakSelf.tfNickName.text = "213"
                weakSelf.tfPhone.text = "555"
                weakSelf.tfAddress.text = "111"
            }
        }
    }
    @IBAction func btnModifyClick(_ sender: Any) {
        switch btnModify.titleLabel?.text{
        case "編輯":
            changeTextFieldEnable(bool:true)
            self.setTextFieldUnderLine(size: CGFloat(1))
            btnModify.setTitle("完成", for:.normal)
            self.btnModify.backgroundColor = UIColor(named: "Button")
            btnCancel.isHidden = false
        case "完成":
            if(tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
                tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" /*||
               tfAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
               tfNickName.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""*/){
                lbErrorHint.textColor = .red
                lbErrorHint.text = "姓名或電話為必填"
                return
            }
            setBtnModify()
            btnCancel.isHidden = true
            btnModify.setTitle("編輯", for:.normal)
            let name = tfName.text!
            let phone = tfPhone.text!
            let address = tfAddress.text ?? ""
            let nickName = tfNickName.text ?? ""
            NetworkController.instance().changeUserInfo(name: name, nickName: nickName, phone: phone, address: address){
                [weak self] (isSuccess) in
                // 如果此 weakSelf 賦值失敗，就 return
                guard let weakSelf = self else {return}
                let alertView = SwiftAlertView(title: "", message: "變更成功！", delegate: nil, cancelButtonTitle: "確定")
                alertView.messageLabel.textColor = .white
                alertView.messageLabel.font = UIFont.systemFont(ofSize: 30)
                alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
                alertView.backgroundColor = UIColor(named: "Alert")
                alertView.buttonTitleColor = .white
                alertView.clickedButtonAction = { index in
                    if let view = Global.mainStoryboard.instantiateViewController(identifier: MainStoryboardController.memberCenterViewController.rawValue) as? MemberCenterViewController{
                        weakSelf.show(view, sender: nil)
                    }
                }
                if(isSuccess){
                    alertView.clickedButtonAction = { index in
                        if let view = Global.mainStoryboard.instantiateViewController(identifier: MainStoryboardController.memberCenterViewController.rawValue) as? MemberCenterViewController{
                            weakSelf.show(view, sender: nil)
                        }
                    }
                    alertView.show()
                }else{
                    alertView.messageLabel.text = "變更失敗！"
                    alertView.clickedButtonAction = { index in
                        alertView.dismiss()
                    }
                    alertView.show()
                }
            }
        case .none:
            print("按鈕按下1")
        case .some(_):
            print("按鈕按下2")
        }
    }
    @IBAction func btnRemoveCellClick(_ sender: Any) {
        if(self.newCellCount==0){
            wantExchangeList.remove(at: wantExchangeList.count-1)
        }else{
            self.newCellCount -= 1
        }
        wantExchangeListTV.reloadData()
    }
    @IBAction func btnAddCellClick(_ sender: Any) {
        self.newCellCount += 1
        print("新增一格")
        print(self.newCellCount)
        wantExchangeListTV.reloadData()
    }
}
extension ChangeUserInfoViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count\(self.newCellCount)")
        return (self.newCellCount+self.wantExchangeList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("創造cell")
        for index in 0..<wantExchangeList.count{
            print("\(wantExchangeList[index])")
        }
        if let cell = wantExchangeListTV.dequeueReusableCell(withIdentifier: "WantChangeTableViewCell") as? WantChangeTableViewCell {
            print("創造cell位置\(indexPath.row)")
            if(indexPath.row<wantExchangeList.count){
                cell.tfExchangeProduct.text = wantExchangeList[indexPath.row]
                print("清單內容\(wantExchangeList[indexPath.row])")
            }else{
                cell.tfExchangeProduct.text = ""
            }
            cell.lbNumber.text = "\(indexPath.row+1):"
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選到後馬上解除選取
        wantExchangeListTV.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            print("cell位置\(indexPath.row)")
            print("清單長度\(self.wantExchangeList.count)")
            if(indexPath.row<self.wantExchangeList.count){
                self.wantExchangeList.remove(at: indexPath.row)
                print("清單長度\(self.wantExchangeList.count)")
            }else{
                self.newCellCount -= 1
            }
//                tableView.deleteRows(at: [indexPath], with: .automatic)
            //0.5秒後刷新資料內容
//            let seconds = 0.5
//            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.wantExchangeListTV.reloadData()
//            }
                
                   // 需要返回true，否则没有反应
                   completionHandler(true)
               }

        deleteAction.backgroundColor = .red
               deleteAction.image = UIImage(systemName: "trash")

               let config = UISwipeActionsConfiguration(actions: [deleteAction])

               // 取消拉長後自動執行
               config.performsFirstActionWithFullSwipe = false

               return config
    }
}

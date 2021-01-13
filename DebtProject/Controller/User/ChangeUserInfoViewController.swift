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
        tfEmail.underLineTextFieldDelegate = self
        tfName.underLineTextFieldDelegate = self
        tfPhone.underLineTextFieldDelegate = self
        tfNickName.underLineTextFieldDelegate = self
        tfAddress.underLineTextFieldDelegate = self
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
        changeTextFieldEnable(bool:false)
    }
    private func parseUser(json:JSON){
        let id = json["id"].string ?? ""
        let email = json["email"].string ?? ""
        let name = json["name"].string ?? ""
        let nickName = json["nickName"].string ?? ""
        let phone = json["phone"].string ?? ""
        let address = json["address"].string ?? ""
        self.user = UserModel.init(id: id, email: email, name: name, nickName: nickName, phone: phone, address: address, products: [], wishItems: [])
    }
    private func setTextFieldUnderLine(size:CGFloat){
        tfName.lineHeight = size
        tfAddress.lineHeight = size
        tfNickName.lineHeight = size
        tfPhone.lineHeight = size
    }
    private func changeTextFieldEnable( bool:Bool){
        tfName.isEnabled = bool
        tfNickName.isEnabled = bool
        tfPhone.isEnabled = bool
        tfAddress.isEnabled = bool
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
}

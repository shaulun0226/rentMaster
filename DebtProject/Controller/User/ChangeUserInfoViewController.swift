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
    let userDefault = UserDefaults()
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
                    guard let user = responseValue as? UserModel else { return  }
                    weakSelf.user = user
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
        //設定觀察鍵盤
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //                設定按外面會把鍵盤收起(有可能會手勢衝突)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
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
        btnModify.backgroundColor = UIColor(named: "Button")
    }
    @IBAction func btnCancelClick(_ sender: Any) {
        setBtnModify()
        NetworkController.instance().getUserInfo{
            [weak self](responseValue, isSuccess) in
            guard let weakSelf = self else {return}
            if(isSuccess){
                guard let user = responseValue as? UserModel else { return  }
                weakSelf.user = user
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
    @IBAction func btnLogoutClick(_ sender: Any) {
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
                (isSuccess) in
                // 如果此 weakSelf 賦值失敗，就 return
//                guard let weakSelf = self else {return}
                let alertView = SwiftAlertView(title: "", message: "變更成功！", delegate: nil, cancelButtonTitle: "確定")
                alertView.messageLabel.textColor = UIColor(named: "labelColor")
                alertView.messageLabel.font = UIFont.systemFont(ofSize: 30)
                alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
                alertView.backgroundColor = UIColor(named: "Card-2")
                alertView.buttonTitleColor = .white
                alertView.clickedButtonAction = { index in
                    alertView.dismiss()
                }
                if(isSuccess){
                    alertView.clickedButtonAction = { index in
                        alertView.dismiss()
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

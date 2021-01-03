//
//  RegisterViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/9.
//

import UIKit
import SwiftAlertView

class RegisterViewController: BaseViewController {
    @IBOutlet weak var errorHint:UILabel!
    let border = CALayer();
    //設定每個label的tag代表順序
    @IBOutlet weak var btnEmailConfirm: UIButton!
    @IBOutlet weak var tfEmail: UnderLineTextField! {
        didSet {
            tfEmail.tag = 1
            tfEmail.underLineTextFieldDelegate = self
        }
    }
    @IBOutlet weak var tfVerityCode: UnderLineTextField!{
        didSet {
            tfVerityCode.tag = 2
            tfVerityCode.underLineTextFieldDelegate = self
        }
    }
    @IBOutlet weak var tfPassword: UnderLineTextField!{
        didSet {
            tfPassword.tag = 3
            tfPassword.underLineTextFieldDelegate = self
        }
    }
    
    @IBOutlet weak var tfPasswordConfirm: UnderLineTextField!{
        didSet {
            tfPasswordConfirm.tag = 4
            tfPasswordConfirm.underLineTextFieldDelegate = self
        }
    }
    @IBOutlet weak var tfPhone: UnderLineTextField!{
        didSet {
            tfPhone.tag = 5
            tfPhone.underLineTextFieldDelegate = self
        }
    }
    @IBOutlet weak var tfName: UnderLineTextField!{
        didSet {
            tfName.tag = 6
            tfName.layer.cornerRadius = 5.0
            tfName.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var btnRegisterConfirm: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定按鈕
        tfEmail.textColor = .white
        tfPassword.textColor = .white
        tfPasswordConfirm.textColor = .white
        tfName.textColor = .white
        tfPhone.textColor = .white
        //設定hint
        errorHint.leftAnchor.constraint(equalToSystemSpacingAfter: self.view.leftAnchor, multiplier: 0).isActive = true
        //        btnRegisterConfirm.backgroundColor = #colorLiteral(red: 0.3729024529, green: 0.9108788371, blue: 0.7913612723, alpha: 1);
        // Do any additional setup after loading the view.
    }
    
    //設定按下return 自動跳到下一格，因為自定義textField的關係兩邊都需要實現UITextFieldDelegate，所以沒辦法用
    @IBAction func emailConfirmClick(_ sender: Any) {
        if(!emailCheck()){
            errorHint.textColor = .red;
            errorHint.text = "請輸入Email";
            return;
        }
        let email = tfEmail.text!
        NetworkController.instance().emailConfirm(email: email) { (isSuccess) in
            let alertView = SwiftAlertView(title: "", message: " 傳送成功！\n", delegate: nil, cancelButtonTitle: "確定")
            alertView.clickedButtonAction = { index in
                alertView.dismiss()
            }
            alertView.messageLabel.textColor = .white
            alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
            alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
            alertView.backgroundColor = UIColor(named: "Alert")
            alertView.buttonTitleColor = .white
            if(isSuccess){
                alertView.show()
            }else{
                alertView.clickedButtonAction = { index in
                    alertView.dismiss()
                }
                alertView.messageLabel.text = " 傳送錯誤！\n"
                alertView.show()
            }
        }
    }
    func emailCheck()->Bool{
        if(tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            return false;
        }
        return true;
    }
    func emptyCheck()-> Bool{
        if(tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfVerityCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfPasswordConfirm.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            return false;
        }
        return true;
    }
    @IBAction func confirmOnClick(_ sender: Any) {
        if(!emptyCheck()){
            errorHint.textColor = .red;
            errorHint.text = "請確認資料是否輸入完整";
            return;
        }
        let email = tfEmail.text!
        let verityCode = tfVerityCode.text!
        let password = tfPassword.text!
        let passwordConfirm = tfPasswordConfirm.text!
        let name = tfName.text!
        let phone = tfPhone.text!
        if(!password.elementsEqual(passwordConfirm)){
            errorHint.textColor = .red;
            errorHint.text = "請確認密碼是否相符";
        }
        NetworkController.instance().register(email: email,verityCode:verityCode, password: password, name: name, phone: phone) {
            [weak self] (responseValue,isSuccess) in
            // 如果此 weakSelf 賦值失敗，就 return
            guard let weakSelf = self else {return}
            let alertView = SwiftAlertView(title: "", message: " 註冊成功！\n", delegate: nil, cancelButtonTitle: "確定")
            alertView.messageLabel.textColor = .white
            alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
            alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
            alertView.backgroundColor = UIColor(named: "Alert")
            alertView.buttonTitleColor = .white
            if(isSuccess){
                alertView.clickedButtonAction = { index in
                    weakSelf.dismiss(animated: true, completion: nil)
                }
                alertView.show()
            }else{
                alertView.clickedButtonAction = { index in
                    alertView.dismiss()
                }
                alertView.messageLabel.font = UIFont.systemFont(ofSize: 28)
                alertView.messageLabel.text = responseValue
                alertView.show()
            }
        }
        
    }
}

//
//  ForgotPasswordViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/11.
//

import UIKit
import SwiftAlertView
class ForgotPasswordViewController: BaseViewController {
    @IBOutlet weak var tfEmail: UnderLineTextField!
    @IBOutlet weak var tfVerityCode: UnderLineTextField!
    @IBOutlet weak var tfNewPassword: UnderLineTextField!
    @IBOutlet weak var tfNewPasswordConfirm: UnderLineTextField!
    @IBOutlet weak var lbErrorHint: UILabel!
    func emailCheck()->Bool{
        if(tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            return false;
        }
        return true;
    }
    func emptyCheck()-> Bool{
        if(tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfVerityCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfNewPasswordConfirm.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            return false;
        }
        return true;
    }
    @IBAction func btnVerityClick(_ sender: Any) {
        if(!emailCheck()){
            lbErrorHint.textColor = .red;
            lbErrorHint.text = "請輸入Email";
            return;
        }
        let email = tfEmail.text!
        NetworkController.instance().emailConfirm(email: email) {(isSuccess) in
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
                alertView.messageLabel.text = " 傳送失敗!\n"
                alertView.show()
            }
        }
    }
    @IBAction func btnConfirmClick(_ sender: Any) {
        if(!emptyCheck()){
            lbErrorHint.textColor = .red;
            lbErrorHint.text = "請確認資料是否輸入完整";
            return;
        }
        let email = tfEmail.text!
        let verityCode = tfVerityCode.text!
        let newPassword = tfNewPassword.text!
        let newPasswordConfirm = tfNewPasswordConfirm.text!
        if(!newPassword.elementsEqual(newPasswordConfirm)){
            lbErrorHint.textColor = .red;
            lbErrorHint.text = "請確認密碼是否相符";
            return
        }
        
        NetworkController.instance().forgotPassword(email: email,verityCode:verityCode, newPassword: newPassword) {
            [weak self] (responseValue,isSuccess) in
            // 如果此 weakSelf 賦值失敗，就 return
            guard let weakSelf = self else {return}
            let alertView = SwiftAlertView(title: "", message: " 傳送成功！\n", delegate: nil, cancelButtonTitle: "確定")
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
                alertView.messageLabel.text = responseValue
                alertView.messageLabel.font = UIFont.systemFont(ofSize: 28)
                alertView.show()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

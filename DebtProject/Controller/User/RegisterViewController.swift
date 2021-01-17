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
        //設定hint
        errorHint.leftAnchor.constraint(equalToSystemSpacingAfter: self.view.leftAnchor, multiplier: 0).isActive = true
        //設定觀察鍵盤
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //設定按外面會把鍵盤收起(有可能會手勢衝突)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
    }
    //MARK:- 根據鍵盤出現移動螢幕
//    @objc override func keyboardWillShow(notification: NSNotification) {
//        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            // if keyboard size is not available for some reason, dont do anything
//            return
//        }
//        // move the root view up by the distance of keyboard height
//        self.view.frame.origin.y = 0 - keyboardSize.height
//    }
//    
//    @objc override func keyboardWillHide(notification: NSNotification) {
//        // move back the root view origin to zero
//        self.view.frame.origin.y = 0
//    }
//    //點擊空白收回鍵盤
//    @objc override func dismissKeyBoard() {
//        self.view.endEditing(true)
//    }
    //設定按下return 自動跳到下一格，因為自定義textField的關係兩邊都需要實現UITextFieldDelegate，所以沒辦法用
    @IBAction func emailConfirmClick(_ sender: Any) {
        if(!emailCheck()){
            errorHint.textColor = .red;
            errorHint.text = "請輸入Email";
            let alertView = SwiftAlertView(title: "", message: " 請輸入Email\n", delegate: nil, cancelButtonTitle: "確定")
            alertView.clickedButtonAction = { index in
                alertView.dismiss()
            }
            alertView.messageLabel.textColor = UIColor(named: "labelColor")
            alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
            alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
            alertView.backgroundColor = UIColor(named: "Card-2")
            alertView.buttonTitleColor = .white
            alertView.show()
            return;
        }
        let email = tfEmail.text!
        NetworkController.instance().emailConfirm(email: email) { (isSuccess) in
            let alertView = SwiftAlertView(title: "", message: " 傳送成功！\n", delegate: nil, cancelButtonTitle: "確定")
            alertView.clickedButtonAction = { index in
                alertView.dismiss()
            }
            alertView.messageLabel.textColor = UIColor(named: "labelColor")
            alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
            alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
            alertView.backgroundColor = UIColor(named: "Card-2")
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
            alertView.messageLabel.textColor = UIColor(named: "labelColor")
            alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
            alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
            alertView.backgroundColor = UIColor(named: "Card-2")
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

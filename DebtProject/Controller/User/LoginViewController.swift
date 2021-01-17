//
//  ViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/2.
//

import UIKit
import Alamofire
import SwiftAlertView

class LoginViewController: BaseViewController {
    
    let userDefault = UserDefaults()
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var errorHint: UILabel!
    @IBOutlet weak var tfAccount: UnderLineTextField!{
        didSet {
            tfAccount.tag = 1
            tfAccount.underLineTextFieldDelegate = self
            tfAccount.text = userDefault.value(forKey: "Account") as? String
        }
    }
    @IBOutlet weak var tfPassword: UnderLineTextField!{
        didSet {
            tfPassword.tag = 2
            tfPassword.underLineTextFieldDelegate = self
            tfPassword.text = userDefault.value(forKey: "Password") as? String
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定hint
        errorHint.leftAnchor.constraint(equalToSystemSpacingAfter: self.view.leftAnchor, multiplier: 0).isActive = true
        //設定提示字顏色
        self.tfAccount.attributedPlaceholder = NSAttributedString(string:
                                                                    "Account", attributes:
                                                                        [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        self.tfPassword.attributedPlaceholder = NSAttributedString(string:
                                                                    "Password", attributes:
                                                                        [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
    }
    func verify()-> Bool{
        if(tfAccount.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            
            return false;
        }
        return true;
    }
    
    struct Post: Codable{
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }
    @IBAction func loginOnClick(_ sender: Any) {
        
        
        if(!verify()){
            errorHint.textColor = .red;
            errorHint.text = "請輸入帳號和密碼";
            return;
        }
        let email =  tfAccount.text!;
        let password = tfPassword.text!;
        
        if(Global.isOnline){
            guard let deviceToken = userDefault.value(forKey: "DeviceToken") as? String else{return}
            NetworkController.instance().login(email: email, password: password,deviceToken:deviceToken) {
                
                // [weak self]表此類為弱連結(結束後會自動釋放)，(isSuccess)自訂方法時會帶進來的 bool 參數（此寫法可不用帶兩個閉包進去）
                [weak self]
                (value,isSuccess)  in
                // 如果此 weakSelf 賦值失敗，就 return
                guard let weakSelf = self else {return}
            
                if(isSuccess){
                    User.token = value as? String ?? ""
                    print(User.token)
                    weakSelf.userDefault.setValue(weakSelf.tfAccount.text, forKey: "Account")
                    weakSelf.userDefault.setValue(weakSelf.tfPassword.text, forKey: "Password")
                    weakSelf.dismiss(animated: true, completion: nil)
//                    weakSelf.show(Global.presentView, sender: LoginViewController.self);
//                    let storyboard = UIStoryboard(name: Storyboard.main.rawValue, bundle: nil)
//                    if let vcMain = storyboard.instantiateViewController(identifier: MainStoryboardController.mainPageViewController.rawValue) as? MainPageViewController{
//                        weakSelf.show(vcMain, sender: LoginViewController.self);
//                    }
                }else{
                    let alertView = SwiftAlertView(title: "", message: " 登入失敗！\n", delegate: nil, cancelButtonTitle: "確定")
                    alertView.clickedButtonAction = { index in
                        alertView.dismiss()
                    }
                    alertView.messageLabel.textColor = UIColor(named: "labelColor")
                    alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
                    alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
                    alertView.backgroundColor = UIColor(named: "Card-2")
                    alertView.buttonTitleColor = .white
                    alertView.show()
//                    let controller = UIAlertController(title: "登入失敗！", message: "登入失敗！", preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "確定", style: .default)
//                    controller.addAction(okAction)
//                    weakSelf.present(controller, animated: true, completion: nil)
                }
            }
        }else{
            //切換畫面
                dismiss(animated: true, completion: nil)
        }
    }
    
}

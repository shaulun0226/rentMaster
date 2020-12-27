//
//  ViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/2.
//

import UIKit
import Alamofire

class LoginViewController: BaseViewController {
    
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var errorHint: UILabel!
    @IBOutlet weak var tfAccount: UnderLineTextField!{
        didSet {
            tfAccount.tag = 1
            tfAccount.underLineTextFieldDelegate = self
        }
    }
    @IBOutlet weak var tfPassword: UnderLineTextField!{
        didSet {
            tfPassword.tag = 2
            tfPassword.underLineTextFieldDelegate = self
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
        tfAccount.textColor = .white
        tfPassword.textColor = .white
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
            NetworkController.instance().login(email: email, password: password) {
                
                // [weak self]表此類為弱連結(結束後會自動釋放)，(isSuccess)自訂方法時會帶進來的 bool 參數（此寫法可不用帶兩個閉包進去）
                [weak self]
                (value,isSuccess)  in
                // 如果此 weakSelf 賦值失敗，就 return
                guard let weakSelf = self else {return}
            
                if(isSuccess){
                    User.token = value as? String ?? ""
                    print(User.token)
                    let storyboard = UIStoryboard(name: Storyboard.main.rawValue, bundle: nil)
                    if let vcMain = storyboard.instantiateViewController(identifier: MainStoryboardController.mainPageViewController.rawValue) as? MainPageViewController{
                        weakSelf.show(vcMain, sender: LoginViewController.self);
                    }
                }else{
                    let controller = UIAlertController(title: "登入失敗！", message: "登入失敗！", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default)
                    controller.addAction(okAction)
                    weakSelf.present(controller, animated: true, completion: nil)
                }
            }
        }else{
            //切換畫面
            let productStoryboard = UIStoryboard(name: "Product", bundle: nil)
            if let vcMain = productStoryboard.instantiateViewController(identifier: "MainPageViewController") as? MainPageViewController{
                self.show(vcMain, sender: LoginViewController.self);
            }
        }
    }
    
}

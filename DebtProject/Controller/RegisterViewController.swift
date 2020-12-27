//
//  RegisterViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/9.
//

import UIKit

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
        NetworkController.instance().emailConfirm(email: email) { [weak self](isSuccess) in
            guard let weakSelf = self else {return}
            if(isSuccess){
                let controller = UIAlertController(title: "傳送！", message: "傳送！", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default)
                controller.addAction(okAction)
                weakSelf.present(controller, animated: true, completion: nil)
            }else{
                let controller = UIAlertController(title: "網路錯誤！", message: "網路錯誤！", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default)
                controller.addAction(okAction)
                weakSelf.present(controller, animated: true, completion: nil)
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
            if(isSuccess){
                let controller = UIAlertController(title: responseValue, message: responseValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default){(_) in
                    if let loginView = Global.mainStoryboard.instantiateViewController(identifier:MainStoryboardController.login.rawValue ) as? LoginViewController{
                        weakSelf.show(loginView, sender: nil);
                    }
                }
                controller.addAction(okAction)
                weakSelf.present(controller, animated: true, completion: nil)
            }else{
                let controller = UIAlertController(title: responseValue, message: responseValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default)
                controller.addAction(okAction)
                weakSelf.present(controller, animated: true, completion: nil)
            }
        }
        
    }
}

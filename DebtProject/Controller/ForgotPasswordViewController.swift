//
//  ForgotPasswordViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/11.
//

import UIKit

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
        NetworkController.instance().emailConfirm(email: email) { [weak self](isSuccess) in
            guard let weakSelf = self else {return}
            if(isSuccess){
                let controller = UIAlertController(title: "傳送成功！", message: "傳送成功！", preferredStyle: .alert)
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
            if(isSuccess){
                let controller = UIAlertController(title: responseValue , message: responseValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default){(_) in
                        weakSelf.dismiss(animated: true, completion: nil)
                }
                controller.addAction(okAction)
                weakSelf.present(controller, animated: true, completion: nil)
            }else{
                let controller = UIAlertController(title: "未進行信件確認 或 確認失敗!" , message: responseValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default)
                controller.addAction(okAction)
                weakSelf.present(controller, animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

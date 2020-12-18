//
//  RegisterViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/9.
//

import UIKit

class RegisterViewController: BaseViewController,UITextFieldDelegate {
    
    let border = CALayer();
    //設定每個label的tag代表順序
    @IBOutlet weak var tfEmail: UnderLineTextField! {
        didSet {
            tfEmail.tag = 1
            tfEmail.becomeFirstResponder()
            tfEmail.delegate = self
        }
    }
    @IBOutlet weak var tfPassword: UnderLineTextField!{
        didSet {
            tfPassword.tag = 2
            tfPassword.delegate = self
        }
    }
    
    @IBOutlet weak var tfPasswordConfirm: UnderLineTextField!{
        didSet {
            tfPasswordConfirm.tag = 3
            tfPasswordConfirm.delegate = self
        }
    }
    @IBOutlet weak var btnRegisterConfirm: UIButton!
    @IBOutlet weak var tfPhone: UnderLineTextField!{
        didSet {
            tfPhone.tag = 4
            tfPhone.delegate = self
        }
    }
    @IBOutlet weak var tfName: UnderLineTextField!{
        didSet {
            tfName.tag = 5
            tfName.layer.cornerRadius = 5.0
            tfName.layer.masksToBounds = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定按鈕
        tfEmail.textColor = .white
        tfPassword.textColor = .white
        tfPasswordConfirm.textColor = .white
        tfName.textColor = .white
        tfPhone.textColor = .white
        //        btnRegisterConfirm.backgroundColor = #colorLiteral(red: 0.3729024529, green: 0.9108788371, blue: 0.7913612723, alpha: 1);
        // Do any additional setup after loading the view.
    }
    
 //設定按下return 自動跳到下一格，因為自定義textField的關係兩邊都需要實現UITextFieldDelegate，所以沒辦法用
 func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     if let nextTextField = view.viewWithTag(textField.tag + 1) {
         textField.resignFirstResponder()
         nextTextField.becomeFirstResponder()
     }
     return true
 }
    //設定註冊成功跳出alert提示
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

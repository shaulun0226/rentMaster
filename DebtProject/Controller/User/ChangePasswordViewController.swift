//
//  ChangePasswordViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/27.
//

import UIKit
import SwiftAlertView

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var tfOldPassword: UnderLineTextField!{
        didSet {
            tfOldPassword.tag = 1
            tfOldPassword.underLineTextFieldDelegate = self
        }
    }
    
    @IBOutlet weak var tfNewPassword: UnderLineTextField!{
        didSet {
            tfNewPassword.tag = 2
            tfNewPassword.underLineTextFieldDelegate = self
        }
    }
    @IBOutlet weak var tfNewPasswordConfirm: UnderLineTextField!{
        didSet {
            tfNewPasswordConfirm.tag = 3
            tfNewPasswordConfirm.underLineTextFieldDelegate = self
        }
    }
    @IBOutlet weak var lbErrorHint: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func emptyCheck()-> Bool{
        if(tfOldPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfNewPasswordConfirm.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            return false;
        }
        return true;
    }
    @IBAction func confirmClick(_ sender: Any) {
        if(!emptyCheck()){
            lbErrorHint.textColor = .red;
            lbErrorHint.text = "請確認資料是否輸入完整";
            return;
        }
        let oldPassword = tfOldPassword.text!
        let newPassword = tfNewPassword.text!
        let newPasswordConfirm = tfNewPasswordConfirm.text!
        if(!newPassword.elementsEqual(newPasswordConfirm)){
            lbErrorHint.textColor = .red;
            lbErrorHint.text = "請確認密碼是否相符";
            return
        }
        NetworkController.instance().changePasswordByTokenAnd(oldPassword: oldPassword, newPassword: newPassword) {
            [weak self](responseValue, isSuccess) in
            guard let weakSelf = self else {return}
            let alertView = SwiftAlertView(title: "", message: responseValue, delegate: nil, cancelButtonTitle: "確定")
            alertView.messageLabel.textColor = .white
            alertView.messageLabel.font = UIFont.systemFont(ofSize: 30)
            alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
            alertView.backgroundColor = UIColor(named: "Alert")
            alertView.buttonTitleColor = .white
            if(isSuccess){
                alertView.clickedButtonAction = { index in
                    if let mainPageView = Global.mainStoryboard.instantiateViewController(identifier:MainStoryboardController.mainPageViewController.rawValue ) as? MainPageViewController{
                        weakSelf.show(mainPageView, sender: nil);
                    }
                }
            }else{
                alertView.clickedButtonAction = { index in
                    alertView.dismiss()
                }
            }
            alertView.show()
        }
    }
}

//
//  ChangePasswordViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/27.
//

import UIKit

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

        // Do any additional setup after loading the view.
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
            if(isSuccess){
                let controller = UIAlertController(title: responseValue, message: responseValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default){(_) in
                    if let mainPageView = Global.mainStoryboard.instantiateViewController(identifier:MainStoryboardController.mainPageViewController.rawValue ) as? MainPageViewController{
                        weakSelf.show(mainPageView, sender: nil);
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

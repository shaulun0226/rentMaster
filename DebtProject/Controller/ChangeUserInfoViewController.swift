//
//  ChangeUserInfoViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/30.
//

import UIKit
import SwiftyJSON

class ChangeUserInfoViewController:BaseViewController {

    @IBOutlet weak var tfEmail: UnderLineTextField!
    @IBOutlet weak var tfName: UnderLineTextField!
    @IBOutlet weak var tfNickName: UnderLineTextField!
    @IBOutlet weak var tfPhone: UnderLineTextField!
    @IBOutlet weak var tfAddress: UnderLineTextField!
    @IBOutlet weak var btnModify: UIButton!
    var user:UserModel?
    @IBOutlet weak var lbErrorHint: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("token     \(User.token)")
        NetworkController.instance().getUserInfo{
            [weak self](responseValue, isSuccess) in
            guard let weakSelf = self else {return}
            if(isSuccess){
                let jsonArr = JSON(responseValue)
                print("使用者資訊   \(jsonArr)")
                weakSelf.parseUser(jsonArr: jsonArr)
                weakSelf.tfEmail.text = weakSelf.user?.email
                weakSelf.tfName.text = weakSelf.user?.name
                weakSelf.tfNickName.text = weakSelf.user?.nickName
                weakSelf.tfPhone.text = weakSelf.user?.phone
                weakSelf.tfAddress.text = weakSelf.user?.address
                weakSelf.changeTextFieldEnable(bool:false)
            }else{
                weakSelf.tfEmail.text = "123445"
                weakSelf.tfName.text = "213"
                weakSelf.tfNickName.text = "213"
                weakSelf.tfPhone.text = "555"
                weakSelf.tfAddress.text = "111"
            }
        }
        // Do any additional setup after loading the view.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath=="btnClick" {
            if(tfName.isEnabled){
                self.changeTextFieldEnable(bool:false)
                self.setTextFieldUnderLine(size: CGFloat(1))
                self.btnModify.setTitle("編輯", for: .normal)
                
            }else{
                self.changeTextFieldEnable(bool:true)
                self.setTextFieldUnderLine(size: CGFloat(0))
                self.btnModify.setTitle("完成", for: .normal)
                self.btnModify.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    private func parseUser(jsonArr:JSON){
            let id = jsonArr["id"].string ?? ""
            let email = jsonArr["email"].string ?? ""
            let name = jsonArr["name"].string ?? ""
            let nickName = jsonArr["nickName"].string ?? ""
            let phone = jsonArr["phone"].string ?? ""
            let address = jsonArr["address"].string ?? ""
            
            self.user = UserModel.init(id: id, email: email, name: name, nickName: nickName, phone: phone, address: address)
    }
    private func setTextFieldUnderLine(size:CGFloat){
        tfName.lineHeight = size
        tfAddress.lineHeight = size
        tfNickName.lineHeight = size
        tfPhone.lineHeight = size
    }
    private func changeTextFieldEnable( bool:Bool){
        tfName.isEnabled = bool
        tfNickName.isEnabled = bool
        tfPhone.isEnabled = bool
        tfAddress.isEnabled = bool
    }
    @IBAction func btnModifyClick(_ sender: Any) {
        switch btnModify.titleLabel?.text{
        case "編輯":
            changeTextFieldEnable(bool:true)
            self.setTextFieldUnderLine(size: CGFloat(1))
            btnModify.setTitle("完成", for:.normal)
            self.btnModify.backgroundColor = UIColor(named: "Button")
        case "完成":
            if(tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
                tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" /*||
                tfAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
                tfNickName.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""*/){
                lbErrorHint.textColor = .red
                lbErrorHint.text = "姓名或電話為必填"
                return
            }
            lbErrorHint.textColor = .clear
            changeTextFieldEnable(bool:false)
            self.setTextFieldUnderLine(size: CGFloat(0))
            btnModify.setTitle("編輯", for:.normal)
            self.btnModify.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            let name = tfName.text!
            let phone = tfPhone.text!
            let address = tfAddress.text ?? ""
            let nickName = tfNickName.text ?? ""
            NetworkController.instance().changeUserInfo(name: name, nickName: nickName, phone: phone, address: address){
                [weak self] (isSuccess) in
                // 如果此 weakSelf 賦值失敗，就 return
                guard let weakSelf = self else {return}
                if(isSuccess){
                    let controller = UIAlertController(title: "變更成功", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default)
                    controller.addAction(okAction)
                    weakSelf.present(controller, animated: true, completion: nil)
                }else{
                    let controller = UIAlertController(title: "變更失敗", message: "請再試一次", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default)
                    controller.addAction(okAction)
                    weakSelf.present(controller, animated: true, completion: nil)
                }
            }
        case .none:
            print("按鈕按下1")
        case .some(_):
            print("按鈕按下2")
        }
    }
}

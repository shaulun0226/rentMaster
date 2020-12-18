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
    @IBOutlet weak var tfAccount: UnderLineTextField!
    @IBOutlet weak var tfPassword: UnderLineTextField!
    
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
//        btnLogin.backgroundColor = #colorLiteral(red: 0.3729024529, green: 0.9108788371, blue: 0.7913612723, alpha: 1)
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
        //切換畫面
        let vcMain = self.storyboard?.instantiateViewController(identifier: "MainPageViewController");
        self.show(vcMain!, sender: LoginViewController.self);
//        let body: [String : Any] = ["title": "foo",
//                                    "body": "bar",
//                                    "userId": 1]
//        NetworkController(data: body, url: nil, service: .posts, method: .post).executeQuery(){
//            (result: Result<Post,Error>) in
//            switch result{
//            case .success(let post):
//                print(post)
//            case .failure(let error):
//                print(error)
//            }
//        }
        if(!verify()){
            errorHint.textColor = .red;
            errorHint.text = "請輸入帳號和密碼";
            return;
        }
        let account =  tfAccount.text!;
        let password = tfPassword.text!;

        let parameters: [String: String] = [
            "account": account,
            "password": password,
        ];
        AF.request(Global.URL+"/user/login",method: .post,parameters: parameters)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        let errorCode = JSON["errorCode"] as! Int
                        if(errorCode==200){
                        let vcMain = self.storyboard?.instantiateViewController(identifier: "MainPageViewController");
                        self.show(vcMain!, sender: LoginViewController.self);
                        }
                        print(errorCode)
                    }
                case .failure(let error):
                    print(error);
                    break
                // error handling
                }

            };
    }

}


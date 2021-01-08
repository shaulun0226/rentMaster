//
//  BaseViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/15.
//

import UIKit
import SwiftAlertView

class BaseViewController: UIViewController,UnderLineTextFieldDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定navigation bar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
        //設定barItem 的顏色
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let layer = Global.setBackgroundColor(view);
        view.layer.insertSublayer(layer, at: 0)
        // Do any additional setup after loading the view.
        
        
    }
    
    func underLineTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag+1
        print(textField.tag)
        if(textField.superview is DesignableView){
            if let nextResponder = textField.superview?.superview?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }else{
            if let nextResponder = textField.superview?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        return true
    }
}


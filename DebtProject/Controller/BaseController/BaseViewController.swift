//
//  BaseViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/15.
//

import UIKit
import SwiftAlertView

class BaseViewController: UIViewController{
    //目前選取的textField
    var activeTextField : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBar")
        //設定barItem 的顏色
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //漸層背景
//        let layer = Global.setBackgroundColor(view);
//        view.layer.insertSublayer(layer, at: 0)
        view.backgroundColor = UIColor(named: "background-bottom")
        // Do any additional setup after loading the view.
        
//        //設定觀察鍵盤
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        //設定按外面會把鍵盤收起(有可能會手勢衝突)
////        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
////        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
    }
    @objc func keyboardWillShow(notification: NSNotification) {

      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

        // if keyboard size is not available for some reason, dont do anything
        return
      }

      var shouldMoveViewUp = false

      // if active text field is not nil
      if let activeTextField = activeTextField {

        let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;

        let topOfKeyboard = self.view.frame.height - keyboardSize.height

        // if the bottom of Textfield is below the top of keyboard, move up
        if bottomOfTextField > topOfKeyboard {
          shouldMoveViewUp = true
        }
      }

      if(shouldMoveViewUp) {
        self.view.frame.origin.y = 0 - keyboardSize.height
      }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    //點擊空白收回鍵盤
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
}
extension BaseViewController : UnderLineTextFieldDelegate {
    func underLineTextFieldTextFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        print("目前")
    }
    
    func underLineTextFieldTextFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
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

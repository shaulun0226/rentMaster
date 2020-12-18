//
//  loginTextField.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/11.
//

import UIKit

class UnderLineTextField: UITextField,UITextFieldDelegate{
    let border = CALayer();
    
    //底線的顏色
    @IBInspectable open var lineColor : UIColor = UIColor.black {
           didSet{
               border.borderColor = lineColor.cgColor
           }
       }
    //編輯TextField時底線的顏色
       @IBInspectable open var selectedLineColor : UIColor = UIColor.black {
           didSet{
           }
       }
    // 線的粗度
       @IBInspectable open var lineHeight : CGFloat = CGFloat(1.0) {
           didSet{
               border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
           }
       }

       required init?(coder aDecoder: (NSCoder?)) {
           super.init(coder: aDecoder!)
           self.delegate=self;
           border.borderColor = lineColor.cgColor
        //設定提示字的顏色
           self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])


           border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
           border.borderWidth = lineHeight
           self.layer.addSublayer(border)
           self.layer.masksToBounds = true
       }

       override func draw(_ rect: CGRect) {
           border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
       }

       override func awakeFromNib() {
           super.awakeFromNib()
           border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
           self.delegate = self
       }

       func textFieldDidBeginEditing(_ textField: UITextField) {
//        border.borderColor = #colorLiteral(red: 0.3729024529, green: 0.9108788371, blue: 0.7913612723, alpha: 1)
        border.borderColor = selectedLineColor.cgColor
       }

       func textFieldDidEndEditing(_ textField: UITextField) {
        border.borderColor = UIColor.darkGray.cgColor
//           border.borderColor = lineColor.cgColor
       }
}

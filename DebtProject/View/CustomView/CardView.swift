//
//  CardView.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/17.
//

import UIKit
class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 8

    @IBInspectable var shadowOffsetWidth: Int = 5
    @IBInspectable var shadowOffsetHeight: Int = 5
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 5

    override func layoutSubviews() {
        layer.cornerRadius = self.cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        
        layer.masksToBounds = false
        layer.shadowColor = self.shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: self.shadowOffsetWidth, height: self.shadowOffsetHeight);
        layer.shadowOpacity = self.shadowOpacity
    }

}

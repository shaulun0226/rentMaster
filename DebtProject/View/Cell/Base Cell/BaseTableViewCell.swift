//
//  BaseTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/22.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    //陰影
    var shadowOffsetWidth: Int = 1//偏移量
    var shadowOffsetHeight: Int = 1//偏移量
    var shadowColor: UIColor? =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //陰影顏色
    var shadowOpacity: Float = 0.1//陰影的透明度
    var cornerRadius: CGFloat = 5
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        backgroundColor = UIColor(named: "Card-1")
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        //設定陰影
//        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//        layer.masksToBounds = false
//        layer.shadowColor = shadowColor?.cgColor
//        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowPath = shadowPath.cgPath
    }
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
//            frame.origin.y = 5//調整y起點
            frame.origin.x = 5//調整x起點
            frame.size.height -= 2 * frame.origin.x//調整高度
            frame.size.width -= 2 * frame.origin.x//調整寬度
            super.frame = frame
        }
    }
}

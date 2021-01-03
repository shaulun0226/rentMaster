//
//  BaseTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/22.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    var cornerRadius: CGFloat = 20
//    var shadowOffsetWidth: Int = 1
//    var shadowOffsetHeight: Int = 1
//    var shadowColor: UIColor? =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //陰影顏色
//    var shadowOpacity: Float = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        layer.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1).cgColor
        //
        layer.cornerRadius = cornerRadius
        //設定陰影
        //        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        //        layer.masksToBounds = false
        //        layer.shadowColor = shadowColor?.cgColor
        //        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        //        layer.shadowOpacity = shadowOpacity
        //        layer.shadowPath = shadowPath.cgPath
        //        設定框線
        //        layer.borderWidth = 1.0
        //        layer.borderColor = UIColor.black.cgColor
    }
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 5//調整y起點
            frame.origin.x = 10//調整x起點
            frame.size.height -= 15//調整高度
            frame.size.width -= 2 * frame.origin.x//調整寬度
            super.frame = frame
        }
    }
}

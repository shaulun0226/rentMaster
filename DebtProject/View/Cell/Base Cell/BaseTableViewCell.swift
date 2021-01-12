//
//  BaseTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/22.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    var cornerRadius: CGFloat = 20
    var shadowOffsetWidth: Int = 1
    var shadowOffsetHeight: Int = 1
    var shadowColor: UIColor? =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //陰影顏色
    var shadowOpacity: Float = 0.4
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setShadow(){
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 0)
         layer.shadowColor = UIColor.black.cgColor

        // add corner radius on `contentView`
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = cornerRadius
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
            frame.origin.y += 5//調整y起點
            frame.origin.x += 5//調整x起點
            frame.size.height -= 15//調整高度
            frame.size.width -= 2 * 5
            super.frame = frame
        }
    }
}

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
        layer.cornerRadius = cornerRadius
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

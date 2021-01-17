//
//  MemberCenterTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/29.
//

import UIKit

class MemberCenterTableViewCell: BaseTableViewCell {

    @IBOutlet weak var lbTilte:UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        設定陰影
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

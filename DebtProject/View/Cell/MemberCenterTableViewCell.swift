//
//  MemberCenterTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/29.
//

import UIKit

class MemberCenterTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTilte:UILabel!
    var cornerRadius: CGFloat = 20
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 5//調整y起點
            frame.origin.x = 20//調整x起點
            frame.size.height -= 15//調整高度
            frame.size.width -= 2 * frame.origin.x//調整寬度
            super.frame = frame
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
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

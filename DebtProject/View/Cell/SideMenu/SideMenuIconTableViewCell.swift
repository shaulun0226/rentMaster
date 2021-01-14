//
//  SideMenuIconTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/14.
//

import UIKit

class SideMenuIconTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImg.layer.masksToBounds = false
        iconImg.layer.cornerRadius = iconImg.frame.height/2
        iconImg.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

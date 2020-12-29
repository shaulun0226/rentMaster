//
//  wantChangeTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/28.
//

import UIKit

class WantChangeTableViewCell: UITableViewCell {
    @IBOutlet weak var lbChangeTitle:UILabel!
    @IBOutlet weak var tfChangeProduct:UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

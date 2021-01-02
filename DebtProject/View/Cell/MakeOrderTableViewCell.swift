//
//  MakeOrderTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/2.
//

import UIKit

class MakeOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var btnSeleted :UIButton!
    @IBOutlet weak var lbExchangeProductName :UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

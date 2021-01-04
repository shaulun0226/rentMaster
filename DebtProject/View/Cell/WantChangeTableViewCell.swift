//
//  wantChangeTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/28.
//

import UIKit

class WantChangeTableViewCell: BaseTableViewCell {
    @IBOutlet weak var lbNumber:UILabel!
    @IBOutlet weak var tfExchangeProduct:UnderLineTextField!
    @IBOutlet weak var tfExchangeAmount:UnderLineTextField!
    @IBOutlet weak var tfEXchangeWorth:UnderLineTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

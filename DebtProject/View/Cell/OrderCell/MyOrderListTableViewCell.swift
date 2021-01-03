//
//  MyOrderListTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/31.
//

import UIKit

class MyOrderListTableViewCell: BaseTableViewCell {
    @IBOutlet weak var ivProduct:UIImageView!
    @IBOutlet weak var lbProductTitle:UILabel!
    @IBOutlet weak var lbProductDescription:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

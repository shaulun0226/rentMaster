//
//  MakeOrderTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/2.
//

import UIKit
protocol MakeOrderTableViewCellDelegate  : AnyObject {
    func wishItemClick(btnWishItem :UIButton)
    func wishItemAmountClick(btnWishItem :UIButton,btnWishItemAmount :UIButton)
}
class MakeOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var btnWishItem :UIButton!
    @IBOutlet weak var btnWishItemAmount: UIButton!
    weak var makeOrderTableViewCellDelegate:MakeOrderTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func changeItemClick(_ sender: Any) {
        makeOrderTableViewCellDelegate?.wishItemClick(btnWishItem: btnWishItem)
    }
    
    @IBAction func changeItemAmountClick(_ sender: Any) {
        makeOrderTableViewCellDelegate?.wishItemAmountClick(btnWishItem: btnWishItem, btnWishItemAmount: btnWishItemAmount)
    }
}

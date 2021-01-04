//
//  wantChangeTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/28.
//

import UIKit

class WishListTableViewCell: BaseTableViewCell {
    @IBOutlet weak var lbNumber:UILabel!
    @IBOutlet weak var lbWishProductName: UILabel!
    @IBOutlet weak var lbWishProductWeightPrice: UILabel!
    @IBOutlet weak var lbWishProductAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func configure(wishListModel:WishListModel){
        lbWishProductName.text = "願意交換商品: \(wishListModel.productName)"
        lbWishProductAmount.text =
            "數量: \(wishListModel.amount)"
        lbWishProductWeightPrice.text = "商品價值權重: \(wishListModel.weightPrice)"
    }
}

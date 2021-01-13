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
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        //        設定陰影
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        //        設定框線
        //        layer.borderWidth = 1.0
        //        layer.borderColor = UIColor.black.cgColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func configure(wishListModel:WishItemModel){
        lbWishProductName.text = "願意交換商品: \(wishListModel.productName)"
        lbWishProductAmount.text =
            "數量: \(wishListModel.amount)"
        lbWishProductWeightPrice.text = "商品價值權重: \(wishListModel.weightPrice)"
    }
}

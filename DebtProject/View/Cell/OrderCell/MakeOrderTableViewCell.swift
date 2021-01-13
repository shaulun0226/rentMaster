//
//  MakeOrderTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/2.
//

import UIKit
protocol MakeOrderTableViewCellDelegate  : AnyObject {
    func wishItemSelectClick(wishItemName:String,btnIsSelected:Bool,btnWishItem :UIButton)->Bool
    func wishItemAmountClick(itemAmount:Int,btnWishItem :UIButton,btnWishItemAmount :UIButton)
    func wishItemSelectClick()
}
class MakeOrderTableViewCell: BaseTableViewCell {
    @IBOutlet weak var btnWishItemSelect :UIButton!
    @IBOutlet weak var btnWishItemAmount: UIButton!
    @IBOutlet weak var btnTriangle: UIButton!
    @IBOutlet weak var lbWeightPrice: UILabel!
    @IBOutlet weak var lbWishItemName: UILabel!
    //
    var wishItemName:String!
    var btnIsSelected = false
    var itemAmount = 0
    var wishItem:WishItemModel!
    var wishItemWeightPrice:Float = 0.0
    weak var makeOrderTableViewCellDelegate:MakeOrderTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = cornerRadius
        // Initialization code
        //設定陰影
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
//        //        設定框線
//        layer.borderWidth = 1.0
//        layer.borderColor = UIColor.black.cgColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure(wishItem:WishItemModel){
        lbWishItemName.text = wishItem.productName
        wishItemName = wishItem.productName
        lbWeightPrice.text = String(wishItem.weightPrice)
        itemAmount = wishItem.amount
        wishItemWeightPrice = wishItem.weightPrice
        self.wishItem = wishItem
    }
    @IBAction func checkMarkClick(_ sender: Any) {
        
        guard  let makeOrderTableViewCellDelegate = makeOrderTableViewCellDelegate else {
            return
        }
        self.btnIsSelected  = makeOrderTableViewCellDelegate.wishItemSelectClick(wishItemName:wishItemName,btnIsSelected: btnIsSelected,btnWishItem: btnWishItemSelect)
        makeOrderTableViewCellDelegate.wishItemSelectClick()
    }
    
    @IBAction func changeItemAmountClick(_ sender: Any) {
        makeOrderTableViewCellDelegate?.wishItemAmountClick(itemAmount:itemAmount,btnWishItem: btnWishItemSelect, btnWishItemAmount: btnWishItemAmount)
    }
    @IBAction func btnTriangleClick(_ sender: Any) {
        makeOrderTableViewCellDelegate?.wishItemAmountClick(itemAmount:itemAmount,btnWishItem: btnWishItemSelect, btnWishItemAmount: btnWishItemAmount)
    }
}

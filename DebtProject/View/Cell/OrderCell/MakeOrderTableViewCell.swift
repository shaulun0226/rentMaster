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
class MakeOrderTableViewCell: UITableViewCell {
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
    //陰影
    var shadowOffsetWidth: Int = 2//偏移量
    var shadowOffsetHeight: Int = 2//偏移量
    var shadowColor: UIColor? =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //陰影顏色
    var shadowOpacity: Float = 0.6//陰影的透明度
    var cornerRadius: CGFloat = 10
    weak var makeOrderTableViewCellDelegate:MakeOrderTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = cornerRadius
        // Initialization code
        //設定背景
        let layer = CAGradientLayer();
        layer.frame = self.contentView.bounds;
        layer.colors = Global.BACKGROUND_COLOR as [Any]
        layer.startPoint = CGPoint(x: 0,y: 0.5);
        layer.endPoint = CGPoint(x: 1,y: 0.5);
        self.layer.insertSublayer(layer, at: 0)
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
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 5//調整y起點
            frame.origin.x = 10//調整x起點
            frame.size.height -= 15//調整高度
            frame.size.width -= 2 * frame.origin.x//調整寬度
            super.frame = frame
        }
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

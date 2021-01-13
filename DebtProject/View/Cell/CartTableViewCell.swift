//
//  CartTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/23.
//

import UIKit
protocol CartTableViewCellDelegate : AnyObject{
    func menuOnClick(index:Int)
}

class CartTableViewCell: BaseTableViewCell {
    @IBOutlet weak var cartImg:UIImageView!
    @IBOutlet weak var lbCartProductName:UILabel!
    @IBOutlet weak var lbTradeType:UILabel!
    @IBOutlet weak var lbCartPrice:UILabel!
    @IBOutlet weak var btnMenu:UIButton!
    var index:Int!
    weak var  cartTableViewCellDelegate:CartTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    //加入此段程式碼讓每個cell間有空隙
//    override open var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set (newFrame) {
//            var frame =  newFrame
//            frame.origin.x += 5//調整x起點
//            frame.size.height -= 2 * frame.origin.x//調整高度
//            frame.size.width -= 2 * frame.origin.x//調整寬度
//            super.frame = frame
//        }
//    }
    @IBAction func menuOnClick(){
        print("按下按鈕")
        cartTableViewCellDelegate?.menuOnClick(index:self.index)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //        設定陰影
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    func configure(with model: ProductModel) {
        self.lbCartProductName.text = model.title
        self.lbTradeType.text = model.description
        self.lbCartPrice.text = String(model.salePrice)
        var price = [String]()
        //        var price = ""
        if(model.isSale){
            //            price += "售價:\(model.salePrice)元，"
            price.append("售價:\(model.salePrice)元")
        }
        if(model.isRent){
            //            price += "保證金:\(model.deposit)元，"
            //            price += "租金:\(model.rent)元/日，"
            price.append("租金:\(model.rent)元/日")
        }
        if(model.isExchange){
            //            price += "權重:\(model.weightPrice)"
            price.append("權重:\(model.weightPrice)")
        }
        
        var priceText = ""
        for index in 0..<price.count {
            if(index==price.count-1){
                priceText += "\(price[index])"
            }else{
                priceText += "\(price[index])，"
            }
            self.lbCartPrice.text = priceText
            var saleType = [String]()
            if(model.isSale){
                saleType.append("販售")
            }
            if(model.isRent){
                saleType.append("租借")
            }
            if(model.isExchange){
                saleType.append("交換")
            }
            var saleTypeText = ""
            for index in 0..<saleType.count {
                if(index==saleType.count-1){
                    saleTypeText += "\(saleType[index])"
                }else{
                    saleTypeText += "\(saleType[index])/"
                }
            }
            lbTradeType.text = "交易模式:\(saleTypeText)"
            
            
            
            if model.pics.count == 0 {
                self.cartImg.image = UIImage(named: "imageNotFound")
                return
            }
            //        self.cartImg.image = UIImage(named: model.pics[0])
            let imgUrl = model.pics[0].path
            //防止url內有中文 先進行編碼
            let newUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let articleUrl = URL(string: newUrl)
            self.cartImg.kf.indicatorType = .activity
            self.cartImg.kf.setImage(with: articleUrl,placeholder: UIImage(named: "camera.png"))
           
        }
    }

}

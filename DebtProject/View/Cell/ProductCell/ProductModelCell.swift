//
//  TestCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/15.
//

import UIKit
import Kingfisher

class ProductModelCell: BaseTableViewCell {
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice :UILabel!
    @IBOutlet weak var lbProductAmount:UILabel!
    @IBOutlet weak var lbTradeType:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        // Configure the view for the selected state
    }
    //加入此段程式碼讓每個cell間有空隙
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
    func configure(with model: ProductModel) {
        self.lbName.text = model.title
        self.lbProductAmount.text = "剩餘數量:\(model.amount)"
        
        var price = ""
        if(model.isSale){
            price += "售價:\(model.salePrice)元\n"
        }
        if(model.isRent){
            price += "保證金:\(model.deposit)元\n"
            price += "租金:\(model.rent)元/日\n"
        }
        if(model.isExchange){
            price += "權重:\(model.weightPrice)"
        }
        self.lbPrice.text = price
        
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
            self.img.image = UIImage(named: "imageNotFound")
            return
        }
        //        self.img.image = UIImage(named: model.pics[0])
        let imgUrl = model.pics[0].path
        if (!imgUrl.contains("http")){
            self.img.image = UIImage(named: "imageNotFound")
            return
        }
        //防止url內有中文 先進行編碼
        let newUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let articleUrl = URL(string: newUrl)
        self.img.kf.indicatorType = .activity
        self.img.kf.setImage(with: articleUrl,placeholder: UIImage(named: "camera.png"))
    }
    
}

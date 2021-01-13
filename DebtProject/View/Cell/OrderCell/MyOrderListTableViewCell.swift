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
    @IBOutlet weak var lbProductTradeMethod:UILabel!
    @IBOutlet weak var lbTradeQuantity:UILabel!
    @IBOutlet weak var lbTradeState:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
    func configure(with model: OrderModel) {
        self.lbProductTitle.text = model.p_Title
        self.lbTradeQuantity.text = "交易數量 : \(model.tradeQuantity)"
        switch model.tradeMethod {
        case 0://租
            lbProductTradeMethod.text = "租借"
        case 1://買
            lbProductTradeMethod.text = "購買"
        case 2://換
            lbProductTradeMethod.text = "交換"
        default:
            lbProductTradeMethod.text = ""
        }
        lbTradeState.text = "訂單狀態 : \(model.status)"
//        var price = [String]()
        if model.pics.count == 0 {
            self.ivProduct.image = UIImage(named: "imageNotFound")
            return
        }
        //        self.cartImg.image = UIImage(named: model.pics[0])
        let imgUrl = model.pics[0].path
        //防止url內有中文 先進行編碼
        let newUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let articleUrl = URL(string: newUrl)
        self.ivProduct.kf.indicatorType = .activity
        self.ivProduct.kf.setImage(with: articleUrl,placeholder: UIImage(named: "camera.png"))
        
    }
}

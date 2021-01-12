//
//  MyStoreTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/6.
//

import UIKit

class MyStoreTableViewCell: BaseTableViewCell {
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice :UILabel!
    @IBOutlet weak var lbTradeType:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        super.setShadowAndCornerRadius()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        // Configure the view for the selected state
    }
    
    func configure(with model: ProductModel) {
        self.lbName.text = model.title
        self.lbTradeType.text = model.description
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
        lbTradeType.text = "\(saleTypeText)"
        
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

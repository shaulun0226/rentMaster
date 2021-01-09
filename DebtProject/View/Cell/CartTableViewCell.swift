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

class CartTableViewCell: UITableViewCell {
    @IBOutlet weak var cartImg:UIImageView!
    @IBOutlet weak var lbCartProductName:UILabel!
    @IBOutlet weak var lbTradeType:UILabel!
    @IBOutlet weak var lbCartPrice:UILabel!
    @IBOutlet weak var btnMenu:UIButton!
    var index:Int!
    weak var  cartTableViewCellDelegate:CartTableViewCellDelegate?
    
    var cornerRadius: CGFloat = 20
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //加入此段程式碼讓每個cell間有空隙
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 5//調整y起點
            frame.origin.x += 5//調整x起點
            frame.size.height -= 15//調整高度
            frame.size.width -= 2 * 10//調整寬度
            super.frame = frame
        }
    }
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
        layer.cornerRadius = cornerRadius
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
            //        let url = model.img
            //        let url = URL(string: "\(model.imgUrl)")
            //
            //        // load img
            //        let session = URLSession(configuration: .default)
            //
            //        // 下載資料後存檔在加目錄中的tmp目錄下，完整路徑在location參數中
            //        let dnTask = session.downloadTask(with: url!) { (location, response, error) in
            //            // 注意此 block 區段已在另外一個執行緒
            //            if error == nil, let location = location {
            //                do {
            //                    // 從存檔中讀取資料
            //                    if let data = try? Data(contentsOf: location) {
            //                        DispatchQueue.main.sync {
            //                            self.img.image = UIImage(data: data)
            //                        }
            //                    }
            //                }
            //            } else {
            //                print("讀取資料錯誤")
            //            }
            //        }
            //        // 開始執行
            //        dnTask.resume()
        }
    }

}

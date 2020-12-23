//
//  TestCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/15.
//

import UIKit

class ProductModelCell: UITableViewCell {
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice :UILabel!
    @IBOutlet weak var lbDiscription:UILabel!
    
    var cornerRadius: CGFloat = 20
    var shadowOffsetWidth: Int = 1
    var shadowOffsetHeight: Int = 1
    var shadowColor: UIColor? =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //陰影顏色
    var shadowOpacity: Float = 1
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
            frame.origin.x += 5//調整x起點
            frame.size.height -= 15//調整高度
            frame.size.width -= 2 * 10//調整寬度
            super.frame = frame
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        layer.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1).cgColor
//
        layer.cornerRadius = cornerRadius
        //設定陰影
//        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//        layer.masksToBounds = false
//        layer.shadowColor = shadowColor?.cgColor
//        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowPath = shadowPath.cgPath
//        設定框線
//        layer.borderWidth = 1.0
//        layer.borderColor = UIColor.black.cgColor
    }
    func configure(with model: ProductModel) {
        self.lbName.text = model.title
        self.lbDiscription.text = model.description
        self.lbPrice.text = String(model.salePrice)
        if model.pics.count == 0 {
            self.img.image = UIImage(named: "monsterhunter")
            return
        }
        self.img.image = UIImage(named: model.pics[0])
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

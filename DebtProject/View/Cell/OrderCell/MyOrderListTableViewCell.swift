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
    @IBOutlet weak var lbProductDescription:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 5//調整y起點
            frame.origin.x = 5//調整x起點
            frame.size.height -= 15//調整高度
            frame.size.width -= 2 * frame.origin.x//調整寬度
            super.frame = frame
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
    }
    func configure(with model: OrderModel) {
        self.lbProductTitle.text = model.p_Title
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

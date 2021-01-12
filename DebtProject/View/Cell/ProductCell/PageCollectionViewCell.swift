//
//  PageCollectionViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/17.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbState: UILabel!
    var cornerRadius: CGFloat = 5
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            //               frame.origin.y += 5//調整y起點
            frame.origin.x = 8//調整x起點
            frame.size.height -= 2 * frame.origin.x//調整高度
            frame.size.width -= 2 * frame.origin.x
            super.frame = frame
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //設定陰影
        // add shadow on cell
           backgroundColor = .clear // very important
           layer.masksToBounds = false
           layer.shadowOpacity = 0.23
           layer.shadowRadius = 5
           layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowColor = UIColor.black.cgColor

        
        //設定圓角
           // add corner radius on `contentView`
           contentView.backgroundColor = UIColor(named: "Card-1")
           contentView.layer.cornerRadius = cornerRadius
       
    }
    func configure(with model: ProductModel) {
        self.lbTitle.text = model.title
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
        self.lbState.text = saleTypeText
        //放照片
        if model.pics.count == 0 {
            self.imgGame.image = UIImage(named: "imageNotFound")
            return
        }
        //        self.img.image = UIImage(named: model.pics[0])
        let imgUrl = model.pics[0].path
        if (!imgUrl.contains("http")){
            self.imgGame.image = UIImage(named: "imageNotFound")
            return
        }
        //防止url內有中文 先進行編碼
        let newUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let articleUrl = URL(string: newUrl)
        self.imgGame.kf.indicatorType = .activity
        self.imgGame.kf.setImage(with: articleUrl,placeholder: UIImage(named: "camera.png"))
    }
}


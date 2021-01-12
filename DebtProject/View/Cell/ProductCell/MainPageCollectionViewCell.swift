//
//  MainPageCollectionViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/12.
//

import UIKit

class MainPageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    func addShadow(backgroundColor: UIColor = .white, cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 5, shadowOpacity: Float = 0.1, shadowPathInset: (dx: CGFloat, dy: CGFloat), shadowPathOffset: (dx: CGFloat, dy: CGFloat)) {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = shadowOpacity
            layer.shadowPath = UIBezierPath(roundedRect: bounds.insetBy(dx: shadowPathInset.dx, dy: shadowPathInset.dy).offsetBy(dx: shadowPathOffset.dx, dy: shadowPathOffset.dy), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
            
            let whiteBackgroundView = UIView()
            whiteBackgroundView.backgroundColor = backgroundColor
            whiteBackgroundView.layer.cornerRadius = cornerRadius
            whiteBackgroundView.layer.masksToBounds = true
            whiteBackgroundView.clipsToBounds = false
            
            whiteBackgroundView.frame = bounds.insetBy(dx: shadowPathInset.dx, dy: shadowPathInset.dy)
            insertSubview(whiteBackgroundView, at: 0)
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

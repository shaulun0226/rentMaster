//
//  ProductInfoImageCollectionViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/19.
//

import UIKit

class ProductInfoImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    static let width = floor(UIScreen.main.bounds.width)


    override func awakeFromNib() {
        super.awakeFromNib()
        widthConstraint.constant = Self.width
        // Initialization code
    }
    func configure(with imgUrl: String) {
        if (!imgUrl.contains("http")){
            self.productImage.image = UIImage(named: "imageNotFound")
            return
        }
        //防止url內有中文 先進行編碼
        let newUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let articleUrl = URL(string: newUrl)
        self.productImage.kf.indicatorType = .activity
        self.productImage.kf.setImage(with: articleUrl,placeholder: UIImage(named: "camera.png"))
    }
    
    func configureWithImg(with image:UIImage) {
        self.productImage.image = image
    }
}

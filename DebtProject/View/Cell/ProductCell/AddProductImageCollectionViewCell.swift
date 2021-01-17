//
//  AddImageCollectionViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/20.
//

import UIKit
protocol AddProductImageCollectionViewCellDelegate {
    func deleteClick(indexPath:IndexPath)
}
class AddProductImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView:UIImageView!
    var indexPath:IndexPath!
    var addProductImageCollectionViewCellDelegate:AddProductImageCollectionViewCellDelegate?
    func configureWithImg(with image:UIImage) {
        self.imageView.image = image
    }
    func configureWithUrl(with imgUrl:String){
        if (!imgUrl.contains("http")){
            self.imageView.image = UIImage(named: "imageNotFound")
            return
        }
        //防止url內有中文 先進行編碼
        let newUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let articleUrl = URL(string: newUrl)
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: articleUrl,placeholder: UIImage(named: "camera.png"))
    }
    @IBAction func deleteClick (_sender:Any){
        addProductImageCollectionViewCellDelegate?.deleteClick(indexPath: indexPath)
    }
}

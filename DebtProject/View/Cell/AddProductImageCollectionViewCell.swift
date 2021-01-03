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
    @IBOutlet weak var image:UIImageView!
    var indexPath:IndexPath!
    var addProductImageCollectionViewCellDelegate:AddProductImageCollectionViewCellDelegate?
    func configureWithImg(with image:UIImage) {
        self.image.image = image
    }
    @IBAction func deleteClick (_sender:Any){
        addProductImageCollectionViewCellDelegate?.deleteClick(indexPath: indexPath)
    }
}

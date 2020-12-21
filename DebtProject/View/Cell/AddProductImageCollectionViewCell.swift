//
//  AddImageCollectionViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/20.
//

import UIKit

class AddProductImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image:UIImageView!
    func configureWithImg(with image:UIImage) {
        self.image.image = image
    }
}

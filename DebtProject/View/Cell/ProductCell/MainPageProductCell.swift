//
//  MainPageProductCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/16.
//

import UIKit

class MainPageProductCell: UICollectionViewCell {
    
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbstate: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    func configure(with model: ProductModel) {
        self.lbTitle.text = model.title
        self.lbPrice.text = String(model.salePrice)
        self.imgGame.image = UIImage(named: model.pics[0].path)
        self.lbstate.text = model.description
    }
}

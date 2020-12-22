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
        self.lbTitle.text = model.name
        self.lbPrice.text = String(model.price)
        self.imgGame.image = UIImage(named: model.imgUrl)
        self.lbstate.text = model.discription
    }
}

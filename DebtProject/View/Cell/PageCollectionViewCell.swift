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
    @IBOutlet weak var lbPrice: UILabel!
    func configure(with model: ProductModel) {
        self.lbTitle.text = model.title
        self.lbPrice.text = String(model.salePrice)
        self.imgGame.image = UIImage(named: model.pics[0])
        self.lbState.text = model.description
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


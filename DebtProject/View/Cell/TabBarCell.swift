//
//  TabBarCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/15.
//

import UIKit

class TabBarCell: UICollectionViewCell {
    @IBOutlet weak var lbTitle : UILabel!
    override var isSelected: Bool{
        didSet{
            if (self.isSelected) {
                print("tabbar被選")
                self.contentView.backgroundColor = UIColor(named: "tabbarBackgroundSelected")
            }
            else {
                print("tabbar沒被選")
                self.contentView.backgroundColor = UIColor(named: "tabbarBackground")
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

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
                self.contentView.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
            }
            else {
                self.contentView.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
            }
        }
    }
}

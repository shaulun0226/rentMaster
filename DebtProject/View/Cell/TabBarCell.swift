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
                self.contentView.backgroundColor = UIColor(named: "Button")
            }
            else {
                print("tabbar沒被選")
                self.contentView.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
            }
        }
    }
}

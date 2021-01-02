//
//  MakeOrderTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/2.
//

import UIKit
protocol MakeOrderTableViewCellDelegate {
    func changeItemClick(btnChangeItem :UIButton)
}
class MakeOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var btnChangeItem :UIButton!
    var makeOrderTableViewCellDelegate:MakeOrderTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func changeItemClick(_ sender: Any) {
        makeOrderTableViewCellDelegate?.changeItemClick(btnChangeItem: btnChangeItem)
    }
 }

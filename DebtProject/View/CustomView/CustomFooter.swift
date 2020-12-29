//
//  CustomFooter.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/28.
//

import UIKit
protocol CustomFooterDelegate {
    func removeClick()
    func addClick()
}
class CustomFooter: UITableViewHeaderFooterView {
    var customFooterDelegate:CustomFooterDelegate?
    @IBAction func removeClick(_ sender: Any) {
        print(customFooterDelegate)
        customFooterDelegate?.removeClick()
        print("按下刪除")
    }
    @IBAction func addClick(_ sender: Any) {
        customFooterDelegate?.addClick()
        
        print("按下新增")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

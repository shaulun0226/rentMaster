//
//  CustomFooter.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/28.
//

import UIKit
protocol CustomFooterDelegate :AnyObject{
    func removeClick()
    func addClick()
}
class CustomFooter: UITableViewHeaderFooterView {
    weak var customFooterDelegate:CustomFooterDelegate?
    @IBAction func removeClick(_ sender: Any) {
        customFooterDelegate?.removeClick()
        print("按下刪除")
    }
    @IBAction func addClick(_ sender: Any) {
        customFooterDelegate?.addClick()
        print("按下新增")
    }

}

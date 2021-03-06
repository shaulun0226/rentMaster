//
//  CartCellMenuViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/23.
//

import UIKit

protocol CartCellMenuViewDelegate {
    func deleteClick(index:Int,view:UIViewController)
}
//點擊購物車內按鈕彈出來的小視窗
class CartCellMenuViewController: UIViewController {
    var index:Int!
    @IBOutlet weak var btnDeleteConfirm:UIButton!
    var cartCellMenuViewDelegate:CartCellMenuViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func deleteClick(){
        cartCellMenuViewDelegate?.deleteClick(index: self.index,view: self)
    }
}

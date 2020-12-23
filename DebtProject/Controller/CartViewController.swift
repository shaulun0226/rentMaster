//
//  CartViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/23.
//

import UIKit

class CartViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    var cartProducts = [ProductModel]()
    
    @IBOutlet weak var cartTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as? CartTableViewCell {
            cell.backgroundColor = UIColor(named: "card")
            cell.index = indexPath.row
            cell.configure(with:cartProducts[indexPath.row])
            cell.cartTableViewCellDelegate = self
            //            cell.layer.insertSublayer(layer, at: 0)
            return cell;
        }
        return UITableViewCell()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension CartViewController:UIPopoverPresentationControllerDelegate{
    //IOS會自動偵測是iphone還是ipad，如果是iphone的話預設popover會是全螢幕，加上這個func以後會把預設的關閉，照我們寫的視窗大小彈出
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
extension CartViewController:CartTableViewCellDelegate{
    func menuOnClick(index:Int) {
        let storyboard = UIStoryboard(name: Storyboard.product.rawValue, bundle: nil)
        //找到popoverview的class
        if let popoverController = storyboard.instantiateViewController(withIdentifier: ProductStoryboardController.cartCellMenuViewController.rawValue) as? CartCellMenuViewController {
            //設定刪除鍵點擊事件
            popoverController.index = index
            popoverController.cartCellMenuViewDelegate = self
            //設定popoverview backgroundColor
            let layer = Global.setBackgroundColor(view);
            popoverController.view.layer.insertSublayer(layer, at: 0)
            //設定以 popover 的效果跳轉
            popoverController.modalPresentationStyle = .popover
            //設定popover的來源視圖
            popoverController.popoverPresentationController?.sourceView = self.view
            //下面註解掉的這行可以指定箭頭指的座標
            let indexpath = IndexPath(item: index, section: 0)
            if let cell = cartTableView.cellForRow(at: indexpath) as? CartTableViewCell{
                popoverController.popoverPresentationController?.sourceRect = cell.btnMenu.bounds
            }
            popoverController.popoverPresentationController?.delegate = self
            //讓 popover 的箭頭指到 rightBarButtonItem。並且方向向上
            popoverController.popoverPresentationController?.permittedArrowDirections = .up
            //設定popover視窗大小
            popoverController.preferredContentSize = CGSize(width: 250, height: 250)
            //跳轉頁面
            present(popoverController, animated: true, completion: nil)
        }
    }
}
extension CartViewController:CartCellMenuViewDelegate{
    func deleteClick(index: Int,view:UIViewController) {
        view.dismiss(animated: true) {
            self.cartProducts.remove(at: index)
            self.cartTableView.reloadData()
        }
    }
    
    
}

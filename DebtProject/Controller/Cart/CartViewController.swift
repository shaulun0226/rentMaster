//
//  CartViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/23.
//

import UIKit
import SwiftyJSON

class CartViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var cartProducts = [ProductModel]()
//    var isGotItems = false
    @IBOutlet weak var lbHint: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.isGotItems = false
        cartTableView.delegate = self
        cartTableView.dataSource = self
        lbHint.isHidden = !User.token.isEmpty
        if(!User.token.isEmpty){
            NetworkController.instance().getCartList{
                [weak self] (reponseJSON,isSuccess) in
                guard let weakSelf = self else{return}
                if(isSuccess){
                    let jsonItemArr = JSON(reponseJSON)
                    print("購物車解析清單\(jsonItemArr)")
                    weakSelf.parseProduct(jsonArr: jsonItemArr)
                    weakSelf.cartTableView.reloadData()
                }else{
                    print("購物車清單取得失敗")
                }
            }
        }
    }
    private func parseProduct(jsonArr:JSON){
        for index in 0..<jsonArr.count{
            let id = jsonArr[index]["id"].string!
            let title = jsonArr[index]["title"].string!
            let description = jsonArr[index]["description"].string!
            let isSale = jsonArr[index]["isSale"].bool!
            let isRent = jsonArr[index]["isRent"].bool!
            let isExchange = jsonArr[index]["isExchange"].bool!
            let address = jsonArr[index]["address"].string ?? ""
            let deposit = jsonArr[index]["deposit"].int!
            let rent = jsonArr[index]["rent"].int!
            let salePrice = jsonArr[index]["salePrice"].int!
            let rentMethod = jsonArr[index]["rentMethod"].string!
            let amount = jsonArr[index]["amount"].int!
            let type = jsonArr[index]["type"].string!
            let type1 = jsonArr[index]["type1"].string!
            let type2 = jsonArr[index]["type2"].string!
            let userId = jsonArr[index]["userId"].string!
            let picsArr = jsonArr[index]["pics"].array!
            let weightPrice = jsonArr[index]["weightPrice"].float!
            
            var pics = [PicModel]()
            for index in 0..<picsArr.count{
                let id  = picsArr[index]["id"].string ?? ""
                let path  = picsArr[index]["path"].string ?? ""
                let productId  = picsArr[index]["productId"].string ?? ""
                pics.append(PicModel.init(id: id, path: path, productId: productId))
            }
            self.cartProducts.append(ProductModel.init(id: id, title: title, description: description, isSale: isSale, isRent: isRent, isExchange: isExchange, deposit: deposit, rent: rent, salePrice: salePrice, address: address, rentMethod: rentMethod, amount: amount, type: type, type1: type1, type2: type2, userId: userId, pics: pics, weightPrice: weightPrice))
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let infoView = Global.productStoryboard.instantiateViewController(withIdentifier: ProductStoryboardController.productInfoViewController.rawValue) as? ProductInfoViewController{
            infoView.product = cartProducts[indexPath.row]
            self.show(infoView, sender: nil)
        }
    }
    //側滑刪除
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                    indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            print("id:\(self.cartProducts[indexPath.row].id)")
            let deleteAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
                NetworkController.instance().deleteCartItem(id: self.cartProducts[indexPath.row].id){
                    [weak self] (reponseValue,isSuccess) in
                    guard let  weakSelf = self else{return}
                    if(isSuccess){
                        weakSelf.cartProducts.remove(at: indexPath.row)
                        weakSelf.cartTableView.reloadData()
                        print(reponseValue)
                    }
                }
                // 需要返回true，不然會没有反應
                completionHandler(true)
            }
            deleteAction.backgroundColor = .red
            deleteAction.image = UIImage(systemName: "trash")
            let config = UISwipeActionsConfiguration(actions: [deleteAction])
            
            // 取消拉長後自動執行
            config.performsFirstActionWithFullSwipe = false
            
            return config
    }
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
            //            let layer = Global.setBackgroundColor(view);
            //            popoverController.view.layer.insertSublayer(layer, at: 0)
            //設定以 popover 的效果跳轉
            popoverController.modalPresentationStyle = .popover
            //設定indexpath
            let indexpath = IndexPath(item: index, section: 0)
            //設定popover的來源視圖
            popoverController.popoverPresentationController?.sourceView = cartTableView.cellForRow(at: indexpath)
            //下面註解掉的這行可以指定箭頭指的座標
            if let cell = cartTableView.cellForRow(at: indexpath) as? CartTableViewCell{
                print("設定位置")
                popoverController.popoverPresentationController?.sourceView = cell.btnMenu
                popoverController.popoverPresentationController?.sourceRect = cell.btnMenu.bounds
            }
            popoverController.popoverPresentationController?.delegate = self
            //讓 popover 的箭頭指到 rightBarButtonItem。並且方向向上
            popoverController.popoverPresentationController?.permittedArrowDirections = .right
            //設定popover視窗大小
            popoverController.preferredContentSize = CGSize(width: 250, height: 50)
            //跳轉頁面
            present(popoverController, animated: true, completion: nil)
        }
    }
}
extension CartViewController:CartCellMenuViewDelegate{
    func deleteClick(index: Int,view:UIViewController) {
        view.dismiss(animated: true) {
            NetworkController.instance().deleteCartItem(id: self.cartProducts[index].id){
                [weak self] (reponseValue,isSuccess) in
                guard let weakSelf  = self else{return}
                weakSelf.cartProducts.remove(at: index)
                weakSelf.cartTableView.reloadData()
            }
        }
    }
    
    
}

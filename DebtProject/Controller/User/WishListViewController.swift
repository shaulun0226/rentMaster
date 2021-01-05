//
//  WantListViewController.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/4.
//

import UIKit
import SwiftyJSON

class WishListViewController: BaseViewController {
    // 願望清單
    @IBOutlet weak var tfWishProductName: UnderLineTextField!
    @IBOutlet weak var tfWishProductAmount: UnderLineTextField!
    @IBOutlet weak var tfWishProductWeightPrice: UnderLineTextField!
    @IBOutlet weak var wishListTV: UITableView!
    @IBOutlet weak var wantExchangeListTVHeight: NSLayoutConstraint!
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        wishListTV.layer.removeAllAnimations()
        wantExchangeListTVHeight.constant = wishListTV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    //    var newCellCount = 0
    var wishList = [WishItemModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定KVO
        wishListTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        NetworkController.instance().getWishItemAll{
            [weak self] (reponseValue,isSuccess) in
            guard let weakSelf = self else{return}
            if(isSuccess){
                let jsonArr = JSON(reponseValue)
                print("\(jsonArr.count)")
                weakSelf.parseWishItem(jsonArr: jsonArr)
                weakSelf.wishListTV.reloadData()
            }
        }
        //        wishList = [WishListModel.init(id: "2131", userId: "324234", productName: "動物森友會", amount: 2, weightPrice: 1.5),WishListModel.init(id: "2131", userId: "324234", productName: "動物森友會", amount: 2, weightPrice: 1.5),WishListModel.init(id: "2131", userId: "324234", productName: "動物森友會", amount: 2, weightPrice: 1.5),WishListModel.init(id: "2131", userId: "324234", productName: "動物森友會", amount: 2, weightPrice: 1.5),WishListModel.init(id: "2131", userId: "324234", productName: "動物森友會", amount: 2, weightPrice: 1.5)]
        wishListTV.delegate = self
        wishListTV.dataSource = self
        
        
    }
    private func parseWishItem(jsonArr:JSON){
        for index in 0..<jsonArr.count{
            let id = jsonArr[index]["id"].string!
            let userId = jsonArr[index]["userId"].string ?? ""
            let wishProductName = jsonArr[index]["exchangeItem"].string ?? ""
            let wishProductAmount = jsonArr[index]["requestQuantity"].int ?? 0
            let wishProductWeightPrice = jsonArr[index]["weightPoint"].float ?? 99.0
            print("\(id)\(userId)\(wishProductName)\(wishProductAmount)\(wishProductWeightPrice)")
            wishList.append(WishItemModel.init(id: id, userId: userId, productName: wishProductName, amount: wishProductAmount, weightPrice: wishProductWeightPrice))
        }
    }
    private func emptyCheck()->Bool{
        if(tfWishProductName.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfWishProductAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfWishProductWeightPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ){
            return false
        }
        return true
    }
    @IBAction func btnAddCellClick(_ sender: Any) {
        if(!emptyCheck()){
            return
        }
        let wishProductName = tfWishProductName.text!
        let wishProductAmount = Int(tfWishProductAmount.text!)!
        let wishProductWeightPrice = Float(tfWishProductWeightPrice.text!)!
        NetworkController.instance().addWishItem(wishProductName: wishProductName, wishProductAmount: wishProductAmount, wishProductWeightPrice: wishProductWeightPrice){
            [weak self] (reponseValue,isSuccess) in
            guard let weakSelf = self else{return}
            if(isSuccess){
                weakSelf.wishList.append(WishItemModel.init(id: reponseValue, userId: "", productName: wishProductName, amount: wishProductAmount, weightPrice: wishProductWeightPrice))
                weakSelf.wishListTV.reloadData()
                weakSelf.tfWishProductName.text = ""
                weakSelf.tfWishProductAmount.text = ""
                weakSelf.tfWishProductWeightPrice.text = ""
            }
        }
    }
}
extension WishListViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = wishListTV.dequeueReusableCell(withIdentifier: "WishListTableViewCell") as? WishListTableViewCell {
            print("創造cell位置\(indexPath.row)")
            cell.configure(wishListModel:wishList[indexPath.row])
            cell.lbNumber.text = "\(indexPath.row+1):"
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選到後馬上解除選取
        wishListTV.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            NetworkController.instance().deleteWishItem(id: self.wishList[indexPath.row].id){
                [weak self] (reponseValue,isSuccess) in
                guard let  weakSelf = self else{return}
                if(isSuccess){
                    weakSelf.wishList.remove(at: indexPath.row)
                    weakSelf.wishListTV.reloadData()
                    print(reponseValue)
                }
            }
            // 需要返回true，否则没有反应
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
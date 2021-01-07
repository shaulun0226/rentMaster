//
//  MainPageViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/16.
//

import UIKit
import SwiftyJSON

class MainPageViewController: BaseSideMenuViewController {
    let userDefault = UserDefaults()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PageTableViewCell", bundle: nil), forCellReuseIdentifier: "PageTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let account = userDefault.value(forKey: "Account") as? String else{return}
        guard let password = userDefault.value(forKey: "Password") as? String else{return}
        if(account.isEmpty||password.isEmpty){
            return
        }
        if(Global.isOnline && User.token.isEmpty){
            NetworkController.instance().login(email: account, password: password) {
                // [weak self]表此類為弱連結(結束後會自動釋放)，(isSuccess)自訂方法時會帶進來的 bool 參數（此寫法可不用帶兩個閉包進去
                (value,isSuccess)  in
                if(isSuccess){
                    User.token = value as? String ?? ""
                    if(!User.token.isEmpty){
                        print("登入成功")
                    }
                }else{
                    print("登入失敗")
                }
            }
        }
    }
    private func parseProduct(cell:PageTableViewCell,jsonArr:JSON){
        print(jsonArr)
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
            let weightPrice = jsonArr[index]["weightPrice"].float ?? 2.0
            var pics = [PicModel]()
            for index in 0..<picsArr.count{
                let id  = picsArr[index]["id"].string ?? ""
                let path  = picsArr[index]["path"].string ?? ""
                let productId  = picsArr[index]["productId"].string ?? ""
                pics.append(PicModel.init(id: id, path: path, productId: productId))
            }
            
            cell.products.append(ProductModel.init(id: id, title: title, description: description, isSale: isSale, isRent: isRent, isExchange: isExchange, deposit: deposit, rent: rent, salePrice: salePrice, address: address, rentMethod: rentMethod, amount: amount, type: type, type1: type1, type2: type2, userId: userId, pics: pics,weightPrice: weightPrice))
        }
    }
}
extension MainPageViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PageTableViewCell",for: indexPath) as? PageTableViewCell {
            switch indexPath.row {
            case 0:
                cell.lbMainPageTitle.text = "PlayStation最新資訊"
                //設定label的手勢
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleTapPS))
                cell.lbMainPageHint.addGestureRecognizer(gestureRecognizer)
                if(Global.isOnline){
                    NetworkController.instance().getProductListByType(type: "PlayStation"  ,pageBegin: Global.pageBegin, pageEnd: Global.pageEnd) {
                        [weak self](value, isSuccess) in
                        guard let weakSelf = self else {return}
                        if(isSuccess){
                            let jsonArr = JSON(value)
                            print(jsonArr.type)
                            cell.products.removeAll()
                            weakSelf.parseProduct(cell:cell,jsonArr: jsonArr)
                            cell.pageCollectionView.reloadData()
                        }else{
                            cell.products = ProductModel.defaultAllList
                        }
                    }
                }else{
                }
            case 1:
                cell.lbMainPageTitle.text = "Xbox最新資訊"
                //設定label的手勢
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleTapXbox(gestureRecognizer:)))
                cell.lbMainPageHint.addGestureRecognizer(gestureRecognizer)
                if(Global.isOnline){
                    NetworkController.instance().getProductListByType(type: "Xbox"  ,pageBegin: Global.pageBegin, pageEnd: Global.pageEnd) {
                        [weak self](value, isSuccess) in
                        guard let weakSelf = self else {return}
                        if(isSuccess){
                            let jsonArr = JSON(value)
                            print(jsonArr.type)
                            
                            cell.products.removeAll()
                            weakSelf.parseProduct(cell:cell,jsonArr: jsonArr)
                            cell.pageCollectionView.reloadData()
                        }else{
                            cell.products = ProductModel.defaultAllList
                        }
                    }
                }else{
                }
            case 2:
                cell.lbMainPageTitle.text = "任天堂最新資訊"
                //設定label的手勢
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleTapSwitch(gestureRecognizer:)))
                cell.lbMainPageHint.addGestureRecognizer(gestureRecognizer)
                if(Global.isOnline){
                    NetworkController.instance().getProductListByType(type: "Switch",pageBegin: Global.pageBegin, pageEnd: Global.pageEnd) {
                        [weak self](value, isSuccess) in
                        guard let weakSelf = self else {return}
                        if(isSuccess){
                            let jsonArr = JSON(value)
                            print(jsonArr.type)
                            cell.products.removeAll()
                            weakSelf.parseProduct(cell:cell,jsonArr: jsonArr)
                            cell.pageCollectionView.reloadData()
                        }else{
                            cell.products = ProductModel.defaultAllList
                        }
                    }
                }else{
                }
            case 3:
                cell.lbMainPageTitle.text = "桌遊最新資訊"
                //設定label的手勢
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleTapBoardgame(gestureRecognizer:)))
                cell.lbMainPageHint.addGestureRecognizer(gestureRecognizer)
                if(Global.isOnline){
                    NetworkController.instance().getProductListByType(type: "BoardGame"  ,pageBegin: Global.pageBegin, pageEnd: Global.pageEnd) {
                        [weak self](value, isSuccess) in
                        guard let weakSelf = self else {return}
                        if(isSuccess){
                            let jsonArr = JSON(value)
                            print(jsonArr.type)
                            cell.products.removeAll()
                            weakSelf.parseProduct(cell:cell,jsonArr: jsonArr)
                            cell.pageCollectionView.reloadData()
                        }else{
                            cell.products = ProductModel.defaultAllList
                        }
                    }
                }else{
                }
            default:
                cell.lbMainPageTitle.text = ""
            }
            cell.selectionStyle = .none//被選取時不會反白
            cell.lbMainPageHint.text = "查看更多 >"
            cell.tableViewCellDelegate = self
            //設定cell內容
            return cell;
        }
        return UITableViewCell()
    }
    //設定點擊查看更多會發生的事件
    @objc func handleTapPS(gestureRecognizer: UIGestureRecognizer) {
        //設定跳轉
        if let vcMain = Global.productStoryboard.instantiateViewController(identifier: "ProductListView") as?  ProductListController{
            vcMain.title = "PlayStation"
            vcMain.isMyStore = false
            vcMain.slider.backgroundColor = .blue
            vcMain.productType1 = "PS5"//暫定
            vcMain.tabbarTitle = ["所有","遊戲","主機","周邊","其他"]
            self.show(vcMain, sender: nil);
        }
    }
    @objc func handleTapXbox(gestureRecognizer: UIGestureRecognizer) {
        //設定跳轉
        if let vcMain = Global.productStoryboard.instantiateViewController(identifier: "ProductListView") as?  ProductListController{
            vcMain.title = "Xbox"
            vcMain.isMyStore = false
            vcMain.productType1 = "XBOX"//暫定
            vcMain.slider.backgroundColor = .green
            vcMain.tabbarTitle = ["所有","遊戲","主機","周邊","其他"]
            self.show(vcMain, sender: nil);
        }
    }
    @objc func handleTapSwitch(gestureRecognizer: UIGestureRecognizer) {
        //設定跳轉
        if let vcMain = Global.productStoryboard.instantiateViewController(identifier: "ProductListView") as?  ProductListController{
            vcMain.title = "Switch"
            vcMain.isMyStore = false
            vcMain.productType1 = "SWITCH"//暫定
            vcMain.tabbarTitle = ["所有","遊戲","主機","周邊","其他"]
            vcMain.slider.backgroundColor = .red
            self.show(vcMain, sender: nil);
        }
    }
    @objc func handleTapBoardgame(gestureRecognizer: UIGestureRecognizer) {
        //設定跳轉
        if let vcMain = Global.productStoryboard.instantiateViewController(identifier: "ProductListView") as?  ProductListController{
            vcMain.title = "桌遊"
            vcMain.isMyStore = false
            vcMain.productType1 = "桌遊"//暫定
            vcMain.tabbarTitle = ["所有","遊戲","主機","周邊","其他"]
            vcMain.slider.backgroundColor = .orange
            self.show(vcMain, sender: nil);
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
extension MainPageViewController:PageTableViewCellDelegate{
    func cellClick(indexPath: IndexPath, products: [ProductModel]) {
        let productModel = products[indexPath.row]
        if let productInfoView = Global.productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productInfoViewController.rawValue) as? ProductInfoViewController{
            productInfoView.product = productModel
            self.show(productInfoView, sender: self)
        }
    }
}

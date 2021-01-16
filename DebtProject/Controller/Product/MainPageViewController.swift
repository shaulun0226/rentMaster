//
//  MainPageViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/16.
//

import UIKit
import SwiftyJSON

class MainPageViewController: BaseSideMenuViewController {
    //    let userDefault = UserDefaults()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定標題大小
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25)]
        navigationController?.navigationBar.largeContentTitle = "租之助"
        tableView.delegate = self
        tableView.dataSource = self
        //去除分隔線
        tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "PageTableViewCell", bundle: nil), forCellReuseIdentifier: "PageTableViewCell")
    }
}
extension MainPageViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PageTableViewCell",for: indexPath) as? PageTableViewCell {
            var type = ""
            switch indexPath.row {
            case 0:
                cell.lbMainPageTitle.text = "PlayStation最新資訊"
                //設定label的手勢
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleTapPS))
                cell.lbMainPageHint.addGestureRecognizer(gestureRecognizer)
                type = "PlayStation"
            case 1:
                cell.lbMainPageTitle.text = "Xbox最新資訊"
                type = "Xbox"
                //設定label的手勢
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleTapXbox(gestureRecognizer:)))
                cell.lbMainPageHint.addGestureRecognizer(gestureRecognizer)
                
            case 2:
                cell.lbMainPageTitle.text = "Switch最新資訊"
                type = "Switch"
                //設定label的手勢
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleTapSwitch(gestureRecognizer:)))
                cell.lbMainPageHint.addGestureRecognizer(gestureRecognizer)
            case 3:
                cell.lbMainPageTitle.text = "桌遊最新資訊"
                type = "桌遊"
                //設定label的手勢
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleTapBoardgame(gestureRecognizer:)))
                cell.lbMainPageHint.addGestureRecognizer(gestureRecognizer)
            default:
                cell.lbMainPageTitle.text = ""
            }
            if(Global.isOnline){
                NetworkController.instance().getProductListBy(type: type, type1: "", type2: "", pageBegin: Global.pageBegin, pageEnd: Global.pageEnd){
                    (value, isSuccess) in
                    //                        guard let weakSelf = self else {return}
                    
                    if(isSuccess){
                        cell.products.removeAll()
                        guard let products = value as? [ProductModel] else {return}
                        cell.products = products
                        DispatchQueue.main.async {
                            
                            cell.pageCollectionView.reloadData()
                        }
                    }else{
                        cell.products = ProductModel.defaultAllList
                    }
                }
            }else{
                cell.products = ProductModel.defaultAllList
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
            vcMain.productType = "PlayStation"
            vcMain.tabbarTitle = ["所有","遊戲","主機","周邊","其他"]
            self.show(vcMain, sender: nil);
        }
    }
    @objc func handleTapXbox(gestureRecognizer: UIGestureRecognizer) {
        //設定跳轉
        if let vcMain = Global.productStoryboard.instantiateViewController(identifier: "ProductListView") as?  ProductListController{
            vcMain.title = "Xbox"
            vcMain.isMyStore = false
            vcMain.productType = "Xbox"
            vcMain.tabbarTitle = ["所有","遊戲","主機","周邊","其他"]
            self.show(vcMain, sender: nil);
        }
    }
    @objc func handleTapSwitch(gestureRecognizer: UIGestureRecognizer) {
        //設定跳轉
        if let vcMain = Global.productStoryboard.instantiateViewController(identifier: "ProductListView") as?  ProductListController{
            vcMain.title = "Switch"
            vcMain.productType = "Switch"
            vcMain.isMyStore = false
            //            vcMain.productType1 = "SWITCH"//暫定
            vcMain.tabbarTitle = ["所有","遊戲","主機","周邊","其他"]
            self.show(vcMain, sender: nil);
        }
    }
    @objc func handleTapBoardgame(gestureRecognizer: UIGestureRecognizer) {
        //設定跳轉
        if let vcMain = Global.productStoryboard.instantiateViewController(identifier: "ProductListView") as?  ProductListController{
            vcMain.title = "桌遊"
            vcMain.isMyStore = false
            vcMain.productType = "桌遊"
            vcMain.tabbarTitle = ["所有","策略","友情破壞","技巧","經營","運氣","劇情","TRPG","其他"]
            self.show(vcMain, sender: nil);
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
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

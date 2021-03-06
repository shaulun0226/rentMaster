//
//  MyOrderListViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/29.
//

import UIKit
import SwiftyJSON

class MyBuyerOrderListViewController: BaseSideMenuViewController {
    var orderStatus = ""
    var orders = [OrderModel]()
    var tabbarTitle = [String]()
    var firstTabbarDidLoad = false
    var currentPage = ""
    //collectionview底線
    var slider = UIView()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()
        //設定標題大小
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25)]
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        tabbarTitle = ["已立單","已寄送","已抵達","歸還已寄出","已寄回","歷史記錄"]
//        orders = ProductModel.defaultAllList
        //設定CollectionView Cell大小
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: self.view.frame.size.width/3.5, height:45)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = 0
       
    }
    override func viewWillAppear(_ animated: Bool) {
        orders.removeAll()
        NetworkController.instance().getMyOrderListBuyer(status: self.orderStatus){
            [weak self] (reponseValue,isSuccess) in
            guard let weakSelf = self else{return}
            if(isSuccess){
                guard let orders = reponseValue as?[OrderModel] else { return  }
                weakSelf.orders = orders
                DispatchQueue.main.async {
                    weakSelf.tableview.reloadData()
                }
            }else{
                print("進到我的訂單")
            }
        }
    }
    private func setupSlider(){
        self.slider.frame.size = CGSize(width: self.view.frame.size.width/3.5, height: 3)
        self.slider.center.y = collectionView.bounds.maxY-14
        self.slider.backgroundColor = UIColor(named: "slider")
        collectionView.addSubview(slider)
    }
}
extension MyBuyerOrderListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableview.dequeueReusableCell(withIdentifier: TableViewCell.myOrderListTableViewCell.rawValue,for: indexPath) as? MyOrderListTableViewCell{
            if(indexPath.row>=orders.count){
                return UITableViewCell()
            }
            cell.configure(with: orders[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let orderView = Global.productStoryboard.instantiateViewController(withIdentifier: ProductStoryboardController.orderViewController.rawValue)as? OrderViewController{
            guard indexPath.row < orders.count else {
                return
            }
            orderView.isSeller = false
            orderView.orderOwnerInfo = "賣家資訊"
            orderView.customerId = orders[indexPath.row].p_ownerId
            orderView.order = orders[indexPath.row]
            orderView.notes = orders[indexPath.row].notes
            self.show(orderView, sender: nil)
        }
    }
    
}
extension MyBuyerOrderListViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabbarTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.myOrderListTabBarCell.rawValue, for: indexPath) as? MyOrderListTabBarCell{
            //第一次產生cell時 設定tabbar slider
            if(indexPath.row==0 && !firstTabbarDidLoad ){
                cell.isSelected = true
                firstTabbarDidLoad = true
                UIView.animate(withDuration: 0.4) { [weak self] in
                    if let self = self{
                        self.slider.center.x = cell.center.x
                    }
                }
            }
            cell.lbTitle.text = tabbarTitle[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 先清空
        if let cell = collectionView.cellForItem(at: indexPath) as? MyOrderListTabBarCell{
            //設定點擊背景色變化
            if(indexPath.row != 0){
                if let firstcell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)){
                    if(firstcell.isSelected){
                        firstcell.isSelected = false
                    }
                }
            }
            cell.isSelected = true
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            UIView.animate(withDuration: 0.4) { [weak self] in
                if let self = self{
                    self.slider.center.x = cell.center.x
                }
            }
            guard var orderStatus = cell.lbTitle.text else {
                return
            }
            orders.removeAll()
            if orderStatus.elementsEqual(currentPage){
                return
            }
            print("選取標籤：\(orderStatus)")
            if orderStatus.elementsEqual("歷史記錄"){
                orderStatus = "已結單"
            }
            currentPage = orderStatus
            NetworkController.instance().getMyOrderListBuyer(status: orderStatus){
                [weak self] (reponseValue,isSuccess) in
                guard let weakSelf = self else{return}
                if(isSuccess){
                    guard let orders = reponseValue as?[OrderModel] else { return  }
                    weakSelf.orders = orders
                    DispatchQueue.main.async {
                        weakSelf.tableview.reloadData()
                    }
                }else{
                    print("進到我的訂單")
                    DispatchQueue.main.async {
                        weakSelf.tableview.reloadData()
                    }
                }
            }
        }
    }
}


//
//  MyOrderListViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/29.
//

import UIKit
import SwiftyJSON

class MyBuyerOrderListViewController: BaseViewController {
    var orderStatus = ""
    var orders = [OrderModel]()
    var tabbarTitle = [String]()
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
        collectionView.delegate = self
        collectionView.dataSource = self
        tabbarTitle = ["已立單","已寄送","歷史紀錄"]
//        orders = ProductModel.defaultAllList
        //設定CollectionView Cell大小
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: self.view.frame.size.width/3, height:50)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = 1
       
    }
    override func viewWillAppear(_ animated: Bool) {
        orders.removeAll()
        NetworkController.instance().getMyOrderListBuyer(status: self.orderStatus){
            [weak self] (reponseValue,isSuccess) in
            guard let weakSelf = self else{return}
            if(isSuccess){
                let jsonArr = JSON(reponseValue)
                weakSelf.parseOrder(jsonArr: jsonArr)
                DispatchQueue.main.async {
                    weakSelf.collectionView.reloadData()
                    weakSelf.tableview.reloadData()
                }
            }else{
                print("進到我的訂單")
            }
        }
    }
    private func setupSlider(){
        self.slider.frame.size = CGSize(width: 90, height: 5)
        self.slider.center.y = collectionView.bounds.maxY-10
        self.slider.backgroundColor = .purple
        collectionView.addSubview(slider)
    }
    private func parseOrder(jsonArr:JSON){
        for index in 0..<jsonArr.count{
            let id = jsonArr[index]["id"].string ?? ""
            let p_Title = jsonArr[index]["p_Title"].string ?? ""
            let p_Desc = jsonArr[index]["p_Desc"].string ?? ""
            let p_Address = jsonArr[index]["p_Address"].string ?? ""
            let p_isSale = jsonArr[index]["p_isSale"].bool ?? false
            let p_isRent = jsonArr[index]["p_isRent"].bool ?? false
            let p_isExchange = jsonArr[index]["p_isExchange"].bool ?? false
            let p_Deposit = jsonArr[index]["p_Deposit"].int ?? 0
            let p_Rent = jsonArr[index]["p_Rent"].int ?? 0
            let p_salePrice = jsonArr[index]["p_salePrice"].int ?? 0
            let p_RentMethod = jsonArr[index]["p_RentMethod"].string ?? ""
            let p_Type = jsonArr[index]["p_Type"].string ?? ""
            let p_Type1 = jsonArr[index]["p_Type1"].string ?? ""
            let p_Type2 = jsonArr[index]["p_Type2"].string ?? ""
            let p_ownerId = jsonArr[index]["p_ownerId"].string ?? ""
            let p_weightPrice = jsonArr[index]["p_WeightPrice"].float ?? 0.0
            let tradeMethod = jsonArr[index]["tradeMethod"].int!
            let picsArr = jsonArr[index]["pics"].array ?? []
            let orderExchangeItemsArr = jsonArr[index]["orderExchangeItems"].array ?? []
            let tradeQuantity = jsonArr[index]["tradeQuantity"].int!
            let status = jsonArr[index]["status"].string ?? ""
            let orderTime = jsonArr[index]["orderTime"].string ?? ""
            let payTime = jsonArr[index]["payTime"].string ?? ""
            
            let productSend = jsonArr[index]["productSend"].object
            let productArrive = jsonArr[index]["productArrive"].string ?? ""
            let productSendBack = jsonArr[index]["productSendBack"].string ?? ""
            let productGetBack = jsonArr[index]["productGetBack"].string ?? ""
            let productId = jsonArr[index]["productId"].string ?? ""
            let lender = jsonArr[index]["lender"].string ?? ""
            
            let notesArr = jsonArr[index]["notes"].array ?? []
            var pics = [PicModel]()
            for index in 0..<picsArr.count{
                let id = picsArr[index]["id"].string ?? ""
                let path = picsArr[index]["path"].string ?? ""
                let productId = picsArr[index]["productId"].string ?? ""
                pics.append(PicModel.init(id: id, path: path, productId: productId))
            }
            var orderExchangeItems = [ExchangeModel]()
            for index in 0..<orderExchangeItemsArr.count{
                let id  = orderExchangeItemsArr[index]["id"].string ?? ""
                let orderId  = orderExchangeItemsArr[index]["orderId"].string ?? ""
                let wishItemId  = orderExchangeItemsArr[index]["wishItemId"].string ?? ""
                let exchangeItem  = orderExchangeItemsArr[index]["exchangeItem"].string ?? ""
                let packageQuantity  = orderExchangeItemsArr[index]["packageQuantity"].int ?? 0
                orderExchangeItems.append(ExchangeModel.init(id: id, orderId: orderId, wishItemId: wishItemId, exchangeItem: exchangeItem, packageQuantity: packageQuantity))
            }
            var notes = [NoteModel]()
            for index in 0..<notesArr.count{
                let id  = notesArr[index]["id"].string ?? ""
                let orderId  = notesArr[index]["orderId"].string ?? ""
                let senderId  = notesArr[index]["senderId"].string ?? ""
                let senderName  = notesArr[index]["senderName"].string ?? ""
                let message  = notesArr[index]["message"].string ?? ""
                let createTime  = notesArr[index]["createTime"].string ?? ""
                notes.append(NoteModel.init(id: id, orderId: orderId, senderId: senderId, senderName: senderName, message: message, createTime: createTime))
            }
            self.orders.append(OrderModel.init(id: id, p_Title: p_Title, p_Desc: p_Desc, p_Address: p_Address, p_isSale: p_isSale, p_isRent: p_isRent, p_isExchange: p_isExchange, p_Deposit: p_Deposit, p_Rent: p_Rent, p_salePrice: p_salePrice, p_RentMethod: p_RentMethod, p_Type: p_Type, p_Type1: p_Type1, p_Type2: p_Type2, p_ownerId: p_ownerId, p_weightPrice: p_weightPrice,pics:pics, tradeMethod: tradeMethod, orderExchangeItems: orderExchangeItems, tradeQuantity: tradeQuantity, status: status, orderTime: orderTime, payTime: payTime, productSend: productSend, productArrive: productArrive, productSendBack: productSendBack, productGetBack: productGetBack, productId: productId, lender: lender, notes: notes))
        }
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
            cell.backgroundColor = UIColor(named: "card")
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
            if(indexPath.row == 0){
                cell.isSelected = true
            }else{
                cell.isSelected = false
            }
            cell.backgroundColor = UIColor(named: "card")
            cell.lbTitle.text = tabbarTitle[indexPath.row]
            cell.lbTitle.textColor = .white
            //        cell.layer.insertSublayer(layer, at: 0)
            if(indexPath.row==0){
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                UIView.animate(withDuration: 0.4) { [weak self] in
                    if let self = self{
                        self.slider.center.x = cell.center.x
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        self.title = buttonText[indexPath.row]
        // 先清空
        if let cell = collectionView.cellForItem(at: indexPath) as? MyOrderListTabBarCell{
            //設定點擊背景色變化
            if(indexPath.row != 0){
                if let firstcell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)){
                    if(firstcell.isSelected){
                        firstcell.isSelected = false
                        firstcell.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
                    }
                }
            }
            cell.isSelected = true
            cell.backgroundColor = UIColor(named: "card")
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            UIView.animate(withDuration: 0.4) { [weak self] in
                if let self = self{
                    self.slider.center.x = cell.center.x
                }
            }
            guard let orderStatus = cell.lbTitle.text else {
                return
            }
            orders.removeAll()
            print("選取標籤：\(orderStatus)")
            NetworkController.instance().getMyOrderListBuyer(status: orderStatus){
                [weak self] (reponseValue,isSuccess) in
                guard let weakSelf = self else{return}
                if(isSuccess){
                    let jsonArr = JSON(reponseValue)
                    weakSelf.parseOrder(jsonArr: jsonArr)
                    DispatchQueue.main.async {
                        weakSelf.collectionView.reloadData()
                        weakSelf.tableview.reloadData()
                    }
                }else{
                    print("進到我的訂單")
                }
            }
        }
    }
}


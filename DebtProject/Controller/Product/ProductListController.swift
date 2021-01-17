//
//  MainViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/3.
//

import UIKit
import SwiftyJSON
import SwiftAlertView


class ProductListController: BaseSideMenuViewController{
    @IBOutlet weak var collectview: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnAdd:UIButton!
    var isMyStore = true
    var platform:String!
    var layer:CAGradientLayer!
    //tabbar
    var tabbarCount = 0
    var firstTabbarDidLoad = false
    var tabbarTitle = [String]()
    var products = [ProductModel]()
    //searchbar
    var searchProducts = [ProductModel]()
    var searchOrders = [OrderModel]()
    open var searchController: UISearchController? //建立searchController
    //    var searchResultController = UITableViewController()
    //建立一個搜尋結果controller
    open var hidesSearchBarWhenScrolling: Bool = true
    //collectionview底線
    var slider = UIView()
    var productType:String = ""
    var productType1:String = ""
    var productType2:String = ""
    var currentType2 = ""
    //order
    var isOrder = false
    var orderSelectStatus = ""
    var currentOrderSelectStatus = ""
    var orders = [OrderModel]()
    
    //searchbar
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定collectionView  cell大小
        setCollectionViewCell()
        //設定collectionView 滑桿
        setupSlider()
        //        setupSearchBar()
        //設定標題大小
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25)]
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        //        tableview.register(MyOrderListTableViewCell.self, forCellReuseIdentifier: TableViewCell.myOrderListTableViewCell.rawValue)
        tableview.backgroundView?.backgroundColor = .clear
        //        tableview.bounces = false
        collectview.delegate = self
        collectview.dataSource = self
        if(isMyStore){
            tabbarTitle = ["上架中","未上架","已立單","已寄送","已抵達","歸還已寄出","歷史記錄"]
        }else{
            if(productType1.elementsEqual("")){
                print("prodectType1為空字串")
                return
            }
            if(productType1.elementsEqual("4人以下") || productType1.elementsEqual("4-8人") ||
                productType1.elementsEqual("8人以上")){
                tabbarTitle = ["所有","策略","友情破壞","技巧","經營","運氣","劇情","TRPG","其他"]
            }else{
                tabbarTitle = ["所有","遊戲","主機","周邊","其他"]
            }
        }
        
        //設定按鈕
        (isMyStore) ?(btnAdd.isHidden = false):(btnAdd.isHidden = true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.products.removeAll()
        self.orders.removeAll()
        
        if(isMyStore){
            //            tabbarTitle = ["上架中","未上架","已立單","已寄送","出租中","未出貨"]
            if(Global.isOnline){
                if(isOrder){
                    NetworkController.instance().getMyOrderListSeller(status: self.orderSelectStatus){
                        [weak self](responseValue, isSuccess) in
                        guard let weakSelf = self else {return}
                        if(isSuccess){
                            guard let orders = responseValue as? [OrderModel] else { return  }
                            weakSelf.orders = orders
                            weakSelf.isOrder = true
                            DispatchQueue.main.async {
                                weakSelf.tableview.reloadData()
                            }
                        }else{
                            print("進賣出訂單API失敗")
                            //                            weakSelf.products = ProductModel.defaultHostLists
                        }
                    }
                }else{
                    NetworkController.instance().getMyOwnItemOnShelf{ [weak self](value, isSuccess) in
                        guard let weakSelf = self else {return}
                        if(isSuccess){
//                            let jsonArr = JSON(value)
//                            print("解析\(jsonArr)")
//                            weakSelf.parseProduct(jsonArr: jsonArr)
                            guard let products = value as? [ProductModel] else { return  }
                            weakSelf.products = products
                            DispatchQueue.main.async {
                                weakSelf.tableview.reloadData()
                            }
                        }else{
                            //                            weakSelf.products = ProductModel.defaultGameLists
                        }
                    }
                }
            }else{
                //                self.products = ProductModel.defaultAllList
            }
        }else{//不是我的賣場就call list的API
            NetworkController.instance().getProductListBy(type: productType,type1: productType1,type2: productType2, pageBegin: Global.pageBegin, pageEnd: Global.pageEnd){
                [weak self](value, isSuccess) in
                guard let weakSelf = self else {return}
                if(isSuccess){
                    DispatchQueue.main.async {
                        guard let products = value as? [ProductModel] else {return}
                        weakSelf.products = products
                        weakSelf.tableview.reloadData()
                    }
                    
                }else{
                    print("失敗")
                    DispatchQueue.main.async {
                        weakSelf.products = ProductModel.defaultAllList
                        weakSelf.tableview.reloadData()
                    }
                }
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        if let cell = collectview.cellForItem(at: IndexPath(row: tabbarCount, section: 0))as? TabBarCell {
        //            cell.isSelected = true
        //        }
        print("type:\(productType)\ntype1:\(productType1)\ntype2:\(productType2)")
    }
    private func setCollectionViewCell(){
        let flowLayout = collectview.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = 0
        if(isMyStore){
            flowLayout?.itemSize = CGSize(width: self.view.frame.width/3.5, height: 45)
        }else{
            flowLayout?.itemSize = CGSize(width: self.view.frame.width/3.5, height: 45)
        }
    }
    private func setupSlider(){
        self.slider.frame.size = CGSize(width: self.view.frame.width/3.5, height: 3)
        self.slider.center.y = collectview.bounds.maxY-14
        self.slider.backgroundColor = UIColor(named: "slider")
        collectview.addSubview(slider)
        //        collectionView(collectview, didSelectItemAt:[0,0])
    }
    //searchbar先註解
//    private func setupSearchBar(){
//        //searchbar
//
//        navigationController?.navigationBar.prefersLargeTitles = false
//        searchController = UISearchController(searchResultsController: nil)
////        searchController?.searchResultsUpdater = self
//        searchController?.searchBar.placeholder = "請輸入關鍵字"
////        searchController?.searchBar.delegate = self
//        searchController?.searchBar.searchTextField.delegate = self
//        searchController?.searchBar.barTintColor = UIColor(named: "Card-2")
//        searchController?.searchBar.tintColor = UIColor(named: "Button")
//        //searvhbar輸入文字顏色
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        // 找到Text field in search bar.
//        let textField = searchController?.searchBar.value(forKey: "searchField") as! UITextField
//        // 找到放大鏡
//        let glassIconView = textField.leftView as! UIImageView
//        glassIconView.image = glassIconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//        //設定放大鏡顏色
//        glassIconView.tintColor = UIColor(named: "Button")
//        //找到叉叉按鈕
//        let clearButton = textField.value(forKey: "clearButton") as! UIButton
//        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
//        //設定叉叉顏色
//        clearButton.tintColor = UIColor(named: "Button")
//        //在編輯時會跑出叉叉的位置顯示一個可以按的button，只要一開始編輯就會換成叉叉
//        //            searchController?.searchBar.showsSearchResultsButton = true
//        //        searchController?.dimsBackgroundDuringPresentation = false //ios12被丟掉的方法
//        definesPresentationContext = true
//        tableview.tableHeaderView = searchController?.searchBar
//        //        tableview.tableHeaderView?.backgroundColor = .clear
//        //        tableview.backgroundColor = .clear
//        tableview.backgroundView = UIView()
//        tableview.backgroundView?.backgroundColor = .clear
//    }
    @IBAction func addProductClick(){
        if let vcMain = self.storyboard?.instantiateViewController(identifier: "AddProductViewController") as? AddProductViewController{
            vcMain.isModifyType = false
            self.show(vcMain, sender: nil);
        }
    }
}
extension ProductListController :UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabbarTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarCell", for: indexPath) as? TabBarCell{
            cell.lbTitle.text = tabbarTitle[indexPath.row]
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
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectview.cellForItem(at: indexPath) else { return }
        tabbarCount = indexPath.row
        //設定點擊背景色變化
        if(indexPath.row != 0){
            if let firstcell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)){
                if(firstcell.isSelected){
                    firstcell.isSelected = false
                }
            }
        }
        cell.isSelected = true
        //        cell.backgroundColor = UIColor(named: "card")
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        UIView.animate(withDuration: 0.4) { [weak self] in
            if let self = self{
                self.slider.center.x = cell.center.x
            }
        }
        
        //刪掉所有產品
        products.removeAll()
        //刪掉所有訂單
        orders.removeAll()
        let selectedProductType = tabbarTitle[indexPath.row]
        if !currentOrderSelectStatus.isEmpty && currentOrderSelectStatus.elementsEqual(selectedProductType){
            return
        }
        if(isMyStore){
            switch selectedProductType {
            case "上架中":
                print("進上架中")
                NetworkController.instance().getMyOwnItemOnShelf{
                    [weak self](responseValue, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        DispatchQueue.main.async {
                            guard let products = responseValue as? [ProductModel] else { return  }
                            weakSelf.products = products
                            weakSelf.tableview.reloadData()
                        }
                    }else{
                        weakSelf.products = ProductModel.defaultHostLists
                    }
                    DispatchQueue.main.async {
                        weakSelf.tableview.reloadData()
                    }
                }
                return
            case "未上架":
                NetworkController.instance().getMyOwnItemNotOnShelf{
                    [weak self](responseValue, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        DispatchQueue.main.async {
                            guard let products = responseValue as? [ProductModel] else { return  }
                            weakSelf.products = products
                            weakSelf.isOrder = false
                            weakSelf.tableview.reloadData()
                        }
                    }else{
                        print("沒有商品")
                        weakSelf.products = ProductModel.defaultHostLists
                    }
                    
                }
                return
            case "已立單":
                orderSelectStatus = selectedProductType
                currentOrderSelectStatus = selectedProductType
            case "已寄送":
                orderSelectStatus = selectedProductType
                currentOrderSelectStatus = selectedProductType
            case "已抵達":
                orderSelectStatus = selectedProductType
                currentOrderSelectStatus = selectedProductType
            case"歸還已寄出":
                orderSelectStatus = selectedProductType
                currentOrderSelectStatus = selectedProductType
            case"歷史記錄":
                orderSelectStatus = "已結單"
                currentOrderSelectStatus = "已結單"
            default:
                print("標籤錯誤")
            //                self.products = ProductModel.defaultAllList
            }
            if !(orderSelectStatus.elementsEqual("上架中") || orderSelectStatus.elementsEqual("未上架")){
                NetworkController.instance().getMyOrderListSeller(status: orderSelectStatus){
                    [weak self](responseValue, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        DispatchQueue.main.async {
                            guard let orders = responseValue as? [OrderModel] else { return  }
                            weakSelf.orders = orders
                            weakSelf.isOrder = true
                            weakSelf.tableview.reloadData()
                        }
                    }else{
                        print("進賣出訂單API失敗")
                        //                        weakSelf.products = ProductModel.defaultHostLists
                    }
                    
                }
            }
        }else{
            if(selectedProductType.elementsEqual("所有")&&currentType2.elementsEqual("All")){
                return
            }
            if(currentType2.elementsEqual(selectedProductType)){
                return
            }
            switch selectedProductType {
            case "所有":
                currentType2 = "All"
                productType2 = "All"
            case "主機":
                currentType2 = "主機"
                productType2 = "主機"
            case "周邊":
                currentType2 = "周邊"
                productType2 = "周邊"
            case "遊戲":
                currentType2 = "遊戲"
                productType2 = "遊戲"
            case "其他":
                currentType2 = "其他"
                productType2 = "其他"
            case "策略":
                currentType2 = "策略"
                productType2 = "策略"
            case "友情破壞":
                currentType2 = "友情破壞"
                productType2 = "友情破壞"
            case "技巧":
                currentType2 = "技巧"
                productType2 = "技巧"
            case "經營":
                currentType2 = "經營"
                productType2 = "經營"
            case "運氣":
                currentType2 = "運氣"
                productType2 = "運氣"
            case "劇情":
                currentType2 = "劇情"
                productType2 = "劇情"
            case "TRPG":
                currentType2 = "TRPG"
                productType2 = "TRPG"
                
            default:
                print("標籤錯誤")
            //                products = ProductModel.defaultGameLists
            }
            NetworkController.instance().getProductListBy(type: productType, type1: productType1, type2: productType2, pageBegin: Global.pageBegin, pageEnd: Global.pageEnd){
                [weak self](value, isSuccess) in
                guard let weakSelf = self else {return}
                if(isSuccess){
                    guard let products = value as? [ProductModel] else {return}
                    weakSelf.products = products
                }else{
                    weakSelf.products = ProductModel.defaultAllList
                    print("失敗")
                }
                DispatchQueue.main.async {
                    weakSelf.tableview.reloadData()
                }
            }
        }
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
}
extension ProductListController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isOrder){
            print("訂單數量\(orders.count)")
            return /*((searchController?.isActive)!) ? searchOrders.count :*/ orders.count
        }else{
            return /*((searchController?.isActive)!) ? searchProducts.count : */products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(isMyStore){
            if(isOrder){
                //                if((searchController?.isActive)!){
                //                    guard indexPath.row<searchProducts.count else {
                //                        return UITableViewCell()
                //                    }
                //                }else{
                //                    guard indexPath.row<orders.count else {
                //                        return UITableViewCell()
                //                    }
                //                }
                guard indexPath.row<orders.count else {
                    return UITableViewCell()
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier:TableViewCell.myOrderListTableViewCell.rawValue) as? MyOrderListTableViewCell {
                    //                    ((searchController?.isActive)!)
                    //                        ?cell.configure(with: searchOrders[indexPath.row])
                    //                        :cell.configure(with: orders[indexPath.row])
                    if(indexPath.row>=orders.count){
                        return UITableViewCell()
                    }
                    cell.configure(with: orders[indexPath.row])
                    return cell;
                }
            }else{
                if let cell = tableView.dequeueReusableCell(withIdentifier:TableViewCell.myStoreTableViewCell.rawValue ) as? MyStoreTableViewCell {
                    //                    ((searchController?.isActive)!)
                    //                        ?cell.configure(with: searchProducts[indexPath.row])
                    //                        :cell.configure(with: products[indexPath.row])
                    if(indexPath.row>=products.count){
                        return UITableViewCell()
                    }
                    cell.configure(with: products[indexPath.row])
                    return cell;
                }
            }
        }else{
            //            if((searchController?.isActive)!){
            //                guard indexPath.row<searchProducts.count else {
            //                    return UITableViewCell()
            //                }
            //            }else{
            //                guard indexPath.row<products.count else {
            //                    return UITableViewCell()
            //                }
            //            }
            guard indexPath.row<products.count else {
                return UITableViewCell()
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductModelCell") as? ProductModelCell {
                print("位置\(indexPath.row)\n總數\(self.products.count)")
                //                ((searchController?.isActive)!)
                //                    ?cell.configure(with: searchProducts[indexPath.row])
                //                    :cell.configure(with: products[indexPath.row])
                cell.configure(with: products[indexPath.row])
                return cell;
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isMyStore){
            //跳到編輯頁面
            if(isOrder){
                if let orderView = Global.productStoryboard.instantiateViewController(identifier: ProductStoryboardController.orderViewController.rawValue) as? OrderViewController{
                    guard indexPath.row < orders.count else {
                        return
                    }
                    orderView.isSeller = true
                    orderView.orderOwnerInfo = "買家資訊"
                    orderView.customerId = orders[indexPath.row].lender
                    orderView.order  = orders[indexPath.row]
                    orderView.notes = orders[indexPath.row].notes
                    self.show(orderView, sender: nil)
                }
                return
            }else{
                if let productModifyView = Global.productStoryboard.instantiateViewController(identifier: ProductStoryboardController.addProductViewController.rawValue) as? AddProductViewController{
                    productModifyView.isModifyType = true
                    productModifyView.product = products[indexPath.row]
                    self.show(productModifyView,sender: nil)
                }
            }
        }else{
            if let productInfoView = Global.productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productInfoViewController.rawValue) as? ProductInfoViewController{
                productInfoView.product = products[indexPath.row]
                self.show(productInfoView, sender: nil);
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(isOrder){
            return 110
        }else{
            return 170
        }
        
    }
    //側滑刪除
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                    indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(isMyStore){
            if(isOrder){
                return  UISwipeActionsConfiguration()
            }else{
                print("id:\(self.products[indexPath.row].id)")
                let deleteAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
                    NetworkController.instance().deleteMyOwnItem(id: self.products[indexPath.row].id){
                        [weak self] (reponseValue,isSuccess) in
                        guard let  weakSelf = self else{return}
                        let alertView = SwiftAlertView(title: "", message: "刪除成功！\n", delegate: nil, cancelButtonTitle: "確定")
                        alertView.messageLabel.textColor = UIColor(named: "labelColor")
                        alertView.messageLabel.font = UIFont.systemFont(ofSize: 25)
                        alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
                        alertView.backgroundColor = UIColor(named: "Card-2")
                        alertView.buttonTitleColor = .white
                        alertView.clickedButtonAction = { index in
                            alertView.dismiss()
                        }
                        if(isSuccess){
                            weakSelf.products.remove(at: indexPath.row)
                            alertView.show()
                            DispatchQueue.main.async {
                                weakSelf.tableview.reloadData()
                            }
                            print(reponseValue)
                        }else{
                            alertView.messageLabel.text = "刪除失敗"
                            alertView.show()
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
        return UISwipeActionsConfiguration()
    }
}
//extension ProductListController : UISearchResultsUpdating,UISearchBarDelegate{
//    // 點擊searchBar的搜尋按鈕時
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        products.removeAll()
//        if(isMyStore){
//            if(isOrder){//拿訂單
//                NetworkController.instance().getMyOrderListSeller(status: "All"){ [weak self](value, isSuccess) in
//                    guard let weakSelf = self else {return}
//                    if(isSuccess){
//                        let jsonArr = JSON(value)
//                        weakSelf.parseOrder(jsonArr: jsonArr)
//                    }else{
//                        print("沒訂單")
//                    }
//                }
//            }else{
//                NetworkController.instance().getMyOwnItem{ [weak self](value, isSuccess) in
//                    guard let weakSelf = self else {return}
//                    if(isSuccess){
//                        let jsonArr = JSON(value)
//                        weakSelf.parseProduct(jsonArr: jsonArr)
//                    }else{
//                        //                        weakSelf.products = ProductModel.defaultGameLists
//                    }
//                }
//            }
//        }else{//不是我的賣場就call list的API
//            if(Global.isOnline){
//                if productType1.elementsEqual("") {
//                    print("productType is nil")
//                    return
//                }
//                print("進到getProductListByType1")
//                NetworkController.instance().getProductListByType1(type1: productType1, pageBegin: 1, pageEnd: 10) { [weak self](value, isSuccess) in
//                    guard let weakSelf = self else {return}
//                    if(isSuccess){
//                        let jsonArr = JSON(value)
//                        print("解析\(jsonArr)")
//                        weakSelf.parseProduct(jsonArr: jsonArr)
//                    }else{
//                        print("失敗")
//                        //                        weakSelf.products = ProductModel.defaultGameLists
//                    }
//                }
//            }else{
//                //                self.products = ProductModel.defaultAllList
//            }
//        }
//    }
//    func updateSearchResults(for searchController: UISearchController) {
//
//        if self.searchController?.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
//            return
//        }
//        let searchString = searchController.searchBar.text!
//        if(isOrder){
//            searchOrders = orders.filter { $0.p_Title.lowercased().contains(searchString.lowercased())}
//            orders = searchOrders
//        }else{
//            searchProducts = products.filter { $0.title.lowercased().contains(searchString.lowercased())}
//            products = searchProducts
//        }
//        DispatchQueue.main.async {
//            self.tableview.reloadData()
//        }
//    }
//
//}
extension ProductListController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            return false
        }
        let keyword = textField.text!
        
        print("搜尋")
        NetworkController.instance().getProductListByKeyword(keyword: keyword, type1: productType1, type2: productType2, pageBegin: Global.pageBegin, pageEnd: Global.pageEnd){
            [weak self](value, isSuccess) in
            guard let weakSelf = self else {return}
            if(isSuccess){
                guard let products = value as? [ProductModel] else {return}
                weakSelf.products = products
            }else{
                weakSelf.products = ProductModel.defaultAllList
                print("失敗")
            }
            DispatchQueue.main.async {
                weakSelf.tableview.reloadData()
            }
        }
        return true
    }
}

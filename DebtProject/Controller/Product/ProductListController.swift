//
//  MainViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/3.
//

import UIKit
import SwiftyJSON



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
    var orders = [OrderModel]()
    
    //searchbar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定collectionView  cell大小
        setCollectionViewCell()
        //設定collectionView 滑桿
        setupSlider()
        setupSearchBar()
        //設定標題大小
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25)]
        tableview.delegate = self
        tableview.dataSource = self
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
                tabbarTitle = ["策略","友情破壞","技巧","經營","運氣","劇情","TRPG","其他"]
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
                            let jsonArr = JSON(responseValue)
                            weakSelf.parseOrder(jsonArr: jsonArr)
                            weakSelf.isOrder = true
                            DispatchQueue.main.async {
                                weakSelf.tableview.reloadData()
                            }
                        }else{
                            print("進賣出訂單API失敗")
                            weakSelf.products = ProductModel.defaultHostLists
                        }
                    }
                }else{
                    NetworkController.instance().getMyOwnItemOnShelf{ [weak self](value, isSuccess) in
                        guard let weakSelf = self else {return}
                        if(isSuccess){
                            let jsonArr = JSON(value)
                            print("解析\(jsonArr)")
                            weakSelf.parseProduct(jsonArr: jsonArr)
                            DispatchQueue.main.async {
                                weakSelf.tableview.reloadData()
                            }
                        }else{
                            weakSelf.products = ProductModel.defaultGameLists
                        }
                    }
                }
            }else{
                self.products = ProductModel.defaultAllList
            }
        }else{//不是我的賣場就call list的API
            NetworkController.instance().getProductListBy(type: productType,type1: productType1,type2: productType2, pageBegin: Global.pageBegin, pageEnd: Global.pageEnd){
                [weak self](value, isSuccess) in
                guard let weakSelf = self else {return}
                if(isSuccess){
                    let jsonArr = JSON(value)
                    print("解析\(jsonArr)")
                    weakSelf.parseProduct(jsonArr: jsonArr)
                    DispatchQueue.main.async {
                        weakSelf.tableview.reloadData()
                    }
                }else{
                    print("失敗")
                    weakSelf.products = ProductModel.defaultGameLists
                }
            }
//            if(productType1.elementsEqual("") && productType2.elementsEqual("")){
//                NetworkController.instance().getProductListByType(type: productType, pageBegin: Global.pageBegin, pageEnd: Global.pageEnd){
//                    [weak self](value, isSuccess) in
//                    guard let weakSelf = self else {return}
//                    if(isSuccess){
//                        let jsonArr = JSON(value)
//                        print("解析\(jsonArr)")
//                        weakSelf.parseProduct(jsonArr: jsonArr)
//                        DispatchQueue.main.async {
//                            weakSelf.tableview.reloadData()
//                        }
//                    }else{
//                        print("失敗")
//                        weakSelf.products = ProductModel.defaultGameLists
//                    }
//                }
//                return
//            }
//            if(productType1.elementsEqual("")){
//                NetworkController.instance().getProductListByTypeAndType2(type: productType ,type2: productType2 , pageBegin: 1, pageEnd: 10) { [weak self](value, isSuccess) in
//                    guard let weakSelf = self else {return}
//                    if(isSuccess){
//                        let jsonArr = JSON(value)
//                        print("解析\(jsonArr)")
//                        weakSelf.parseProduct(jsonArr: jsonArr)
//                        DispatchQueue.main.async {
//                            weakSelf.tableview.reloadData()
//                        }
//                    }else{
//                        print("失敗")
//                        weakSelf.products = ProductModel.defaultGameLists
//                    }
//                }
//                return
//            }
//            if(productType1.elementsEqual("4人以下") || productType1.elementsEqual("4-8人") ||
//                productType1.elementsEqual("8人以上")){
//                tabbarTitle = ["策略","友情破壞","技巧","經營","運氣","劇情","TRPG","其他"]
//            }else{
//                tabbarTitle = ["所有","遊戲","主機","周邊","其他"]
//            }
//
//            if(Global.isOnline){
//                print("進到getProductListByType1       \(productType1) "   )
//                NetworkController.instance().getProductListByType1(type1: productType1, pageBegin: 1, pageEnd: 10) { [weak self](value, isSuccess) in
//                    guard let weakSelf = self else {return}
//                    if(isSuccess){
//                        let jsonArr = JSON(value)
//                        print("解析\(jsonArr)")
//                        weakSelf.parseProduct(jsonArr: jsonArr)
//                        DispatchQueue.main.async {
//                            weakSelf.tableview.reloadData()
//                        }
//                    }else{
//                        print("失敗")
//                        weakSelf.products = ProductModel.defaultGameLists
//                    }
//                }
//            }else{
//                self.products = ProductModel.defaultAllList
//            }
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
            flowLayout?.itemSize = CGSize(width: self.view.frame.width/3, height: 45)
        }else{
            flowLayout?.itemSize = CGSize(width: self.view.frame.width/3.5, height: 45)
        }
    }
    private func setupSlider(){
        self.slider.frame.size = CGSize(width: 90, height: 3)
        self.slider.center.y = collectview.bounds.maxY-15
        collectview.addSubview(slider)
        //        collectionView(collectview, didSelectItemAt:[0,0])
    }
    private func setupSearchBar(){
        //searchbar
        
        navigationController?.navigationBar.prefersLargeTitles = false
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.placeholder = "請輸入關鍵字"
        searchController?.searchBar.delegate = self
        searchController?.searchBar.barTintColor = UIColor(named: "card")
        searchController?.searchBar.tintColor = UIColor(named: "Button")
        //searvhbar輸入文字顏色
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        // 找到Text field in search bar.
        let textField = searchController?.searchBar.value(forKey: "searchField") as! UITextField
        // 找到放大鏡
        let glassIconView = textField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        //設定放大鏡顏色
        glassIconView.tintColor = UIColor(named: "Button")
        //找到叉叉按鈕
        let clearButton = textField.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        //設定叉叉顏色
        clearButton.tintColor = UIColor(named: "Button")
        //在編輯時會跑出叉叉的位置顯示一個可以按的button，只要一開始編輯就會換成叉叉
        //            searchController?.searchBar.showsSearchResultsButton = true
        //        searchController?.dimsBackgroundDuringPresentation = false //ios12被丟掉的方法
        definesPresentationContext = true
        tableview.tableHeaderView = searchController?.searchBar
        //        tableview.tableHeaderView?.backgroundColor = .clear
        //        tableview.backgroundColor = .clear
        tableview.backgroundView = UIView()
        tableview.backgroundView?.backgroundColor = .clear
    }
    @IBAction func addProductClick(){
        if let vcMain = self.storyboard?.instantiateViewController(identifier: "AddProductViewController") as? AddProductViewController{
            vcMain.isModifyType = false
            self.show(vcMain, sender: nil);
        }
    }
    //MARK:- 解析JSON
    private func parseProduct(jsonArr:JSON){
        for index in 0..<jsonArr.count{
            let id = jsonArr[index]["id"].string ?? ""
            let title = jsonArr[index]["title"].string  ?? ""
            let description = jsonArr[index]["description"].string ?? ""
            let isSale = jsonArr[index]["isSale"].bool ?? false
            let isRent = jsonArr[index]["isRent"].bool ?? false
            let isExchange = jsonArr[index]["isExchange"].bool ?? false
            let address = jsonArr[index]["address"].string ?? ""
            let deposit = jsonArr[index]["deposit"].int ?? 0
            let rent = jsonArr[index]["rent"].int ?? 0
            let salePrice = jsonArr[index]["salePrice"].int ?? 0
            let rentMethod = jsonArr[index]["rentMethod"].string ?? ""
            let amount = jsonArr[index]["amount"].int ?? 0
            let type = jsonArr[index]["type"].string ?? ""
            let type1 = jsonArr[index]["type1"].string ?? ""
            let type2 = jsonArr[index]["type2"].string ?? ""
            let userId = jsonArr[index]["userId"].string ?? ""
            let picsArr = jsonArr[index]["pics"].array ?? []
            let weightPrice = jsonArr[index]["weightPrice"].float ?? 0.0
            
            var pics = [PicModel]()
            for index in 0..<picsArr.count{
                let id  = picsArr[index]["id"].string ?? ""
                let path  = picsArr[index]["path"].string ?? ""
                let productId  = picsArr[index]["productId"].string ?? ""
                pics.append(PicModel.init(id: id, path: path, productId: productId))
            }
            self.products.append(ProductModel.init(id: id, title: title, description: description, isSale: isSale, isRent: isRent, isExchange: isExchange, deposit: deposit, rent: rent, salePrice: salePrice, address: address, rentMethod: rentMethod, amount: amount, type: type, type1: type1, type2: type2, userId: userId, pics: pics, weightPrice: weightPrice))
        }
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
            cell.lbTitle.textColor = .white
            
            //第一次產生cell時 設定tabbar slider
            if(indexPath.row==0 && !firstTabbarDidLoad ){
                cell.isSelected = true
                firstTabbarDidLoad = true
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
                    //                    firstcell.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
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
        if(isMyStore){
            switch selectedProductType {
            case "上架中":
                NetworkController.instance().getMyOwnItemOnShelf{
                    [weak self](responseValue, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        let jsonArr = JSON(responseValue)
                        weakSelf.parseProduct(jsonArr: jsonArr)
                        weakSelf.isOrder = false
                        DispatchQueue.main.async {
                            weakSelf.tableview.reloadData()
                        }
                    }else{
                        weakSelf.products = ProductModel.defaultHostLists
                        DispatchQueue.main.async {
                            weakSelf.tableview.reloadData()
                        }
                    }
                }
            case "未上架":
                NetworkController.instance().getMyOwnItemNotOnShelf{
                    [weak self](responseValue, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        let jsonArr = JSON(responseValue)
                        weakSelf.parseProduct(jsonArr: jsonArr)
                        weakSelf.isOrder = false
                        DispatchQueue.main.async {
                            weakSelf.tableview.reloadData()
                        }
                    }else{
                        print("沒有商品")
                        DispatchQueue.main.async {
                            weakSelf.tableview.reloadData()
                        }
                    }
                }
                return
            case "已立單":
                orderSelectStatus = selectedProductType
            case "已寄送":
                orderSelectStatus = selectedProductType
            case "已抵達":
                orderSelectStatus = selectedProductType
            case"歸還已寄出":
                orderSelectStatus = selectedProductType
            case"歷史記錄":
                orderSelectStatus = "已結單"
            default:
                self.products = ProductModel.defaultAllList
            }
            if !orderSelectStatus.elementsEqual("上架中") && !orderSelectStatus.elementsEqual("未上架"){
                NetworkController.instance().getMyOrderListSeller(status: orderSelectStatus){
                    [weak self](responseValue, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        let jsonArr = JSON(responseValue)
                        weakSelf.parseOrder(jsonArr: jsonArr)
                        weakSelf.isOrder = true
                    }else{
                        print("進賣出訂單API失敗")
                        weakSelf.products = ProductModel.defaultHostLists
                    }
                    DispatchQueue.main.async {
                        weakSelf.tableview.reloadData()
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
            default:
                products = ProductModel.defaultGameLists
            }
            NetworkController.instance().getProductListBy(type: productType, type1: productType1, type2: productType2, pageBegin: Global.pageBegin, pageEnd: Global.pageEnd){
                [weak self](value, isSuccess) in
                guard let weakSelf = self else {return}
                if(isSuccess){
                    let jsonArr = JSON(value)
                    weakSelf.parseProduct(jsonArr: jsonArr)
                    DispatchQueue.main.async {
                        weakSelf.tableview.reloadData()
                    }
                }else{
                    weakSelf.products = ProductModel.defaultHostLists
                    DispatchQueue.main.async {
                        weakSelf.tableview.reloadData()
                    }
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
            return ((searchController?.isActive)!) ? searchOrders.count : orders.count
        }else{
            return ((searchController?.isActive)!) ? searchProducts.count : products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(isMyStore){
            if(isOrder){
                if((searchController?.isActive)!){
                    guard indexPath.row<searchProducts.count else {
                        return UITableViewCell()
                    }
                }else{
                    guard indexPath.row<orders.count else {
                        return UITableViewCell()
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier:TableViewCell.myOrderListTableViewCell.rawValue) as? MyOrderListTableViewCell {
                    cell.backgroundColor = UIColor(named: "card")
                    ((searchController?.isActive)!)
                        ?cell.configure(with: searchOrders[indexPath.row])
                        :cell.configure(with: orders[indexPath.row])
                    return cell;
                }
            }else{
                if let cell = tableView.dequeueReusableCell(withIdentifier:TableViewCell.myStoreTableViewCell.rawValue ) as? MyStoreTableViewCell {
                    cell.backgroundColor = UIColor(named: "card")
                    ((searchController?.isActive)!)
                        ?cell.configure(with: searchProducts[indexPath.row])
                        :cell.configure(with: products[indexPath.row])
                    return cell;
                }
            }
        }else{
            if((searchController?.isActive)!){
                guard indexPath.row<searchProducts.count else {
                    return UITableViewCell()
                }
            }else{
                guard indexPath.row<products.count else {
                    return UITableViewCell()
                }
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductModelCell") as? ProductModelCell {
                cell.backgroundColor = UIColor(named: "card")
                print("位置\(indexPath.row)\n總數\(self.products.count)")
                
                ((searchController?.isActive)!)
                    ?cell.configure(with: searchProducts[indexPath.row])
                    :cell.configure(with: products[indexPath.row])
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
        250
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
                        if(isSuccess){
                            weakSelf.products.remove(at: indexPath.row)
                            DispatchQueue.main.async {
                                weakSelf.tableview.reloadData()
                            }
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
        return UISwipeActionsConfiguration()
    }
}
extension ProductListController : UISearchResultsUpdating,UISearchBarDelegate{
    // 點擊searchBar的搜尋按鈕時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        products.removeAll()
        if(isMyStore){
            if(isOrder){//拿訂單
                NetworkController.instance().getMyOrderListSeller(status: "All"){ [weak self](value, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        let jsonArr = JSON(value)
                        weakSelf.parseOrder(jsonArr: jsonArr)
                    }else{
                        print("沒訂單")
                    }
                }
            }else{
                NetworkController.instance().getMyOwnItem{ [weak self](value, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        let jsonArr = JSON(value)
                        weakSelf.parseProduct(jsonArr: jsonArr)
                    }else{
                        weakSelf.products = ProductModel.defaultGameLists
                    }
                }
            }
        }else{//不是我的賣場就call list的API
            if(Global.isOnline){
                if productType1.elementsEqual("") {
                    print("productType is nil")
                    return
                }
                print("進到getProductListByType1")
                NetworkController.instance().getProductListByType1(type1: productType1, pageBegin: 1, pageEnd: 10) { [weak self](value, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        let jsonArr = JSON(value)
                        print("解析\(jsonArr)")
                        weakSelf.parseProduct(jsonArr: jsonArr)
                    }else{
                        print("失敗")
                        weakSelf.products = ProductModel.defaultGameLists
                    }
                }
            }else{
                self.products = ProductModel.defaultAllList
            }
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        
        if self.searchController?.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            return
        }
        let searchString = searchController.searchBar.text!
        if(isOrder){
            searchOrders = orders.filter { $0.p_Title.lowercased().contains(searchString.lowercased())}
            orders = searchOrders
        }else{
            searchProducts = products.filter { $0.title.lowercased().contains(searchString.lowercased())}
            products = searchProducts
        }
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
}

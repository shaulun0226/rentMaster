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
    var tabbarTitle = [String]()
    var products = [ProductModel]()
    //searchbar
    var searchProducts = [ProductModel]()
    open var searchController: UISearchController? //建立searchController
    //    var searchResultController = UITableViewController()
    //建立一個搜尋結果controller
    open var hidesSearchBarWhenScrolling: Bool = true
    //collectionview底線
    var slider = UIView()
    var productType1:String?
    var productType2:String?
    //searchbar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlider()
        setupSearchBar()
        //設定標題大小
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25)]
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundView?.backgroundColor = .clear
//        tableview.bounces = false
        collectview.delegate = self
        collectview.dataSource = self
        //設定按鈕
        (isMyStore) ?(btnAdd.isHidden = false):(btnAdd.isHidden = true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.products.removeAll()
        if(isMyStore){
            tabbarTitle = ["上架中","未上架","出租中","未出貨"]
            if(Global.isOnline){
                NetworkController.instance().getOwnitem{ [weak self](value, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        let jsonArr = JSON(value)
                        print("解析\(jsonArr)")
                        weakSelf.parseProduct(jsonArr: jsonArr)
                        weakSelf.tableview.reloadData()
                    }else{
                        weakSelf.products = ProductModel.defaultGameLists
                    }
                }
            }else{
                self.products = ProductModel.defaultAllList
            }
        }else{//不是我的賣場就call list的API
            tabbarTitle = ["所有","遊戲","主機","周邊","其他"]
            if(Global.isOnline){
                guard productType1 != nil else {
                    print("productType is nil")
                    return
                }
                print("進到getProductListByType1")
                NetworkController.instance().getProductListByType1(type1: productType1!, pageBegin: 1, pageEnd: 10) { [weak self](value, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        let jsonArr = JSON(value)
                        print("解析\(jsonArr)")
                        weakSelf.parseProduct(jsonArr: jsonArr)
                        weakSelf.tableview.reloadData()
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
    private func setupSlider(){
        self.slider.frame.size = CGSize(width: 90, height: 5)
        self.slider.center.y = collectview.bounds.maxY-10
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
        //設定searchController 背景顏色
        //        searchController?.searchBar.backgroundColor = UIColor(named: "card")//沒用
        //設定searchBar顏色
//                    searchController?.searchBar.barStyle = .black
        searchController?.searchBar.barTintColor = UIColor(named: "card")
        //            searchController?.searchBar.searchTextField.backgroundColor = UIColor(named: "card")?.withAlphaComponent(0.1)
        //searchbar取消文字顏色
//        searchController?.searchBar.backgroundColor = UIColor(named: "card")
//        searchController?.view.tintColor = UIColor(named: "card")
//        searchController?.view.backgroundColor = UIColor(named: "card")   沒用的方法
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
    }
    @IBAction func addProductClick(){
        if let vcMain = self.storyboard?.instantiateViewController(identifier: "AddProductViewController") as? AddProductViewController{
            vcMain.isModifyType = false
            self.show(vcMain, sender: nil);
        }
    }
    private func resetViewByAPI(){
        if(Global.isOnline){
            NetworkController.instance().getOwnitem{ [weak self](value, isSuccess) in
                guard let weakSelf = self else {return}
                if(isSuccess){
                    let jsonArr = JSON(value)
                    print("解析\(jsonArr)")
                    weakSelf.parseProduct(jsonArr: jsonArr)
                    weakSelf.tableview.reloadData()
                }else{
                    weakSelf.products = ProductModel.defaultGameLists
                }
            }
        }else{
            self.products = ProductModel.defaultAllList
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
            if(indexPath.row == 0){
                cell.isSelected = true
            }else{
                cell.isSelected = false
            }
            cell.backgroundColor = UIColor(named: "card")
            cell.lbTitle.text = tabbarTitle[indexPath.row]
            cell.lbTitle.textColor = .white
            
            //第一次產生cell時 設定tabbar slider
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
        if let cell = collectview.cellForItem(at: indexPath){
            //設定點擊背景色變化
            if(indexPath.row != 0){
                if let firstcell = collectview.cellForItem(at: IndexPath(item: 0, section: 0)){
                    if(firstcell.isSelected){
                        firstcell.isSelected = false
                        firstcell.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
                    }
                }
            }
            cell.isSelected = true
            cell.backgroundColor = UIColor(named: "card")
            
            collectview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            UIView.animate(withDuration: 0.4) { [weak self] in
                if let self = self{
                    self.slider.center.x = cell.center.x
                }
            }
            products.removeAll()
            let selectedProductType = tabbarTitle[indexPath.row]
            switch selectedProductType {
            case "所有":
                productType2 = "all"
            case "主機":
                productType2 = "主機"
            case "周邊":
                productType2 = "周邊"
            case "遊戲":
                productType2 = "遊戲"
            case "其他":
                productType2 = "其他"
            default:
                products = ProductModel.defaultGameLists
            }
            if let productType1 = productType1 {
                print(productType1)
            }
            if let productType2 = productType2 {
                
                print(productType2)
            }
            productType1 = "PS5"
            productType2 = "遊戲"
            if(Global.isOnline){
                NetworkController.instance().getProductListByType2(type1: productType1!,type2: productType2!  ,pageBegin: Global.pageBegin, pageEnd: Global.pageEnd) {
                    [weak self](value, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        let jsonArr = JSON(value)
                        weakSelf.parseProduct(jsonArr: jsonArr)
                        weakSelf.tableview.reloadData()
                    }else{
                        weakSelf.products = ProductModel.defaultHostLists
                    }
                }
            }else{
                let selectedProductType = tabbarTitle[indexPath.row]
                switch selectedProductType {
                case "所有":
                    products = ProductModel.defaultAllList
                case "主機":
                    products = ProductModel.defaultHostLists
                case "周邊":
                    products = ProductModel.defaultMerchLists
                case "遊戲":
                    products = ProductModel.defaultGameLists
                case "其他":
                    products = ProductModel.defaultGameLists
                default:
                    products = ProductModel.defaultGameLists
                }
            }
            tableview.reloadData()
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
            self.products.append(ProductModel.init(id: id, title: title, description: description, isSale: isSale, isRent: isRent, isExchange: isExchange, deposit: deposit, rent: rent, salePrice: salePrice, address: address, rentMethod: rentMethod, amount: amount, type: type, type1: type1, type2: type2, userId: userId, pics: pics, weightPrice: weightPrice))
        }
    }
}
extension ProductListController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((searchController?.isActive)!) ? searchProducts.count : products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(isMyStore){
            if let cell = tableView.dequeueReusableCell(withIdentifier:TableViewCell.myStoreTableViewCell.rawValue ) as? MyStoreTableViewCell {
                cell.backgroundColor = UIColor(named: "card")
                ((searchController?.isActive)!)
                    ?cell.configure(with: searchProducts[indexPath.row])
                    :cell.configure(with: products[indexPath.row])
                return cell;
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductModelCell") as? ProductModelCell {
                cell.backgroundColor = UIColor(named: "card")
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
            if let productModifyView = Global.productStoryboard.instantiateViewController(identifier: ProductStoryboardController.addProductViewController.rawValue) as? AddProductViewController{
                productModifyView.isModifyType = true
                productModifyView.product = products[indexPath.row]
                self.show(productModifyView,sender: nil)
            }
        }else{
            //跳到商品資訊
            if let productInfoView = Global.productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productInfoViewController.rawValue) as? ProductInfoViewController{
                productInfoView.product = products[indexPath.row]
                self.show(productInfoView, sender: nil);
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.backgroundColor = UIColor(named: "card")
        if (scrollView.contentOffset.y<0) {
            self.tableview.backgroundColor = UIColor(named: "card")//和頂部區域同色
        } else {
            self.tableview.backgroundColor = UIColor(named: "card")
        }
    }
}
extension ProductListController : UISearchResultsUpdating,UISearchBarDelegate{
    // 點擊searchBar的搜尋按鈕時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        products.removeAll()
        if(isMyStore){
            if(Global.isOnline){
                NetworkController.instance().getOwnitem{ [weak self](value, isSuccess) in
                    guard let weakSelf = self else {return}
                    if(isSuccess){
                        let jsonArr = JSON(value)
                        print("解析\(jsonArr)")
                        weakSelf.parseProduct(jsonArr: jsonArr)
                    }else{
                        weakSelf.products = ProductModel.defaultGameLists
                    }
                }
            }else{
                self.products = ProductModel.defaultAllList
            }
        }else{//不是我的賣場就call list的API
            if(Global.isOnline){
                guard productType1 != nil else {
                    print("productType is nil")
                    return
                }
                print("進到getProductListByType1")
                NetworkController.instance().getProductListByType1(type1: productType1!, pageBegin: 1, pageEnd: 10) { [weak self](value, isSuccess) in
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
        searchProducts = products.filter { $0.title.lowercased().contains(searchString.lowercased())}
        products = searchProducts
        self.tableview.reloadData()
    }
}

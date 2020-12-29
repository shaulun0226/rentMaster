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
    var buttonText = [String]()
    var products = [ProductModel]()
    //collectionview底線
    var slider = UIView()
    var productType1:String?
    var productType2:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isMyStore){
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
        setupSlider()
        //設定標題大小
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25)]
        tableview.delegate = self
        tableview.dataSource = self
        collectview.delegate = self
        collectview.dataSource = self
        //設定按鈕
        (isMyStore) ?(btnAdd.isHidden = false):(btnAdd.isHidden = true)
    }
    override func viewWillAppear(_ animated: Bool) {
        setupSlider()
    }
    private func setupSlider(){
        self.slider.frame.size = CGSize(width: 90, height: 3)
        self.slider.center.y = collectview.bounds.maxY-8
        collectview.addSubview(slider)
        collectionView(collectview, didSelectItemAt:[0,0])
    }
    @IBAction func addProductClick(){
        if let vcMain = self.storyboard?.instantiateViewController(identifier: "AddProductViewController") as? AddProductViewController{
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
        buttonText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarCell", for: indexPath) as! TabBarCell
        if(indexPath.row == 0){
            cell.isSelected = true
        }else{
            cell.isSelected = false
        }
        cell.backgroundColor = UIColor(named: "card")
        cell.lbTitle.text = buttonText[indexPath.row]
        cell.lbTitle.textColor = .white
        //        cell.layer.insertSublayer(layer, at: 0)
        return cell
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
            let selectedProductType = buttonText[indexPath.row]
            switch selectedProductType {
            case "所有":
                productType2 = "all"
            case "主機":
                productType2 = "host"
            case "周邊":
                productType2 = "other"
            case "遊戲":
                productType2 = "game"
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
            productType2 = "game"
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
                let selectedProductType = buttonText[indexPath.row]
                switch selectedProductType {
                case "所有":
                    products = ProductModel.defaultAllList
                case "主機":
                    products = ProductModel.defaultHostLists
                case "周邊":
                    products = ProductModel.defaultMerchLists
                case "遊戲":
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
            let tradeItemsArr = jsonArr[index]["trideItems"].array!
            var pics = [String]()
            for index in 0..<picsArr.count{
                pics.append(picsArr[index]["path"].string ?? "")
            }
            var items = [String]()
            for index in 0..<items.count{
                items.append(tradeItemsArr[index]["exchangeItem"].string ?? "")
            }
            self.products.append(ProductModel.init(id: id, title: title, description: description, isSale: isSale, isRent: isRent, isExchange: isExchange, deposit: deposit, rent: rent, salePrice: salePrice, address: address, rentMethod: rentMethod, amount: amount, type: type, type1: type1, type2: type2, userId: userId, pics: pics, tradeItems: items))
        }
    }
}
extension ProductListController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductModelCell") as? ProductModelCell {
            cell.backgroundColor = UIColor(named: "card")
            //            cell.lbName.text = contractLists[indexPath.row].name
            //            cell.lbHouse.text = contractLists[indexPath.row].house
            cell.configure(with: products[indexPath.row])
            //            cell.layer.insertSublayer(layer, at: 0)
            return cell;
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let productInfoView = Global.productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productInfoViewController.rawValue) as? ProductInfoViewController{
            productInfoView.product = products[indexPath.row]
            self.show(productInfoView, sender: nil);
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
}

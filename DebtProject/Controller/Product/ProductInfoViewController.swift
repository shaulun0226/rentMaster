//
//  ProductViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/15.
//

import UIKit
import SwiftAlertView
import SwiftyJSON

class ProductInfoViewController: BaseViewController {
    @IBOutlet weak var lbProductTtile: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbSalePrice: UILabel!
    @IBOutlet weak var lbProductDescription: UILabel!
    @IBOutlet weak var lbProductType: UILabel!
    @IBOutlet weak var lbTradeType: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbTradeMethod: UILabel!
    @IBOutlet weak var lbTradeItem: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var productInfoTableView: UITableView!
    @IBOutlet weak var productInfoTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productInfoCollectionView: UICollectionView!
    @IBOutlet weak var productInfoPC: UIPageControl!
    var products = [ProductModel]()
    var productsBySeller = [ProductModel]()
    var product:ProductModel!
    var productsImage = [String]()
    var productTitle:String!
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        productInfoTableView.layer.removeAllAnimations()
        productInfoTableViewHeight.constant = productInfoTableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productInfoTableView.delegate = self
        self.productInfoTableView.dataSource = self
        self.productInfoTableView.rowHeight = UITableView.automaticDimension
        self.productInfoTableView.estimatedRowHeight = UITableView.automaticDimension
        //設定KVO
        self.productInfoTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.productInfoTableView.register(UINib(nibName: "PageTableViewCell", bundle: nil), forCellReuseIdentifier: "PageTableViewCell")
        self.productInfoCollectionView.delegate = self
        self.productInfoCollectionView.dataSource = self
        self.productInfoCollectionView.isPagingEnabled = true
        
        setText()
        
        //設定換頁控制器有幾頁
        productInfoPC.numberOfPages = productsImage.count
        //起始在第0頁
        productInfoPC.currentPage = 0;
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productsBySeller.removeAll()
        NetworkController.instance().getProductListBySellerId(sellerId: product.userId, pageBegin: Global.pageBegin, pageEnd: Global.pageEnd){
            [weak self] (responseValue,isSuccess) in
            guard let weakSelf = self else{return}
            if(isSuccess){
                let jsonArr = JSON(responseValue)
                weakSelf.productsBySeller = weakSelf.parseProduct(jsonArr: jsonArr)
                DispatchQueue.main.async {
                    weakSelf.productInfoTableView.reloadData()
                }
            }else{
                
            }
        }
    }
    private func parseProduct(jsonArr:JSON) -> [ProductModel]{
        var products = [ProductModel]()
        for index in 0..<jsonArr.count{
            let id = jsonArr[index]["id"].string ?? ""
            if(id.elementsEqual(product.id)){
                continue
            }
            let title = jsonArr[index]["title"].string ?? ""
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
            products.append(ProductModel.init(id: id, title: title, description: description, isSale: isSale, isRent: isRent, isExchange: isExchange, deposit: deposit, rent: rent, salePrice: salePrice, address: address, rentMethod: rentMethod, amount: amount, type: type, type1: type1, type2: type2, userId: userId, pics: pics, weightPrice: weightPrice))
        }
        return products
    }
    private func parseProduct(json:JSON){
        let id = json["id"].string  ?? ""
        let title = json["title"].string  ?? ""
        let description = json["description"].string  ?? ""
        let isSale = json["isSale"].bool  ?? false
        let isRent = json["isRent"].bool  ?? false
        let isExchange = json["isExchange"].bool ?? false
        let address = json["address"].string ?? ""
        let deposit = json["deposit"].int ?? 0
        let rent = json["rent"].int ?? 0
        let salePrice = json["salePrice"].int ?? 0
        let rentMethod = json["rentMethod"].string  ?? ""
        let amount = json["amount"].int ?? 0
        let type = json["type"].string ?? ""
        let type1 = json["type1"].string  ?? ""
        let type2 = json["type2"].string ?? ""
        let userId = json["userId"].string ?? ""
        let picsArr = json["pics"].array ?? []
        let weightPrice = json["weightPrice"].float ?? 0.0
        var pics = [PicModel]()
        for index in 0..<picsArr.count{
            let id  = picsArr[index]["id"].string ?? ""
            let path  = picsArr[index]["path"].string ?? ""
            let productId  = picsArr[index]["productId"].string ?? ""
            pics.append(PicModel.init(id: id, path: path, productId: productId))
        }
        self.product = ProductModel.init(id: id, title: title, description: description, isSale: isSale, isRent: isRent, isExchange: isExchange, deposit: deposit, rent: rent, salePrice: salePrice, address: address, rentMethod: rentMethod, amount: amount, type: type, type1: type1, type2: type2, userId: userId, pics: pics, weightPrice: weightPrice)
    }
    func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
    private func setText(){
        if(Global.isOnline){
            lbProductTtile.text = "\(product.title)"
            lbProductType.text = "\(product.type)/\(product.type1)/\(product.type2)"
            lbTradeMethod.text = "交貨方式 : \(product.rentMethod)"
            lbAmount.text = "剩餘數量 : \(product.amount)"
            lbProductDescription.text = "商品敘述:\(product.description)"
            var tradeType = [String]()
            var price = [String]()
            if(product.isSale){
                tradeType.append("販售")
                price.append("售價 : \(product.salePrice)元")
            }
            if(product.isRent){
                tradeType.append("租借")
                price.append("押金 : \(product.deposit)元")
                price.append("租金 : \(product.rent)元/日")
            }
            if(product.isExchange){
                tradeType.append("交換")
                price.append("權重 : \(product.weightPrice)")
            }
            //            lbSalePrice.text = price
            var tradeTypeText = ""
            for index in 0..<tradeType.count{
                if(index==tradeType.count-1){
                    tradeTypeText += "\(tradeType[index])"
                }else{
                    tradeTypeText += "\(tradeType[index])/"
                }
            }
            var priceText = ""
            for index in 0..<price.count{
                if(index==price.count-1){
                    priceText += "\(price[index])"
                }else{
                    priceText += "\(price[index])\n"
                }
            }
            lbSalePrice.text = priceText
            lbTradeType.text = tradeTypeText
            lbAddress.text = "商品地區 : \(product.address)"
            for index in 0..<product.pics.count{
                productsImage.append(product.pics[index].path)
            }
        }else{
            productsImage.append("monsterhunter")
            productsImage.append("ps4")
            productsImage.append("ps5Controller")
            DispatchQueue.main.async {
                self.productInfoCollectionView.reloadData()
            }
            lbTradeItem.text = "商品詳情:測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試測試內容;"
        }
    }
    //按下立即下單按鈕
    @IBAction func confirmOnClicked(_ sender: Any) {
        //連網下單
        if(Global.isOnline){
            if (User.token.isEmpty){
                let notLoginAlertView = SwiftAlertView(title: "", message: "請先登入!\n", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "確定")
                notLoginAlertView.clickedCancelButtonAction = {
                    notLoginAlertView.dismiss()
                }
                notLoginAlertView.clickedButtonAction = {[self] index in
                    if(index==1){
                        if let loginView = Global.mainStoryboard.instantiateViewController(identifier:MainStoryboardController.login.rawValue ) as? LoginViewController{
                            self.present(loginView, animated: true, completion: nil)
                        }
                    }
                }
                notLoginAlertView.messageLabel.textColor = UIColor(named: "labelColor")
                notLoginAlertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
                notLoginAlertView.button(at: 0)?.backgroundColor = UIColor(named: "CancelButton")
                notLoginAlertView.button(at: 1)?.backgroundColor = UIColor(named: "Button")
                notLoginAlertView.backgroundColor = UIColor(named: "Card-2")
                notLoginAlertView.buttonTitleColor = .white
                notLoginAlertView.show()
                return
            }
        }
        if let makeOrderView = Global.productStoryboard.instantiateViewController(identifier: ProductStoryboardController.makeOrderViewController.rawValue) as? MakeOrderViewController{
            makeOrderView.product  = self.product
            makeOrderView.delegate = self
            self.present(makeOrderView, animated: true, completion: nil)
            //            self.presentBottom(makeOrderView)
        }
    }
    @IBAction func addCartClick(_ sender: Any) {
        if(Global.isOnline){
            if (User.token.isEmpty){
                let alertView = SwiftAlertView(title: "", message: "請先登入\n", delegate: nil, cancelButtonTitle: "取消",otherButtonTitles: "確定")
                alertView.messageLabel.textColor = UIColor(named: "labelColor")
                alertView.messageLabel.font = UIFont.systemFont(ofSize: 30)
                alertView.button(at: 0)?.backgroundColor = UIColor(named: "CancelButton")
                alertView.button(at: 1)?.backgroundColor = UIColor(named: "Button")
                alertView.backgroundColor = UIColor(named: "Card-2")
                alertView.buttonTitleColor = .white
                alertView.clickedButtonAction = { index in
                    if(index==0){
                        alertView.dismiss()
                        return
                    }
                    if(index==1){
                        if let loginView = Global.mainStoryboard.instantiateViewController(identifier:MainStoryboardController.login.rawValue ) as? LoginViewController{
                            if let productInfoView = Global.productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productInfoViewController.rawValue) as? ProductInfoViewController{
                                productInfoView.product = self.product
                                Global.presentView = productInfoView
                            }
                            self.present(loginView, animated: true, completion: nil)
                        }
                        return
                    }
                }
                alertView.show()
                
                return
            }
            NetworkController.instance().addCart(productId: product.id){
                (responseValue, isSuccess) in
                //                guard let weakSelf = self else {return}
                let alertView = SwiftAlertView(title: "", message: "成功加入關注清單！\n", delegate: nil, cancelButtonTitle: "確定")
                alertView.messageLabel.textColor = UIColor(named: "labelColor")
                alertView.messageLabel.font = UIFont.systemFont(ofSize: 25)
                alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
                alertView.backgroundColor = UIColor(named: "Card-2")
                alertView.buttonTitleColor = .white
                alertView.clickedButtonAction = { index in
                    alertView.dismiss()
                }
                if(isSuccess){
                    alertView.clickedButtonAction = { index in
                        alertView.dismiss()
                    }
                    alertView.show()
                }else{
                    alertView.clickedButtonAction = { index in
                        alertView.dismiss()
                    }
                    alertView.messageLabel.text = "\(responseValue)\n"
                    alertView.show()
                }
            }
        }
    }
}
extension ProductInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PageTableViewCell") as? PageTableViewCell {
            cell.lbMainPageTitle.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.regular)
            switch indexPath.row {
            case 0:
                cell.lbMainPageTitle.text = "賣場其他商品"
                if(Global.isOnline){
                    NetworkController.instance().getProductListBySellerId(sellerId: product.userId, pageBegin: Global.pageBegin, pageEnd: Global.pageEnd){
                        [weak self] (responseValue,isSuccess) in
                        guard let weakSelf = self else{return}
                        if(isSuccess){
                            let jsonArr = JSON(responseValue)
                            cell.products.removeAll()
                            cell.products = weakSelf.parseProduct(jsonArr: jsonArr)
                            DispatchQueue.main.async {
                                cell.pageCollectionView.reloadData()
                            }
                        }else{
                            print("取得賣家其他商品失敗")
                        }
                    }
                }
            case 1:
                cell.lbMainPageTitle.text = "您可能喜歡"
                if(Global.isOnline){
                    NetworkController.instance().getProductListByType2(type1: product.type1, type2: product.type2, pageBegin: Global.pageBegin, pageEnd: Global.pageEnd){
                        [weak self] (responseValue,isSuccess) in
                        guard let weakSelf = self else{return}
                        if(isSuccess){
                            let jsonArr = JSON(responseValue)
                            cell.products.removeAll()
                            cell.products = weakSelf.parseProduct(jsonArr: jsonArr)
                            DispatchQueue.main.async {
                                cell.pageCollectionView.reloadData()
                            }
                        }else{
                            print("取得可能喜歡商品失敗")
                        }
                    }
                }
            default:
                cell.lbMainPageTitle.text = ""
            }
            //設定點擊不反白
            cell.selectionStyle = .none
            cell.lbMainPageHint.isHidden = true
            //設定cell內容
            cell.tableViewCellDelegate = self
            cell.products = ProductModel.defaultGameLists
            return cell;
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
extension ProductInfoViewController:PageTableViewCellDelegate{
    func cellClick(indexPath: IndexPath, products: [ProductModel]) {
        let productModel = products[indexPath.row]
        if let productInfoView = Global.productStoryboard.instantiateViewController(identifier: ProductStoryboardController.productInfoViewController.rawValue) as? ProductInfoViewController{
            productInfoView.product = productModel
            self.show(productInfoView, sender: self)
        }
    }
}

extension ProductInfoViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productsImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.productInfoImageCollectionViewCell.rawValue, for: indexPath) as? ProductInfoImageCollectionViewCell {
            cell.configure(with: productsImage[indexPath.row])
            return cell;
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.productInfoPC.currentPage = Int(roundedIndex)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        productInfoPC.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        productInfoPC.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
extension ProductInfoViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = productInfoCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
extension ProductInfoViewController:MakeOrderViewControllerDelegate{
    func addOrderFinish() {
        NetworkController.instance().getProductById(productId: product.id){
            [weak self] (reponseValue,isSuccess) in
            guard let weakSelf = self else{return}
            if(isSuccess){
                let json = JSON(reponseValue)
                weakSelf.parseProduct(json: json)
                weakSelf.setText()
            }else{
                print("錯誤")
            }
        }
    }
    
    
}

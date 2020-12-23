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
    var btnAddIsHidden = true
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
        guard productType1 != nil else {
            print("productType is nil")
            return
        }
        NetworkController.instance().getProductListByType1(type1: productType1!, pageBegin: 1, pageEnd: 5) { [weak self](value, isSuccess) in
            guard let weakSelf = self else {return}
            if(isSuccess){
                let jsonArr = JSON(value)
                print("解析\(jsonArr)")
                print(jsonArr.type)
                for index in 0..<jsonArr.count{
                    print("inter進迴圈")
                    let title = jsonArr[index]["title"].string!
                    print("title是\(title)")
                    let description = jsonArr[index]["description"].string!
                    let isSale = jsonArr[index]["isSale"].bool!
                    let isRent = jsonArr[index]["isRent"].bool!
                    let deposit = jsonArr[index]["deposit"].int!
                    let rent = jsonArr[index]["rent"].int!
                    let salePrice = jsonArr[index]["salePrice"].int!
                    let rentMethod = jsonArr[index]["rentMethod"].string!
                    let amount = jsonArr[index]["amount"].int!
                    let type1 = jsonArr[index]["type1"].string!
                    let type2 = jsonArr[index]["type2"].string!
                    let userId = jsonArr[index]["userId"].string!
                    let picsArr = jsonArr[index]["pics"].array!
                    var pics = [String]()
                    for index in 0..<picsArr.count{
                        pics.append(picsArr[index][""].string ?? "")
                    }
                    weakSelf.products.append(ProductModel.init(title: title , description: description, isSale: isSale, isRent: isRent, deposit: deposit, rent: rent, salePrice: salePrice, rentMethod: rentMethod, amount: amount, type1: type1, type2: type2, userId: userId, pics:pics))
                }
                weakSelf.tableview.reloadData()
                weakSelf.collectview.reloadData()
            }else{
                weakSelf.products = ProductModel.defaultGameLists
            }
        }
        setupSlider()
        //設定背景顏色
        //        layer = Global.setBackgroundColor(view);
        //        view.layer.insertSublayer(layer, at: 0)
        
        //        collectview.layer.insertSublayer(layer, at: 0)
        //設定標題大小
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25)]
        tableview.delegate = self
        tableview.dataSource = self
        collectview.delegate = self
        collectview.dataSource = self
        print("？？？？？？？物件數量\(self.products.count)")
        //設定按鈕
        (btnAddIsHidden) ?(btnAdd.isHidden = true):(btnAdd.isHidden = false)
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
            print(productType1!)
            print(productType2!)
            productType1 = "xbox"
            productType2 = "other"
            NetworkController.instance().getProductListByType2(type1: productType1!,type2: productType2!  ,pageBegin: 1, pageEnd: 5) {
                [weak self](value, isSuccess) in
                guard let weakSelf = self else {return}
                if(isSuccess){
                    let jsonArr = JSON(value)
                    print(jsonArr.type)
                    for index in 0..<jsonArr.count{
                        let title = jsonArr[index]["title"].string!
                        let description = jsonArr[index]["description"].string!
                        let isSale = jsonArr[index]["isSale"].bool!
                        let isRent = jsonArr[index]["isRent"].bool!
                        let deposit = jsonArr[index]["deposit"].int!
                        let rent = jsonArr[index]["rent"].int!
                        let salePrice = jsonArr[index]["salePrice"].int!
                        let rentMethod = jsonArr[index]["rentMethod"].string!
                        let amount = jsonArr[index]["amount"].int!
                        let type1 = jsonArr[index]["type1"].string!
                        let type2 = jsonArr[index]["type2"].string!
                        let userId = jsonArr[index]["userId"].string!
                        let picsArr = jsonArr[index]["pics"].array!
                        var pics = [String]()
                        for index in 0..<picsArr.count{
                            pics.append(picsArr[index][""].string ?? "")
                        }
                        weakSelf.products.append(ProductModel.init(title: title , description: description, isSale: isSale, isRent: isRent, deposit: deposit, rent: rent, salePrice: salePrice, rentMethod: rentMethod, amount: amount, type1: type1, type2: type2, userId: userId, pics:pics))
                    }
                    weakSelf.tableview.reloadData()
                    weakSelf.collectview.reloadData()
                }else{
                    weakSelf.products = ProductModel.defaultHostLists
                }
            }
            tableview.reloadData()
            collectview.reloadData()
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
        let vcMain = self.storyboard?.instantiateViewController(identifier: "ProductInfoView");
        self.show(vcMain!, sender: nil);
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
}

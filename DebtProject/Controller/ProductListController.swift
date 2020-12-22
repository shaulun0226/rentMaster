//
//  MainViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/3.
//

import UIKit
import SideMenu

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        products = ProductModel.defaultGameLists
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
            let productType = buttonText[indexPath.row]
            switch productType {
            case "主機":
                products = ProductModel.defaultHostLists
            case "周邊":
                products = ProductModel.defaultMerchLists
            case "遊戲":
                products = ProductModel.defaultGameLists
            default:
                products = ProductModel.defaultGameLists
            }
            tableview.reloadData()
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

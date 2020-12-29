//
//  MyOrderListViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/29.
//

import UIKit

class MyOrderListViewController: BaseViewController {
    
    var orders = [ProductModel]()
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
        collectionView.register(TabBarCell.self, forCellWithReuseIdentifier: CollectionViewCell.tabBarCell.rawValue)
        tableview.register(ProductModelCell.self, forCellReuseIdentifier: TableViewCell.productModelCell.rawValue)
        tableview.delegate = self
        tableview.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        tabbarTitle = ["未出貨","租借中","歷史紀錄"]
        orders = ProductModel.defaultAllList
        collectionView.reloadData()
        tableview.reloadData()
        // Do any additional setup after loading the view.
    }
    
    private func setupSlider(){
        self.slider.frame.size = CGSize(width: 90, height: 3)
        self.slider.center.y = collectionView.bounds.maxY-8
        collectionView.addSubview(slider)
    }
}
extension MyOrderListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableview.dequeueReusableCell(withIdentifier: TableViewCell.productModelCell.rawValue) as? ProductModelCell{
            cell.backgroundColor = UIColor(named: "card")
            cell.configure(with: orders[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
    
}
extension MyOrderListViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabbarTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.tabBarCell.rawValue, for: indexPath) as! TabBarCell
        if(indexPath.row == 0){
            cell.isSelected = true
        }else{
            cell.isSelected = false
        }
        cell.backgroundColor = UIColor(named: "card")
        cell.lbTitle.text = tabbarTitle[indexPath.row]
        cell.lbTitle.textColor = .white
        //        cell.layer.insertSublayer(layer, at: 0)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        self.title = buttonText[indexPath.row]
        // 先清空
        if let cell = collectionView.cellForItem(at: indexPath){
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
            orders.removeAll()
        }
    }
}


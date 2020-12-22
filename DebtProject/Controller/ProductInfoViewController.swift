//
//  ProductViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/15.
//

import UIKit

class ProductInfoViewController: BaseViewController {
    @IBOutlet weak var lbProductTtile: UILabel!
    
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbProductInfo: UILabel!
    @IBOutlet weak var lbProductConsole: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbRentType: UILabel!
    @IBOutlet weak var lbOther: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBOutlet weak var productInfoTableView: UITableView!
    @IBOutlet weak var productInfoCollectionView: UICollectionView!
    @IBOutlet weak var productInfoPC: UIPageControl!
    var products = [ProductModel]()
    var productsImage = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productInfoTableView.delegate = self
        self.productInfoTableView.dataSource = self
        self.productInfoTableView.register(UINib(nibName: "PageTableViewCell", bundle: nil), forCellReuseIdentifier: "PageTableViewCell")
        self.productInfoCollectionView.delegate = self
        self.productInfoCollectionView.dataSource = self
        self.productInfoCollectionView.isPagingEnabled = true
        productsImage.append("monsterhunter")
        productsImage.append("ps4")
        productsImage.append("ps5Controller")
        self.productInfoCollectionView.reloadData()
        lbOther.text = "商品詳情:測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容;"
        
        //設定換頁控制器有幾頁
        productInfoPC.numberOfPages = productsImage.count
        //起始在第0頁
        productInfoPC.currentPage = 0;
        // Do any additional setup after loading the view.
    }
    func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
        }
    //按下立即下單按鈕
    @IBAction func confirmOnClicked(_ sender: Any) {
        //連網下單
        //跳出alert顯示成功失敗
        let controller = UIAlertController(title: "確定下單", message: "是否確定下單 ?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default)
    
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}
extension ProductInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PageTableViewCell") as? PageTableViewCell {
            switch indexPath.row {
            case 0:
                cell.lbMainPageTitle.text = "賣場其他商品"
            case 1:
                cell.lbMainPageTitle.text = "您可能喜歡"
            default:
                cell.lbMainPageTitle.text = ""
            }
            cell.lbMainPageHint.isHidden = true
            //設定cell內容
            cell.products = ProductModel.defaultGameLists
            return cell;
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        //設定tableview cell裡的collectview的datasource跟delegate
//        guard let tableViewCell = cell as? MainPageTableViewCell else { return }
//        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
//    }
}
extension ProductInfoViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productsImage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductInfoImageCollectionViewCell", for: indexPath) as? ProductInfoImageCollectionViewCell {
            cell.configure(with: productsImage[indexPath.row])
            productInfoPC.currentPage = indexPath.row
            
            return cell;
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

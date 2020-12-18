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
    
    @IBOutlet weak var ProductInfoTableView: UITableView!
    var products = [ProductModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ProductInfoTableView.delegate = self
        self.ProductInfoTableView.dataSource = self
        self.ProductInfoTableView.register(UINib(nibName: "PageTableViewCell", bundle: nil), forCellReuseIdentifier: "PageTableViewCell")

        // Do any additional setup after loading the view.
    }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
            cell.lbMainPageHint.text = "查看更多 >"
            //設定cell內容
            cell.products = ProductModel.defaultGameLists
            let layer = Global.setBackgroundColor(view)
            cell.layer.insertSublayer(layer, at: 0)
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
//extension ProductInfoViewController:UICollectionViewDelegate,UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        products.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCollectionViewCell", for: indexPath) as? PageCollectionViewCell {
//            cell.configure(with: products[indexPath.row])
//            return cell;
//        }
//        return UICollectionViewCell()
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let vcMain = self.storyboard?.instantiateViewController(identifier: "ProductInfoView");
//
////        vcMain?.title = selectedItem
//        self.show(vcMain!, sender: nil);
//    }
//}

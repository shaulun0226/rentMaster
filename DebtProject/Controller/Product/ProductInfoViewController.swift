//
//  ProductViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/15.
//

import UIKit
import SwiftAlertView

class ProductInfoViewController: BaseViewController {
    @IBOutlet weak var lbProductTtile: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbSalePrice: UILabel!
    @IBOutlet weak var lbProductDescription: UILabel!
    @IBOutlet weak var lbProductType1: UILabel!
    @IBOutlet weak var lbDeposit: UILabel!
    @IBOutlet weak var lbRentPrice: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbRentType: UILabel!
    @IBOutlet weak var lbTradeItem: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var productInfoTableView: UITableView!
    @IBOutlet weak var productInfoCollectionView: UICollectionView!
    @IBOutlet weak var productInfoPC: UIPageControl!
    var products = [ProductModel]()
    var product:ProductModel!
    var productsImage = [String]()
    var productTitle:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print("最後一個\(self.navigationController?.viewControllers.last)")
        //        print("第一個\(self.navigationController?.viewControllers.first)")
        //        if((self.navigationController?.viewControllers.count)! > 2){
        //            print("畫面數量\(self.navigationController?.viewControllers.count)")
        //            for index in 0..<(self.navigationController?.viewControllers.count)!{
        //                print(self.navigationController?.viewControllers[index])
        //            }
        //            if(self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2] is LoginViewController){
        //            print("刪掉最後一個")
        //                self.navigationController?.viewControllers.remove(at: (self.navigationController?.viewControllers.count)!-2)
        //                print("新的畫面數量\(String(describing: self.navigationController?.viewControllers.count))")
        //                self.navigationController?.viewControllers.remove(at: (self.navigationController?.viewControllers.count)!-3)
        //        }else{
        //            print("根本沒進去")
        //        }
        //        }
        self.productInfoTableView.delegate = self
        self.productInfoTableView.dataSource = self
        self.productInfoTableView.register(UINib(nibName: "PageTableViewCell", bundle: nil), forCellReuseIdentifier: "PageTableViewCell")
        self.productInfoCollectionView.delegate = self
        self.productInfoCollectionView.dataSource = self
        self.productInfoCollectionView.isPagingEnabled = true
        if(Global.isOnline){
            lbProductTtile.text = "\(product.title)"
            lbAmount.text = "商品數量:\(product.amount)"
            lbProductDescription.text = "\(product.description)"
            if(product.isSale){
                lbSalePrice.text = "販售價格\(product.salePrice) 元"
            }else{
                lbSalePrice.isHidden = true
            }
            if(product.isRent){
                lbDeposit.text = "商品押金:\(product.deposit) 元"
                lbRentPrice.text = "租借金額:\(product.rent) 元/天"
            }else{
                lbDeposit.isHidden = true
                lbRentPrice.isHidden = true
            }
            if(product.isExchange){
                var itemList = "欲交換商品:\n"
                for index in 0..<product.tradeItems.count{
                    itemList += "       \(index+1).\(product.tradeItems[index].exchangeItem) \n"
                }
                lbTradeItem.text = itemList
            }else{
                lbTradeItem.isHidden = true
            }
            lbAddress.text = "商品地區:\(product.address)"
            lbRentType.text = "寄送方式:\(product.rentMethod)"
            
            for index in 0..<product.pics.count{
                productsImage.append(product.pics[index].path)
            }
        }else{
            productsImage.append("monsterhunter")
            productsImage.append("ps4")
            productsImage.append("ps5Controller")
            self.productInfoCollectionView.reloadData()
            lbTradeItem.text = "商品詳情:測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容測試內容;"
        }
        
        
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
        if(Global.isOnline){
            if (User.token.isEmpty){
                let notLoginAlertView = SwiftAlertView(title: "", message: "請先登入!\n", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "確定")
                notLoginAlertView.clickedCancelButtonAction = {
                    notLoginAlertView.dismiss()
                }
                notLoginAlertView.clickedButtonAction = {[self] index in
                    if(index==1){
                        if let loginView = Global.mainStoryboard.instantiateViewController(identifier:MainStoryboardController.login.rawValue ) as? LoginViewController{
                            //                            }
                            self.present(loginView, animated: true, completion: nil)
                        }
                    }
                }
                notLoginAlertView.messageLabel.textColor = .white
                notLoginAlertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
                notLoginAlertView.button(at: 1)?.backgroundColor = UIColor(named: "Button")
                notLoginAlertView.backgroundColor = UIColor(named: "Alert")
                notLoginAlertView.buttonTitleColor = .white
                notLoginAlertView.show()
                return
            }
        }
        if let makeOrderView = Global.productStoryboard.instantiateViewController(identifier: ProductStoryboardController.makeOrderViewController.rawValue) as? MakeOrderViewController{
            makeOrderView.product  = self.product
            self.present(makeOrderView, animated: true, completion: nil)
//            self.presentBottom(makeOrderView)
        }
    }
    @IBAction func addCartClick(_ sender: Any) {
        if(Global.isOnline){
            if (User.token.isEmpty){
                let alertView = SwiftAlertView(title: "", message: "請先登入\n", delegate: nil, cancelButtonTitle: "取消",otherButtonTitles: "確定")
                alertView.messageLabel.textColor = .white
                alertView.messageLabel.font = UIFont.systemFont(ofSize: 30)
                alertView.button(at: 1)?.backgroundColor = UIColor(named: "Button")
                alertView.backgroundColor = UIColor(named: "Alert")
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
                let alertView = SwiftAlertView(title: "", message: "\(responseValue)\n", delegate: nil, cancelButtonTitle: "確定")
                alertView.messageLabel.textColor = .white
                alertView.messageLabel.font = UIFont.systemFont(ofSize: 25)
                alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
                alertView.backgroundColor = UIColor(named: "Alert")
                alertView.buttonTitleColor = .white
                alertView.clickedButtonAction = { index in
                    alertView.dismiss()
                }
                alertView.show()
                //                if(isSuccess){
                //                    alertView.clickedButtonAction = { index in
                //                        alertView.dismiss()
                //                    }
                //                    alertView.messageLabel.text = "\(responseValue)\n"
                //                    alertView.show()
                //                }else{
                //                    alertView.clickedButtonAction = { index in
                //                        alertView.dismiss()
                //                    }
                //                    alertView.messageLabel.text = "\(responseValue)\n"
                //                    alertView.show()
                //                }
            }
        }
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductInfoImageCollectionViewCell", for: indexPath) as? ProductInfoImageCollectionViewCell {
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

//
//  OrderViewController.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/6.
//

import UIKit

class OrderViewController: BaseViewController {
    @IBOutlet weak var productTitleStackView: UIStackView!
    @IBOutlet weak var productInfoStackView: UIStackView!
    @IBOutlet weak var lbProductTtile: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbSalePrice: UILabel!
    @IBOutlet weak var lbProductDescription: UILabel!
    @IBOutlet weak var lbProductType: UILabel!
    @IBOutlet weak var lbTradeType: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbTradeMethod: UILabel!
    @IBOutlet weak var lbTradeItem: UILabel!
    @IBOutlet weak var orderViewCollectionView: UICollectionView!
    @IBOutlet weak var orderViewPC: UIPageControl!
    var product : ProductModel!
    var orderImages = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orderViewCollectionView.delegate = self
        self.orderViewCollectionView.dataSource = self
        self.orderViewCollectionView.isPagingEnabled = true
        
        setText()
        
        //設定換頁控制器有幾頁
        orderViewPC.numberOfPages = orderImages.count
        //起始在第0頁
        orderViewPC.currentPage = 0;
        // Do any additional setup after loading the view.
    }
    
    private func setText(){
        if(Global.isOnline){
            lbProductTtile.text = "\(product.title)"
            lbProductType.text = "分類 : \(product.type)/\(product.type1)/\(product.type2)"
            lbTradeMethod.text = "交易方式 : \(product.rentMethod)"
            lbAmount.text = "數量 : \(product.amount)"
            lbProductDescription.text = "\(product.description)"
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
            var tradeTypeText = "模式 : "
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
                orderImages.append(product.pics[index].path)
            }
        }
    }
}
extension OrderViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        orderImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductInfoImageCollectionViewCell", for: indexPath) as? ProductInfoImageCollectionViewCell {
            cell.configure(with: orderImages[indexPath.row])
            
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
        self.orderViewPC.currentPage = Int(roundedIndex)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        orderViewPC.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        orderViewPC.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
extension OrderViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = orderViewCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}


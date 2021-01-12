//
//  PageTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/17.
//

import UIKit
protocol PageTableViewCellDelegate : AnyObject{
    func cellClick(indexPath: IndexPath,products:[ProductModel])
}
class PageTableViewCell: UITableViewCell {
    var myCollectionView:UICollectionView?
    @IBOutlet weak var pageCollectionView:UICollectionView!
    @IBOutlet weak var lbMainPageTitle: UILabel!
    @IBOutlet weak var lbMainPageHint: UILabel!
    weak var tableViewCellDelegate:PageTableViewCellDelegate?
    var products = [ProductModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.register(UINib(nibName: "PageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PageCollectionViewCell")
        
        // 設定字型有底線
        let attributedString = NSMutableAttributedString.init(string: "查看更多 >")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        lbMainPageHint.attributedText = attributedString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
extension PageTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.pageCollectionViewCell.rawValue, for: indexPath) as? PageCollectionViewCell {
            cell.configure(with: products[indexPath.row])
            return cell;
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tableViewCellDelegate?.cellClick(indexPath: indexPath,products :self.products)
    }
    
}
extension PageTableViewCell: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            return CGSize(width: 200, height: 255)
//        }
}

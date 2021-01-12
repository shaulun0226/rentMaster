//
//  MainPageTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/16.
//

import UIKit
protocol MainPageTableViewCellDelegate : AnyObject{
    func cellClick(indexPath: IndexPath,products:[ProductModel])
}
class MainPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pageCollectionView:UICollectionView!
    @IBOutlet weak var lbMainPageTitle: UILabel!
    @IBOutlet weak var lbMainPageHint: UILabel!
    weak var tableViewCellDelegate:MainPageTableViewCellDelegate?
    
    var products = [ProductModel]()
    
    //設定樣式
    @IBInspectable var cornerRadius: CGFloat = 20
    //
    var shadowOffsetWidth: Int = 5
    var shadowOffsetHeight: Int = 5
    var shadowColor: UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var shadowOpacity: Float = 5
    //
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 5//調整y起點
            frame.origin.x += 5//調整x起點
            frame.size.height -= 15//調整高度
            frame.size.width -= 2 * 5
            super.frame = frame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.reloadData()
        pageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.mainPageCollectionViewCell.rawValue)
        
        // 設定字型有底線
        let attributedString = NSMutableAttributedString.init(string: "查看更多 >")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        lbMainPageHint.attributedText = attributedString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension MainPageTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.mainPageCollectionViewCell.rawValue, for: indexPath) as? MainPageCollectionViewCell {
            cell.configure(with: products[indexPath.row])
            cell.addShadow(backgroundColor: UIColor(named: "card-1") ?? .white, cornerRadius: 5, shadowRadius: 5, shadowOpacity: 0.7, shadowPathInset: (dx: 16, dy: 6), shadowPathOffset: (dx: 2, dy: 2))
            return cell;
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tableViewCellDelegate?.cellClick(indexPath: indexPath,products :self.products)
    }
}

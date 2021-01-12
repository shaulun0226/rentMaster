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
class PageTableViewCell: BaseTableViewCell {
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
//    @IBInspectable var cornerRadius: CGFloat = 20
//    //
//    var shadowOffsetWidth: Int = 5
//    var shadowOffsetHeight: Int = 5
//    var shadowColor: UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    var shadowOpacity: Float = 0.4
    //
//    override open var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set (newFrame) {
//            var frame =  newFrame
//            frame.origin.y += 5//調整y起點
//            frame.origin.x += 5//調整x起點
//            frame.size.height -= 15//調整高度
//            frame.size.width -= 2 * 5
//            super.frame = frame
//        }
//    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //設定cell下緣
        //        let bottomSpace = 10.0 //
        //        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top:0, left: 0, bottom: CGFloat(bottomSpace), right: 0))
        
        
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        //
        layer.masksToBounds = false//超過框線的地方會被裁掉
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
//        //            layer.borderWidth = 1.0
        //            layer.borderColor = UIColor.black.cgColor
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 200, height: 255)
        }
}

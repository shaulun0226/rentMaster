//
//  MainPageTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/16.
//

import UIKit

class MainPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var lbMainPageTitle: UILabel!
    @IBOutlet weak var lbMainPageHint: UILabel!
    
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
        //設定cell下緣
        //        let bottomSpace = 10.0 //
        //        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top:0, left: 0, bottom: CGFloat(bottomSpace), right: 0))
        
        
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        //
        //            layer.masksToBounds = false//超過框線的地方會被裁掉
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        //            layer.borderWidth = 1.0
        //            layer.borderColor = UIColor.black.cgColor
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MainPageProductCell")
        
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
    //    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
    //        collectionView.delegate = dataSourceDelegate
    //        collectionView.dataSource = dataSourceDelegate
    //        collectionView.tag = row
    //        collectionView.reloadData()
    //    }
}
extension MainPageTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageProductCell", for: indexPath) as? MainPageProductCell {
            cell.configure(with: products[indexPath.row])
            return cell;
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

//
//  ProductInfoImageCollectionViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/19.
//

import UIKit

class ProductInfoImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    static let width = floor(UIScreen.main.bounds.width)


    override func awakeFromNib() {
        super.awakeFromNib()
        widthConstraint.constant = Self.width
        // Initialization code
    }
    func configure(with imgUrl: String) {
        if (!imgUrl.contains("http")){
            self.productImage.image = UIImage(named: "monsterhunter")
            return
        }
        //防止url內有中文 先進行編碼
        let newUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let articleUrl = URL(string: newUrl)
        self.productImage.kf.indicatorType = .activity
        self.productImage.kf.setImage(with: articleUrl,placeholder: UIImage(named: "camera.png"))
//        let url = URL(string: imgUrl)
//        // load img
//        let session = URLSession(configuration: .default)
//
//        // 下載資料後存檔在加目錄中的tmp目錄下，完整路徑在location參數中
//        guard (url != nil) else {
//            return
//        }  //Kingfisher
//        let dnTask = session.downloadTask(with: url!) { (location, response, error) in
//                    // 注意此 block 區段已在另外一個執行緒
//                    if error == nil, let location = location {
//                        do {
//                            // 從存檔中讀取資料
//                            if let data = try? Data(contentsOf: location) {
//                                DispatchQueue.main.sync {
//                                    self.productImage.image = UIImage(data: data)
//                                }
//                            }
//                        }
//                    } else {
//                        print("讀取資料錯誤")
//                    }
//                }
//                // 開始執行
//                dnTask.resume()
    }
    
    func configureWithImg(with image:UIImage) {
        self.productImage.image = image
    }
}

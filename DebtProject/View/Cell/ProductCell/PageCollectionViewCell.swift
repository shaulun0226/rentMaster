//
//  PageCollectionViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/17.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbState: UILabel!
    func configure(with model: ProductModel) {
        self.lbTitle.text = model.title
        var saleType = [String]()
        if(model.isSale){
            saleType.append("販售")
        }
        if(model.isRent){
            saleType.append("租借")
        }
        if(model.isExchange){
            saleType.append("交換")
        }
        var saleTypeText = ""
        for index in 0..<saleType.count {
            if(index==saleType.count-1){
                saleTypeText += "\(saleType[index])"
            }else{
                saleTypeText += "\(saleType[index])/"
            }
        }
        self.lbState.text = saleTypeText
        //放照片
        if model.pics.count == 0 {
            self.imgGame.image = UIImage(named: "monsterhunter")
            return
        }
        //        self.img.image = UIImage(named: model.pics[0])
        let imgUrl = model.pics[0].path
        if (!imgUrl.contains("http")){
            self.imgGame.image = UIImage(named: "monsterhunter")
            return
        }
        //防止url內有中文 先進行編碼
        let newUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let articleUrl = URL(string: newUrl)
        self.imgGame.kf.indicatorType = .activity
        self.imgGame.kf.setImage(with: articleUrl,placeholder: UIImage(named: "camera.png"))
//        let url = URL(string: imgUrl)
//        // load img
//        let session = URLSession(configuration: .default)
//
//        // 下載資料後存檔在加目錄中的tmp目錄下，完整路徑在location參數中
//        guard (url != nil) else {
//            return
//        }
//        let dnTask = session.downloadTask(with: url!) { (location, response, error) in
//                    // 注意此 block 區段已在另外一個執行緒
//                    if error == nil, let location = location {
//                        do {
//                            // 從存檔中讀取資料
//                            if let data = try? Data(contentsOf: location) {
//                                DispatchQueue.main.sync {
//                                    self.imgGame.image = UIImage(data: data)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


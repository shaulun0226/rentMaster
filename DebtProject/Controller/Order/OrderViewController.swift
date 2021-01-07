//
//  OrderViewController.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/6.
//

import UIKit
import SwiftyJSON

class OrderViewController: BaseViewController {
    //商品資訊區
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
    //買/賣家資訊
    var user : UserModel!
    var orderOwner : UserModel!
    //留言板
    @IBOutlet weak var sendNoteView: DesignableView!
    @IBOutlet weak var txSend: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    var notes = [NoteModel]()
    @IBOutlet weak var NoteTableView: UITableView!
    @IBOutlet weak var noteTableViewHeight: NSLayoutConstraint!
    //變數
    var order : OrderModel!
    var orderImages = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orderViewCollectionView.delegate = self
        self.orderViewCollectionView.dataSource = self
        self.orderViewCollectionView.isPagingEnabled = true
        
        setText()
        //商品留言板
        setSendView()
        //設定換頁控制器有幾頁
        orderViewPC.numberOfPages = orderImages.count
        //起始在第0頁
        orderViewPC.currentPage = 0;
        // Do any additional setup after loading the view.
        NoteTableView.delegate = self
        NoteTableView.dataSource = self
        NoteTableView.rowHeight = UITableView.automaticDimension
        NoteTableView.estimatedRowHeight = UITableView.automaticDimension
        NetworkController.instance().getUserInfo{
            [weak self] (reponseValue,isSuccess)in
            guard let weakSelf = self else{return}
            if(isSuccess){
                let json = JSON(reponseValue)
                weakSelf.user =  weakSelf.parseUser(json: json)
            }else{
                print("沒拿到使用者資訊")
            }
        }
        NetworkController.instance().getUserBasicInfo(userId: order.p_ownerId){
            [weak self] (reponseValue,isSuccess)in
            guard let weakSelf = self else{return}
            if(isSuccess){
                let json = JSON(reponseValue)
                weakSelf.orderOwner = weakSelf.parseUser(json: json)
            }else{
                print("沒拿到使用者資訊")
            }
        }
    }
    
    //MARK: - 解析JSON
    private func parseNote(json:JSON)->NoteModel{
        let id = json["id"].string ?? ""
        let orderId = json["orderId"].string ?? ""
        let senderId = json["senderId"].string ?? ""
        let senderName = json["senderName"].string ?? ""
        let message = json["message"].string ?? ""
        let createTime = json["createTime"].string ?? ""
        print("id\(id),orderid\(orderId),senderId:\(senderId),senderName\(senderName),message\(message)createTime\(createTime)")
        return NoteModel.init(id: id, orderId: orderId, senderId: senderId, senderName: senderName, message: message, createTime: createTime)
    }
    private func parseUser(json:JSON)->UserModel{
        let id = json["id"].string ?? ""
        let email = json["email"].string ?? ""
        let name = json["name"].string ?? ""
        let nickName = json["nickName"].string ?? ""
        let phone = json["phone"].string ?? ""
        let address = json["address"].string ?? ""
        return UserModel.init(id: id, email: email, name: name, nickName: nickName, phone: phone, address: address, products: [], wishItems: [])
    }
    private func setText(){
        if(Global.isOnline){
            lbProductTtile.text = "\(order.p_Title)"
            lbProductType.text = "分類 : \(order.p_Type)/\(order.p_Type1)/\(order.p_Type2)"
            lbTradeMethod.text = "交易方式 : \(order.p_RentMethod)"
            lbAmount.text = "數量 : \(order.p_tradeCount)"
            lbProductDescription.text = "\(order.p_Desc)"
            var tradeType = [String]()
            var price = [String]()
            
            switch order.tradeMethod {
            case 0://租
                tradeType.append("租借")
                price.append("押金 : \(order.p_Deposit)元")
                price.append("租金 : \(order.p_Rent)元/日")
            case 1://買
                tradeType.append("販售")
                price.append("售價 : \(order.p_salePrice)元")
            case 2://換
                tradeType.append("交換")
            //                price.append("權重 : \(order.productId)")
            default:
                print("沒找到交易方式")
                tradeType.append("")
                price.append("")
            }
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
            lbAddress.text = "商品地區 : \(order.p_Address)"
            //            for index in 0..<order.pics.count{
            //                orderImages.append(order.pics[index].path)
            //            }
        }
    }
    //MARK:-留言板畫面
    //設定留言板畫面
    private func setSendView(){
        let layer = CAGradientLayer();
        layer.frame = sendNoteView.bounds;
        layer.colors = Global.BACKGROUND_COLOR as [Any]
        layer.startPoint = CGPoint(x: 0,y: 0.5);
        layer.endPoint = CGPoint(x: 1,y: 0.5);
        sendNoteView.layer.insertSublayer(layer, at: 0)
        //設定KVO
        NoteTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        txSend.text = "請輸入留言內容"
        txSend.textColor = UIColor.lightGray
        txSend.delegate = self
    }
    //利用kvo設定tableview高度隨內容改變
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        NoteTableView.layer.removeAllAnimations()
        noteTableViewHeight.constant = NoteTableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    //傳送
    @IBAction func btnSendClick(_ sender: Any) {
        if(txSend.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            return
        }
        let messgae = txSend.text!
        NetworkController.instance().addNote(orderId: order.id, message: messgae){
            [weak self] (responseValue, isSuccess)in
            guard let weakSelf = self else{return}
            if(isSuccess){
                let json = JSON(responseValue)
                print(json)
                weakSelf.notes.append(weakSelf.parseNote(json: json))
                weakSelf.txSend.text = ""
                weakSelf.NoteTableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
//MARK:-留言板
extension OrderViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = NoteTableView.dequeueReusableCell(withIdentifier: TableViewCell.noteTableViewCell.rawValue,for:indexPath) as? NoteTableViewCell{
            cell.conficgure(with: notes[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
extension OrderViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "請輸入留言內容"
            textView.textColor = UIColor.lightGray
        }
    }
}
//MARK:- 圖片collectionVIew
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


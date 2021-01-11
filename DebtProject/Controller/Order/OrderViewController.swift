//
//  OrderViewController.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/6.
//

import UIKit
import SwiftyJSON
import SwiftAlertView

class OrderViewController: BaseViewController {
    //畫面
    @IBOutlet weak var orderScrollView: UIScrollView!
    
    //商品資訊區
    @IBOutlet weak var productTitleStackView: UIStackView!
    @IBOutlet weak var productInfoStackView: UIStackView!
    @IBOutlet weak var lbProductTtile: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbSalePrice: UILabel!
    @IBOutlet weak var lbProductDescription: UILabel!
    @IBOutlet weak var lbProductType: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbRentMethod: UILabel!
    @IBOutlet weak var lbTradeMethod: UILabel!
    @IBOutlet weak var orderViewPC: UIPageControl!
    //訂單狀態
    @IBOutlet weak var lbOrderState: UILabel!
    @IBOutlet weak var lbOrderDate: UILabel!
    @IBOutlet weak var lbOrderTime: UILabel!
    //買/賣家資訊
    @IBOutlet weak var lbOrderOwnerInfo: UILabel!
    var orderOwnerInfo :String?
    var customerId : String?
    var user : UserModel!
    var orderOwner : UserModel!
    @IBOutlet weak var lbOwnerName: UILabel!
    @IBOutlet weak var lbOwnerEmail: UILabel!
    @IBOutlet weak var lbOwnerPhone: UILabel!
    @IBOutlet weak var lbOwnerAddress: UILabel!
    //留言板
    @IBOutlet weak var sendNoteView: DesignableView!
    @IBOutlet weak var txSend: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    var notes = [NoteModel]()
    @IBOutlet weak var NoteTableView: UITableView!
    @IBOutlet weak var noteTableViewHeight: NSLayoutConstraint!
    //變數
    var order : OrderModel!
    
    //照片
    var orderImages = [String]()
    @IBOutlet weak var orderViewCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orderViewCollectionView.delegate = self
        self.orderViewCollectionView.dataSource = self
        self.orderViewCollectionView.isPagingEnabled = true
        //設定照片
        setImage()
        //設定商品文字
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
        //拿買家資訊
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
        //拿訂單
        NetworkController.instance().getUserBasicInfo(userId: self.customerId ?? ""){
            [weak self] (reponseValue,isSuccess)in
            guard let weakSelf = self else{return}
            if(isSuccess){
                let json = JSON(reponseValue)
                weakSelf.orderOwner = weakSelf.parseUser(json: json)
                guard let orderOwner = weakSelf.orderOwner else {
                    return
                }
                weakSelf.setOrderOwnerInfo(orderOwner: orderOwner)
            }else{
                print("沒拿到使用者資訊")
            }
        }
        
        //設定觀察鍵盤
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //設定按外面會把鍵盤收起(有可能會手勢衝突)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
    }
    //MARK:- 設定
    //照片
    func setImage(){
        for index in 0..<order.pics.count{
            let path = order.pics[index].path
            orderImages.append(path)
        }
        DispatchQueue.main.async {
            self.orderViewCollectionView.reloadData()
        }
    }
    //文字
    private func setText(){
        if(Global.isOnline){
            lbProductTtile.text = "\(order.p_Title)"
            lbProductType.text = "分類 : \(order.p_Type)/\(order.p_Type1)/\(order.p_Type2)"
            lbRentMethod.text = "交貨方式 : \(order.p_RentMethod)"
            
            lbAmount.text = "交易數量 : \(order.tradeQuantity)"
            lbOrderOwnerInfo.text = orderOwnerInfo ?? ""
            lbProductDescription.text = "\(order.p_Desc)"
            var price = [String]()
            
            switch order.tradeMethod {
            case 0://租
                lbTradeMethod.text = "交易方式 : 租借"
                price.append("押金 : \(order.p_Deposit)元")
                price.append("租金 : \(order.p_Rent)元/日")
            case 1://買
                lbTradeMethod.text = "交易方式 : 購買"
                price.append("售價 : \(order.p_salePrice)元")
            case 2://換
                lbTradeMethod.text = "交易方式 : 交換"
                for index in 0..<order.orderExchangeItems.count{
                    price.append("\(order.orderExchangeItems[index].exchangeItem)*\(order.orderExchangeItems[index].packageQuantity)")
                }
            //                price.append("權重 : \(order.productId)")
            default:
                print("沒找到交易方式")
                price.append("")
            }
            var priceText = ""
            for index in 0..<price.count{
                if(index==price.count-1){
                    priceText += "\(price[index])"
                }else{
                    priceText += "\(price[index])\n"
                }
            }
            lbOrderState.text = order.status
            lbSalePrice.text = priceText
            lbAddress.text = "商品地區 : \(order.p_Address)"
            //            for index in 0..<order.pics.count{
            //                orderImages.append(order.pics[index].path)
            //            }
        }
    }
    //MARK:- 根據鍵盤出現移動螢幕
    @objc override func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
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
    private func setOrderOwnerInfo(orderOwner:UserModel){
        lbOwnerName.text = "稱呼 : \(orderOwner.name)"
        lbOwnerEmail.text = "Email : \(orderOwner.email)"
        lbOwnerPhone.text = "聯絡電話 : \(orderOwner.phone)"
        lbOwnerAddress.text = "地區 : \(orderOwner.address)"
    }
    
    //MARK: - 訂單狀態
    @IBAction func nextStateClick(_ sender: Any) {
        NetworkController.instance().changeOrdersStatus(id: order.id, status: order.status){
            [weak self] (reponseValue,isSuccess) in
            guard let weakSelf = self else{return}
            if(isSuccess){
                let json = JSON(reponseValue)
                let dateTime = json["dateTime"].string ?? ""
                let newStatus = json["newStatus"].string ?? ""
                weakSelf.lbOrderState.text = newStatus
                let dateTimeArr = dateTime.split(separator: "T")
                if(dateTimeArr.count<2){
                    weakSelf.lbOrderDate.text = ""
                    weakSelf.lbOrderTime.text = ""
                    return
                }
                weakSelf.lbOrderDate.text = String(dateTimeArr[0])
                weakSelf.lbOrderTime.text = String(dateTimeArr[1])
            }else{
                let alertView = SwiftAlertView(title: "", message: "狀態錯誤\n", delegate: nil, cancelButtonTitle: "確定")
                alertView.clickedCancelButtonAction = {
                    alertView.dismiss()
                }
                alertView.messageLabel.textColor = .white
                alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
                alertView.button(at: 1)?.backgroundColor = UIColor(named: "Button")
                alertView.backgroundColor = UIColor(named: "Alert")
                alertView.buttonTitleColor = .white
                alertView.show()
            }
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
    
    //點擊空白收回鍵盤
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    //傳送留言
    @IBAction func btnSendClick(_ sender: Any) {
        self.view.endEditing(true)
        if(txSend.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
            return
        }
        let messgae = txSend.text!
        NetworkController.instance().addNote(orderId: order.id, message: messgae){
            [weak self] (responseValue, isSuccess)in
            guard let weakSelf = self else{return}
            if(isSuccess){
                let json = JSON(responseValue)
                weakSelf.notes.append(weakSelf.parseNote(json: json))
                DispatchQueue.main.async {
                    weakSelf.txSend.text = ""
                    weakSelf.NoteTableView.reloadData()
                    weakSelf.txSend.text = "請輸入留言內容"
                    weakSelf.txSend.textColor = UIColor.lightGray
                }
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
        //按下鍵盤時螢幕往上滑
        //        self.orderScrollView.setContentOffset(CGPoint(x: 0, y: Global.screenSize.height*0.35), animated: true)
        //        descIconStack.isHidden = true
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        //結束編輯時螢幕往下滑
        //        self.orderScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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


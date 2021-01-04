//
//  MakeOrderViewController.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/2.
//

import UIKit
import SwiftyJSON
import SwiftAlertView



class MakeOrderViewController: BaseViewController {
    
    var product:ProductModel!
    @IBOutlet weak var exchangeAmountView: DesignableView!
    //tavleView
    @IBOutlet weak var exchangeListTableView: UITableView!
    var cellCount = 1
    var exchangeList = [String]()
    //picker按鈕
    var currentButton:UIButton!
    @IBOutlet weak var btnTradeAmount: UIButton!
    @IBOutlet weak var btnTradeType: UIButton!
    //popoverview榜定
    @IBOutlet var selectView: UIView!
    //popover裡的picker榜定
    @IBOutlet weak var pickerView: UIPickerView!
    //設定popover出來的高度
    let popoverViewHeight = CGFloat(256)
    var pickerList = [String]()
    //要傳出去的參數
    var tradeMethod:Int?
    var tradeItem = [String]()
    var tradeQuantity:Int?//交易數量
    //賣家資訊
    var user:UserModel!
    @IBOutlet weak var lbSellerName: UILabel!
    @IBOutlet weak var lbSellerEmail: UILabel!
    @IBOutlet weak var lbSellerPhone: UILabel!
    @IBOutlet weak var lbSellerLocation: UILabel!
    //tableView
    @IBOutlet weak var exchangeListTableViewHeight: NSLayoutConstraint!
    //商品區
    @IBOutlet weak var lbProductAmount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        exchangeListTableView.delegate = self
        exchangeListTableView.dataSource = self
        exchangeListTableView.backgroundColor = .clear
        //設定KVO
        exchangeListTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        //設定exchangeList資料--從userAPi拿
        
        self.exchangeListTableView.allowsSelection = true
        exchangeListTableView.reloadData()
        //設定pickview
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        //        //設定navigation bar
        //        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
        //        //設定barItem 的顏色
        //        self.navigationController?.navigationBar.tintColor = .white
        //        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //        let layer = Global.setBackgroundColor(view);
        //        view.layer.insertSublayer(layer, at: 0)
        //連api拿到賣家資訊
        if(Global.isOnline){
            NetworkController.instance().getUserBasicInfo(userId: product.userId){
                [weak self] (responseValue,isSuccess) in
                guard let weakSelf = self else {return}
                if(isSuccess){
                    let jsonArr = JSON(responseValue)
                    weakSelf.parseUser(jsonArr: jsonArr)
                    weakSelf.lbSellerName.text = "稱呼:\(weakSelf.user.nickName)"
                    weakSelf.lbSellerEmail.text = "Email:\(weakSelf.user.email)"
                    weakSelf.lbSellerPhone.text = "聯絡電話:\(weakSelf.user.phone)"
                    weakSelf.lbSellerLocation.text = "地區:\(weakSelf.product.address)"
                }else{
                    weakSelf.lbSellerName.text = "稱呼:測試"
                    weakSelf.lbSellerEmail.text = "Email:test"
                    weakSelf.lbSellerPhone.text = "聯絡電話:0000000000"
                    weakSelf.lbSellerLocation.text = "地區:dng"
                }
            }
        }
        lbProductAmount.text = "剩餘數量:\(product.amount)"
    }
    private func parseUser(jsonArr:JSON){
        let id = jsonArr["id"].string ?? ""
        let email = jsonArr["email"].string ?? ""
        let name = jsonArr["name"].string ?? ""
        let nickName = jsonArr["nickName"].string ?? ""
        let phone = jsonArr["phone"].string ?? ""
        let address = jsonArr["address"].string ?? ""
        self.user = UserModel.init(id: id, email: email, name: name, nickName: nickName, phone: phone, address: address, products: [])
    }
    override func viewWillAppear(_ animated: Bool) {
        //加入子視圖(在這裡是要彈出的popoverview)
        view.addSubview(selectView)
        /*在所有有繼承自 UIView 的 object 中都會有一個名為 “translatesAutoresizingMaskIntoConstraints”
         的 property，這 property 的用途是告訴 iOS自動建立放置位置的約束條件，而第一步是須明確告訴它不要這樣做，因此需設為false。*/
        selectView.translatesAutoresizingMaskIntoConstraints = false
        //設定子試圖畫面高度，一定要加.isActive = true 不然排版會沒有用
        selectView.heightAnchor.constraint(equalToConstant: popoverViewHeight).isActive = true
        //設定左右邊界(左邊要是-10)
        selectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        selectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //先設定這個畫面在螢幕bottom下方height高度位置，等等調整這個數值就可以達到由下往上滑出的效果
        //設為變數等等才方便調整
        let constraint = selectView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: popoverViewHeight)
        //設定constraint id
        constraint.identifier = "bottom"
        constraint.isActive = true
        //設定圓角
        selectView.layer.cornerRadius = 10
        super.viewWillAppear(animated)
    }
    //點擊空白收回鍵盤
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    //利用kvo設定tableview高度隨內容改變
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        exchangeListTableView.layer.removeAllAnimations()
        exchangeListTableViewHeight.constant = exchangeListTableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    //設定彈出的方法 ture就顯示false就藏在下面
    func displayPicker(_ show:Bool){
        for c in view.constraints{
            //判斷constraints id
            if(c.identifier == "bottom"){
                //判斷彈出
                c.constant = (show) ? -10 : popoverViewHeight
                break
            }
        }
        //設定動畫
        UIView.animate(withDuration: 0.5){
            //立即更新佈局
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func pickerDoneClick(_ sender: Any) {
        let title  = pickerList[pickerView.selectedRow(inComponent: 0)]
        switch currentButton {
        case btnTradeAmount:
            tradeQuantity = Int(title)
            cellCount = Int(title) ?? 1
            exchangeListTableView.reloadData()
        case btnTradeType:
            switch title{
            case "購買":
                tradeMethod = 1
                self.exchangeListTableView.isHidden = true
            case "租借":
                tradeMethod = 0
                self.exchangeListTableView.isHidden = true
            case "交換":
                tradeMethod = 2
                self.exchangeListTableView.isHidden = false
            default:
                tradeMethod = 3
                self.exchangeListTableView.isHidden = true
            }
        default:
            print("沒篩到")
        }
        currentButton.setTitle(title, for: .normal)
        //關閉pickerview
        displayPicker(false)
    }
    @IBAction func pickerCancelClick(_ sender: Any) {
        //關閉popoverview
        displayPicker(false)
    }
    
    @IBAction func tradeAmountClick(_ sender: Any) {
        guard let product = product else{return}
        currentButton = btnTradeAmount
        pickerList.removeAll()
        //設定能買幾個產品
        for index in 1...product.amount{
            pickerList.append("\(index)")
        }
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
        
    }
    @IBAction func tradeTypeClick(_ sender: Any) {
        guard let product = product else{return}
        currentButton = btnTradeType
        pickerList.removeAll()
        //設定購買方法
        if(product.isSale){
            pickerList.append("購買")
        }
        if(product.isRent){
            pickerList.append("租借")
        }
        if (product.isExchange) {
            pickerList.append("交換")
        }
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmClick(_ sender: Any) {
        let alertView = SwiftAlertView(title: "", message: "", delegate: nil, cancelButtonTitle: "確定")
        alertView.messageLabel.textColor = .white
        alertView.messageLabel.font = UIFont.systemFont(ofSize: 30)
        alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
        alertView.backgroundColor = UIColor(named: "Alert")
        alertView.buttonTitleColor = .white
        alertView.clickedButtonAction = { index in
            alertView.dismiss()
        }
        guard let tradeQuantity = tradeQuantity else {
            alertView.messageLabel.text = "請選擇交易數量"
            alertView.show()
            return
        }
        guard let tradeMethod = tradeMethod else {
            alertView.messageLabel.text = "請選擇交易方式"
            alertView.show()
            return
        }
        
        if(tradeMethod==2){
            for index in 0..<cellCount{
                if let cell = exchangeListTableView.cellForRow(at: IndexPath(item: index, section: 0)) as? MakeOrderTableViewCell{
                    let tradeItemName = cell.btnChangeItem.titleLabel?.text ?? ""
                    if(tradeItemName.elementsEqual("請選擇交換物")){
                        alertView.messageLabel.text = "交換物還沒有選唷"
                        alertView.show()
                        return
                    }
                    tradeItem.append(cell.btnChangeItem.titleLabel?.text ?? "")
                }
            }
            if(tradeItem.count==0){
                alertView.messageLabel.text = "請選擇交換物"
                alertView.show()
                return
            }
        }else{
            
        }
        print("下訂單id:\(product.id),交易方式:\(tradeMethod),交易數量:\(tradeQuantity)")
        NetworkController.instance().addOrder(productId: product.id, tradeMethod: tradeMethod, tradeItem: "", tradeQuantity: tradeQuantity){
            [weak self] (responseValue,isSuccess) in
            guard let weakSelf = self else{return}
            alertView.messageLabel.text = responseValue
            if(isSuccess){
                alertView.clickedButtonAction = {index in
                    if let mainView = Global.mainStoryboard.instantiateViewController(identifier: MainStoryboardController.mainPageViewController.rawValue) as? MainPageViewController{
                        weakSelf.dismiss(animated: true, completion: nil)
                        mainView.modalPresentationStyle = .automatic
//                        weakSelf.present(mainView, animated: true, completion: nil)
//                        weakSelf.showDetailViewController(mainView, sender: nil)
                    }
                }
            }else{
                alertView.clickedButtonAction = {index in
                    alertView.dismiss()
                }
            }
            alertView.show()
        }
    }
}
extension MakeOrderViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50));
        view.backgroundColor = .clear;
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width-15, height: view.frame.height-4));
        view.addSubview(label);
        label.text = "交換物:"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        return view;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = exchangeListTableView.dequeueReusableCell(withIdentifier: TableViewCell.makeOrderTableViewCell.rawValue) as? MakeOrderTableViewCell{
            cell.makeOrderTableViewCellDelegate = self
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}
extension MakeOrderViewController:MakeOrderTableViewCellDelegate{
    func changeItemClick(btnChangeItem: UIButton) {
        currentButton = btnChangeItem
        pickerList.removeAll()
        //設定購買方法從user拿
        
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
}
extension MakeOrderViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    //設定有幾個bar可以滾動
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //設定bar的內容有幾項
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    //設定bar的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row]
    }
    //調整pickerview文字
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Helvetica Neue", size: 25)
        label.text =  pickerList[row]
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }
    //設定每個選項的高度
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        50
    }
}

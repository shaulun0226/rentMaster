//
//  AddProductViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/20.
//

import UIKit
import TLPhotoPicker
import SwiftAlertView
import SwiftyJSON

class AddProductViewController: BaseViewController {
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var lbProductDescription: UILabel!
    @IBOutlet weak var lbProductAmount: UILabel!
    @IBOutlet weak var lbProductLocation: UILabel!
    @IBOutlet weak var lbProductType: UILabel!
    @IBOutlet weak var lbProductType1: UILabel!
    @IBOutlet weak var lbProductType2: UILabel!
    @IBOutlet weak var tfProductTitle: UnderLineTextField!//產品名
    @IBOutlet weak var tfProductDescription: UnderLineTextField!//產品描述
    @IBOutlet weak var tfProductAmount: UnderLineTextField!//產品數量
    @IBOutlet weak var btnProductCity: UIButton!
    @IBOutlet weak var btnProductRegion: UIButton!
    @IBOutlet weak var btnProductType: UIButton!
    @IBOutlet weak var btnProductType2: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnExchangeAmount: UIButton!
    @IBOutlet weak var btnProductType1: UIButton!
    //選擇交易方式
    var btnSaleSelected:Bool = false
    var btnRentSelected:Bool = false
    var btnExchangeSelected:Bool = false
    @IBOutlet weak var btnSale: UIButton!
    @IBOutlet weak var btnRent: UIButton!
    @IBOutlet weak var btnExchange: UIButton!
    //
    @IBOutlet weak var depositView: DesignableView!
    @IBOutlet weak var rentDayView: DesignableView!
    @IBOutlet weak var salePriceView: DesignableView!
    @IBOutlet weak var exchangeAmountView: DesignableView!
    @IBOutlet weak var exchangeAmountView2: DesignableView!
    @IBOutlet weak var exchangeWorthView: DesignableView!
    @IBOutlet weak var tfProductDeposit: UnderLineTextField!//產品押金
    @IBOutlet weak var tfProductRent: UnderLineTextField!//產品租金
    @IBOutlet weak var tfProductPrice: UnderLineTextField!//產品售價
    //新增商品模式按鈕的stackView
    @IBOutlet weak var addProductButtonStackView: UIStackView!
    
    var selectedAssets = [TLPHAsset]()
    var currentButton:UIButton!
    var productTitle:String!
    var productDescription:String!
    var productIsSale = false
    var productIsRent = false
    var productIsExchange = false
    var productExangeAmount:Int!
    var productDeposit:Int!
    var productRent:Int!
    var productSalePrice:Int!
    var productRentMethod:String!
    var productCity:String!
    var productRegion:String!
    var productAmount:Int!
    var productType:String!
    var productType1:String!
    var productType2:String!
    var productImages = [UIImage]()
    var pickerList = [String]()
    //上傳照片的collectionview
    @IBOutlet weak var addProductImageCV: UICollectionView!
    var tradeItems = [String]()

    //popoverview榜定
    @IBOutlet var selectView: UIView!
    //popover裡的picker榜定
    @IBOutlet weak var pickerView: UIPickerView!
    //設定popover出來的高度
    let popoverViewHeight = CGFloat(256)
    var location:String?
    var host:String?
    var type:String?
    //編輯模式區
    var isModifyType = false
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnModify: UIButton!
    var product:ProductModel!
    var oldPics = [String]()
    //編輯模式按鈕的stackView
    @IBOutlet weak var modifyButtonStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isModifyType){
            addProductButtonStackView.isHidden = true
            modifyButtonStackView.isHidden = false
            setModify(isModify: false)
            setTextFieldUnderLine(size: CGFloat(0))
            putInProductInfo()
        }else{
            addProductButtonStackView.isHidden = false
            modifyButtonStackView.isHidden = true
            setModify(isModify: true)
        }
        addProductImageCV.delegate = self
        addProductImageCV.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        //設定按外面會把鍵盤收起
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
        
    }
    private func putInProductInfo(){
        tfProductTitle.text = product.title
        tfProductRent.text = String(product.rent)
        tfProductAmount.text = String(product.amount)
        tfProductDeposit.text = String(product.deposit)
        tfProductPrice.text = String(product.salePrice)
        tfProductDescription.text = String(product.description)
        btnSend.setTitle(product.rentMethod, for: .normal)
        if(product.isSale){
            btnSaleSelected = true
            btnSale.setBackgroundImage(UIImage(systemName: "largecircle.fill.circle"), for:.normal)
            btnSale.tintColor = UIColor(named: "Button")
        }else{
            btnSaleSelected = false
            btnSale.setBackgroundImage(UIImage(systemName: "circle"), for:.normal)
            btnSale.tintColor = .darkGray
        }
        salePriceView.isHidden = !btnSaleSelected
        if(product.isRent){
            btnRentSelected = true
            btnRent.setBackgroundImage(UIImage(systemName: "largecircle.fill.circle"), for:.normal)
            btnRent.tintColor = UIColor(named: "Button")
        }else{
            btnRentSelected = false
            btnRent.setBackgroundImage(UIImage(systemName: "circle"), for:.normal)
            btnRent.tintColor = .darkGray
        }
        depositView.isHidden = !btnRentSelected
        rentDayView.isHidden = !btnRentSelected
        if(product.isExchange){
            btnExchangeSelected = true
            btnExchange.setBackgroundImage(UIImage(systemName: "largecircle.fill.circle"), for:.normal)
            btnExchange.tintColor = UIColor(named: "Button")
        }else{
            btnExchangeSelected = false
            btnExchange.setBackgroundImage(UIImage(systemName: "circle"), for:.normal)
            btnExchange.tintColor = .darkGray
        }
        exchangeAmountView.isHidden = !btnExchangeSelected
        if(product.address.contains("市")){
            let address = product.address.split(separator: "市")
            btnProductCity.setTitle(address[0]+"市", for: .normal)
            btnProductRegion.setTitle(address[1]+"", for: .normal)
        }else if(product.address.contains("縣")){
            let address = product.address.split(separator: "縣")
            btnProductRegion.setTitle(address[1]+"", for: .normal)
        }
        btnProductType.setTitle(product.type, for: .normal)
        btnProductType1.setTitle(product.type1, for: .normal)
        btnProductType2.setTitle(product.type2, for: .normal)
        oldPics.removeAll()
        for index in 0..<product.pics.count{
            oldPics.append(product.pics[index].path)
        }
    }
    @IBAction func btnSaleClick(_ sender: Any) {
        btnSaleSelected = !btnSaleSelected
        if(btnSaleSelected){
            btnSale.setBackgroundImage(UIImage(systemName: "largecircle.fill.circle"), for:.normal)
            btnSale.tintColor = UIColor(named: "Button")
        }else{
            btnSale.setBackgroundImage(UIImage(systemName: "circle"), for:.normal)
            btnSale.tintColor = .darkGray
        }
        salePriceView.isHidden = !btnSaleSelected
        productIsSale = !productIsSale
    }
    @IBAction func btnRentClick(_ sender: Any) {
        btnRentSelected = !btnRentSelected
        if(btnRentSelected){
            btnRent.setBackgroundImage(UIImage(systemName: "largecircle.fill.circle"), for:.normal)
            btnRent.tintColor = UIColor(named: "Button")
        }else{
            btnRent.setBackgroundImage(UIImage(systemName: "circle"), for:.normal)
            btnRent.tintColor = .darkGray
        }
        depositView.isHidden = !btnRentSelected
        rentDayView.isHidden = !btnRentSelected
        productIsRent = !productIsRent
    }
    @IBAction func btnExchangeClick(_ sender: Any) {
        btnExchangeSelected = !btnExchangeSelected
        if(btnExchangeSelected){
            btnExchange.setBackgroundImage(UIImage(systemName: "largecircle.fill.circle"), for:.normal)
            btnExchange.tintColor = UIColor(named: "Button")
        }else{
            btnExchange.setBackgroundImage(UIImage(systemName: "circle"), for:.normal)
            btnExchange.tintColor = .darkGray
        }
        exchangeAmountView.isHidden = !btnExchangeSelected
        exchangeAmountView2.isHidden = !btnExchangeSelected
        exchangeWorthView.isHidden = !btnExchangeSelected
        productIsExchange = !productIsExchange
    }
    
    
    //popover裡按下完成按鍵的action
    @IBAction func doneClick(_ sender: Any) {
        let title  = pickerList[pickerView.selectedRow(inComponent: 0)]
        switch currentButton {
        case btnSend:
            productRentMethod = title
        case btnProductType:
            productType = title
        case btnProductType1:
            productType1 = title
        case btnProductType2:
            productType2 = title
        case btnProductCity:
            productCity = title
        case btnProductRegion:
            productRegion = title
        case btnExchangeAmount:
            productExangeAmount = Int(title)
        default:
            print("沒篩到")
        }
        currentButton.setTitle(title, for: .normal)
        //關閉pickerview
        displayPicker(false)
    }
    
    
    //popover裡按下取消按鍵的action
    @IBAction func cancelClick(_ sender: Any) {
        //關閉popoverview
        displayPicker(false)
    }
    @IBAction func exchangeAmountClick(_ sender: Any) {
        currentButton = btnExchangeAmount
        pickerList.removeAll()
        
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
    //寄送方式
    @IBAction func sendClick(_ sender: Any) {
        currentButton = btnSend
        pickerList.removeAll()
        pickerList = ["7-11店到店","全家店到店","OK店到店","萊爾富店到店","宅急便","郵寄","面交"]
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
    //按下位置按鈕後的action
    @IBAction func cityClick(_ sender: Any) {
        currentButton = btnProductCity
        pickerList.removeAll()
        pickerList = CityList.city
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
    @IBAction func regionClick(_ sender: Any) {
        currentButton = btnProductRegion
        pickerList.removeAll()
        pickerList = CityList.region[(btnProductCity.titleLabel?.text)!] ?? []
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
    @IBAction func typeClick(_ sender: Any) {
        currentButton = btnProductType
        pickerList.removeAll()
        pickerList = ["PlayStation","Xbox","Switch","桌遊"]
        //刷新pick內容
        pickerView.reloadAllComponents()
        displayPicker(true)
    }
    @IBAction func type1Click(_ sender: Any) {
        currentButton = btnProductType1
        pickerList.removeAll()
        switch productType {
        case "PlayStation":
            lbProductType1.text = "主機型號"
            pickerList = ["PS5","PS4"]
        case "Xbox":
            lbProductType1.text = "主機型號"
            pickerList = ["One","Series"]
        case "Switch":
            lbProductType1.text = "主機型號"
            pickerList = ["Switch"]
        case "桌遊":
            lbProductType1.text = "遊玩人數"
            pickerList = ["4人以下","4-8人","8人以上"]
        default:
            pickerList = ["PS5","PS4","Xbox One","Xbox Series","Switch","桌遊"]
        }
        //刷新pick內容
        pickerView.reloadAllComponents()
        displayPicker(true)
    }
    @IBAction func type2Click(_ sender: Any) {
        currentButton = btnProductType2
        pickerList.removeAll()
        pickerList = ["遊戲","主機","周邊","其他"]
        //刷新pick內容
        pickerView.reloadAllComponents()
        displayPicker(true)
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
    
    //Mark 上架專區
    func emptyCheck()-> Bool{
        if(productIsSale){
            if(tfProductPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
                return false;
            }
        }
        if(productIsRent){
            if(tfProductRent.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
                tfProductDeposit.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
                return false;
            }
        }
        if(tfProductTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfProductAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            tfProductDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ){
            return false;
        }
        return true;
    }
    private func productInfoCheck()->Bool{
        if(!emptyCheck()){
            let alertView = SwiftAlertView(title: "", message: "請確認資料是否完整", delegate: nil, cancelButtonTitle: "確定")
            alertView.messageLabel.textColor = .white
            alertView.messageLabel.font = UIFont.systemFont(ofSize: 25)
            alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
            alertView.backgroundColor = UIColor(named: "Alert")
            alertView.buttonTitleColor = .white
            alertView.clickedButtonAction = { index in
                alertView.dismiss()
            }
            alertView.show()
            return false
        }
        productTitle = tfProductTitle.text!
        productDescription = tfProductDescription.text!
        productAmount = Int(tfProductAmount.text!)
        if(productIsRent){
            productDeposit = Int(tfProductDeposit.text!)
            productRent = Int(tfProductRent.text!)
        }else{
            productDeposit = 0
            productRent = 0
        }
        if(productIsSale){
            productSalePrice = Int(tfProductPrice.text!)
        }else{
            productSalePrice = 0
        }
        if(productIsExchange){
            
        }
        return true
    }
    @IBAction func addProductClick(_ sender: Any) {
        if(!productInfoCheck()){
            return
        }
        if(Global.isOnline){
            NetworkController.instance().addProduct(title: productTitle, description: productDescription, isSale: productIsSale, isRent: productIsRent, isExchange: productIsExchange, deposit: productDeposit, rent: productRent, salePrice: productSalePrice, rentMethod: productRentMethod, amount: productAmount, address: "\(productCity ?? "")\(productRegion ?? "")", type:productType , type1: productType1, type2: productType2, pics: productImages, tradeItems:tradeItems){  [weak self] (responseValue,isSuccess) in
                guard let weakSelf = self else {return}
                let alertView = SwiftAlertView(title: "", message: " 上架成功！\n", delegate: nil, cancelButtonTitle: "確定")
                alertView.messageLabel.textColor = .white
                alertView.messageLabel.font = UIFont.systemFont(ofSize: 35)
                alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
                alertView.backgroundColor = UIColor(named: "Alert")
                alertView.buttonTitleColor = .white
                if(isSuccess){
                    alertView.clickedButtonAction = { index in
                        let productStoryboard = UIStoryboard(name: Storyboard.product.rawValue, bundle: nil)
                        if let myStoreView = productStoryboard.instantiateViewController(identifier:ProductStoryboardController.productListController.rawValue ) as? ProductListController{
                            myStoreView.navigationController?.navigationBar.prefersLargeTitles = true
                            myStoreView.isMyStore = true
                            myStoreView.slider.backgroundColor = .white
                            myStoreView.tabbarTitle = ["上架中","未上架","出租中","未出貨","不知道"]
                            weakSelf.show(myStoreView, sender: nil);
                        }
                    }
                    alertView.show()
                }else{
                    alertView.messageLabel.text = responseValue
                    alertView.clickedButtonAction = { index in
                        alertView.dismiss()
                    }
                    alertView.show()
                }
            }
        }
    }
    //Mark 編輯模式
    private func setTextFieldUnderLine(size:CGFloat){
        tfProductTitle.lineHeight = size
        tfProductDescription.lineHeight = size
        tfProductAmount.lineHeight = size
        tfProductDeposit.lineHeight = size
        tfProductRent.lineHeight = size
        tfProductPrice.lineHeight = size
    }
    private func setModify(isModify:Bool){
        tfProductTitle.isEnabled = isModify//產品名
        tfProductDescription.isEnabled = isModify//產品描述
        tfProductAmount.isEnabled = isModify//產品數量
        btnProductCity.isEnabled = isModify
        btnProductRegion.isEnabled = isModify
        btnProductType.isEnabled = isModify
        btnProductType2.isEnabled = isModify
        btnSend.isEnabled = isModify
        btnExchangeAmount.isEnabled = isModify
        btnProductType1.isEnabled = isModify
        tfProductDeposit.isEnabled = isModify//產品押金
        tfProductRent.isEnabled = isModify//產品租金
        tfProductPrice.isEnabled = isModify//產品售價
        btnSale.isEnabled = isModify//交易方式
        btnRent.isEnabled = isModify//交易方式
        btnExchange.isEnabled = isModify//交易方式
        addProductImageCV.isUserInteractionEnabled = isModify
        depositView.isUserInteractionEnabled = isModify
        rentDayView.isUserInteractionEnabled = isModify
        salePriceView.isUserInteractionEnabled = isModify
        exchangeAmountView.isUserInteractionEnabled = isModify
    }
    @IBAction func modifyCancelClick(_ sender: Any) {
        setModify(isModify: false)
        setTextFieldUnderLine(size: CGFloat(0))
        btnCancel.isHidden = true
        btnModify.setTitle("編輯", for:.normal)
        NetworkController.instance().getProductById(productId: product.id){
            [weak self] (responseValue,isSuccess) in
            guard let weakSelf = self else{return}
            if(isSuccess){
                let json = JSON(responseValue)
                weakSelf.parseProduct(json: json)
                weakSelf.putInProductInfo()
            }else{
                print("AddProductViewController網路錯誤")
            }
        }
        addProductImageCV.reloadData()
    }
    @IBAction func modifyClick(_ sender: Any) {
        switch btnModify.titleLabel?.text{
        case "編輯":
            setModify(isModify:true)
            setTextFieldUnderLine(size: CGFloat(1))
            btnModify.setTitle("完成", for:.normal)
            self.btnModify.backgroundColor = UIColor(named: "Button")
            btnCancel.isHidden = false
        case "完成":
            if(!productInfoCheck()){
                return
            }
            btnCancel.isHidden = true
            btnModify.setTitle("編輯", for:.normal)
            if(Global.isOnline){
                
            }
        case .none:
            return
        case .some(_):
            return
        }
    }
    private func parseProduct(json:JSON){
            let id = json["id"].string!
            let title = json["title"].string!
            let description = json["description"].string!
            let isSale = json["isSale"].bool!
            let isRent = json["isRent"].bool!
            let isExchange = json["isExchange"].bool!
            let address = json["address"].string ?? ""
            let deposit = json["deposit"].int!
            let rent = json["rent"].int!
            let salePrice = json["salePrice"].int!
            let rentMethod = json["rentMethod"].string!
            let amount = json["amount"].int!
            let type = json["type"].string!
            let type1 = json["type1"].string!
            let type2 = json["type2"].string!
            let userId = json["userId"].string!
            let picsArr = json["pics"].array!
            let tradeItemsArr = json["tradeItems"].array ?? []
            var pics = [Pic]()
            for index in 0..<picsArr.count{
                let id  = picsArr[index]["id"].string ?? ""
                let path  = picsArr[index]["path"].string ?? ""
                let productId  = picsArr[index]["productId"].string ?? ""
                pics.append(Pic.init(id: id, path: path, productId: productId))
            }
            var items = [TradeItem]()
            for index in 0..<tradeItemsArr.count{
                let id = tradeItemsArr[index]["id"].string ?? ""
                let exchangeItem = tradeItemsArr[index]["exchangeItem"].string ?? ""
                items.append(TradeItem.init(id:id,exchangeItem: exchangeItem))
            }
            self.product = ProductModel.init(id: id, title: title, description: description, isSale: isSale, isRent: isRent, isExchange: isExchange, deposit: deposit, rent: rent, salePrice: salePrice, address: address, rentMethod: rentMethod, amount: amount, type: type, type1: type1, type2: type2, userId: userId, pics: pics, tradeItems: items)
    }
}
extension AddProductViewController:UIPickerViewDelegate,UIPickerViewDataSource{
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
extension AddProductViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isModifyType){
            return oldPics.count+productImages.count
        }else{
            return productImages.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddProductImageCollectionViewCell", for: indexPath) as? AddProductImageCollectionViewCell {
            if(isModifyType){
                if(indexPath.row<oldPics.count){
                    cell.configureWithUrl(with: oldPics[indexPath.row])
                }else{
                    cell.configureWithImg(with: productImages[(indexPath.row-oldPics.count)])
                }
            }else{
                cell.configureWithImg(with: productImages[indexPath.row])
            }
            cell.indexPath = indexPath
            cell.addProductImageCollectionViewCellDelegate = self
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //Create UICollectionReusableView
        var reusableView = UICollectionReusableView()
        
        if kind == UICollectionView.elementKindSectionHeader {
            // header
            reusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind:
                    UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "Header",
                for: indexPath)
            //header content
            reusableView.backgroundColor = UIColor.darkGray
        } else if kind == UICollectionView.elementKindSectionFooter {
            // footer
            reusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind:
                    UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: "AddProductFooter",
                for: indexPath)
            //footer content
            reusableView.backgroundColor = UIColor.clear
            //將點擊事件塞給reusableView(Footer)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(footerViewTapped))
            reusableView.addGestureRecognizer(tapGesture)
            
        }
        return reusableView
    }
    //設定footer點擊事件
    @objc func footerViewTapped() {
        let photoViewController = TLPhotosPickerViewController()
        photoViewController.delegate = self
        self.present(photoViewController, animated: true, completion: nil)
    }
}
extension AddProductViewController:AddProductImageCollectionViewCellDelegate{
    func deleteClick(indexPath: IndexPath) {
        if(isModifyType){
            if(indexPath.row<oldPics.count){
                oldPics.remove(at: indexPath.row)
            }else{
                productImages.remove(at: (indexPath.row-oldPics.count))
            }
            addProductImageCV.reloadData()
        }else{
            productImages.remove(at: indexPath.row)
            addProductImageCV.reloadData()
        }
    }
}
extension AddProductViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = addProductImageCV.frame.size
        return CGSize(width: size.width/3, height: size.height)
    }
}
extension AddProductViewController:TLPhotosPickerViewControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        productImages.append(image)
        addProductImageCV.reloadData()
        dismiss(animated: true, completion: nil)
    }
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
        return true
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        //使用者選好照片時
        self.selectedAssets = withTLPHAssets
    }
    func photoPickerDidCancel() {
        //取消選取照片
    }
    func dismissComplete() {
        //完成照片選取並離開
        for index in 0..<self.selectedAssets.count{
            if let image = self.selectedAssets[index].fullResolutionImage{
                productImages.append(image)
            }
        }
        //自動滑到新增照片的最尾端
        let index = IndexPath.init(item: productImages.count-1, section: 0)
        self.addProductImageCV.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        addProductImageCV.reloadData()
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        //選取超過最大上限數量的照片
    }
}



//
//  AddProductViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/20.
//

import UIKit
import TLPhotoPicker
import SwiftAlertView

class AddProductViewController: BaseViewController {
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var tfProductTitle: UnderLineTextField!
    @IBOutlet weak var lbProductDescription: UILabel!
    @IBOutlet weak var tfProductDescription: UnderLineTextField!
    @IBOutlet weak var lbProductAmount: UILabel!
    @IBOutlet weak var tfProductAmount: UnderLineTextField!
    @IBOutlet weak var lbProductLocation: UILabel!
    @IBOutlet weak var lbProductType: UILabel!
    @IBOutlet weak var lbProductType1: UILabel!
    @IBOutlet weak var lbProductType2: UILabel!
    @IBOutlet weak var btnProductCity: UIButton!
    @IBOutlet weak var btnProductRegion: UIButton!
    @IBOutlet weak var btnProductType: UIButton!
    @IBOutlet weak var btnProductType2: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnExchangeAmount: UIButton!
    @IBOutlet weak var btnProductType1: UIButton!
    @IBOutlet weak var depositView: DesignableView!
    @IBOutlet weak var rentDayView: DesignableView!
    @IBOutlet weak var salePriceView: DesignableView!
    @IBOutlet weak var exchangeAmountView: DesignableView!
    @IBOutlet weak var tfProductDeposit: UnderLineTextField!
    @IBOutlet weak var tfProductRentDay: UnderLineTextField!
    @IBOutlet weak var tfProductPrice: UnderLineTextField!
    @IBOutlet weak var customFooter: CustomFooter!
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
    @IBOutlet weak var btnSale: UIButton!
    @IBOutlet weak var btnRent: UIButton!
    @IBOutlet weak var btnExchange: UIButton!
    var list = [String]()
    //wantchangeTableView
    @IBOutlet weak var wantChangeTableView: UITableView!
    var tradeItems = [String]()
    var cellCount = 1
    //popoverview榜定
    @IBOutlet var selectView: UIView!
    //popover裡的picker榜定
    @IBOutlet weak var pickerView: UIPickerView!
    //設定popover出來的高度
    let popoverViewHeight = CGFloat(256)
    var location:String?
    var host:String?
    var type:String?
    @IBOutlet weak var addProductCV: UICollectionView!
    
    @IBOutlet weak var wantChangeTableViewHeight: NSLayoutConstraint!
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        wantChangeTableView.layer.removeAllAnimations()
        wantChangeTableViewHeight.constant = wantChangeTableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wantChangeTableView.delegate = self
        self.wantChangeTableView.dataSource = self
        self.wantChangeTableView.backgroundColor = .clear
        wantChangeTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.wantChangeTableView.reloadData()
        addProductCV.delegate = self
        addProductCV.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
        
 
    }
    @IBAction func btnSaleClick(_ sender: Any) {
        btnSale.isSelected = !btnSale.isSelected
        if(btnSale.isSelected){
        btnSale.setBackgroundImage(UIImage(systemName: "square.fill"), for:.normal)
        btnSale.tintColor = UIColor(named: "Button")
        }else{
            btnSale.setBackgroundImage(UIImage(systemName: "square"), for:.normal)
            btnSale.tintColor = .darkGray
        }
        salePriceView.isHidden = !salePriceView.isHidden
        productIsSale = !productIsSale
    }
    @IBAction func btnRentClick(_ sender: Any) {
        btnRent.isSelected = !btnRent.isSelected
        if(btnRent.isSelected){
            btnRent.setBackgroundImage(UIImage(systemName: "square.fill"), for:.normal)
            btnRent.tintColor = UIColor(named: "Button")
        }else{
            btnRent.setBackgroundImage(UIImage(systemName: "square"), for:.normal)
            btnRent.tintColor = .darkGray
        }
        depositView.isHidden = !depositView.isHidden
        rentDayView.isHidden = !rentDayView.isHidden
        productIsRent = !productIsRent
    }
    @IBAction func btnExchangeClick(_ sender: Any) {
        btnExchange.isSelected = !btnExchange.isSelected
        if(btnExchange.isSelected){
            btnExchange.setBackgroundImage(UIImage(systemName: "square.fill"), for:.normal)
            btnExchange.tintColor = UIColor(named: "Button")
        }else{
            btnExchange.setBackgroundImage(UIImage(systemName: "square"), for:.normal)
            btnExchange.tintColor = .darkGray
        }
        wantChangeTableView.isHidden = !wantChangeTableView.isHidden
        exchangeAmountView.isHidden = !exchangeAmountView.isHidden
                   productIsExchange = !productIsExchange
    }
    @IBAction func removeCell(_ sender: Any) {
        if(self.cellCount==1){
            return
        }
        self.cellCount -= 1
        print("刪掉一格")
        print(self.cellCount)
        wantChangeTableView.reloadData()
        
    }
    @IBAction func addCell(_ sender: Any) {
        self.cellCount += 1
        print("新增一格")
        print(self.cellCount)
        wantChangeTableView.reloadData()
    }
    //popover裡按下完成按鍵的action
    @IBAction func doneClick(_ sender: Any) {
        let title  = list[pickerView.selectedRow(inComponent: 0)]
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
        list.removeAll()
        for index in 1...cellCount{
            list.append("\(index)")
        }
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
    //寄送方式
    @IBAction func sendClick(_ sender: Any) {
        currentButton = btnSend
        list.removeAll()
        list = ["7-11店到店","全家店到店","OK店到店","萊爾富店到店","宅急便","郵寄","面交"]
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
    //按下位置按鈕後的action
    @IBAction func cityClick(_ sender: Any) {
        currentButton = btnProductCity
        list.removeAll()
        list = CityList.city
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
    @IBAction func regionClick(_ sender: Any) {
        currentButton = btnProductRegion
        list.removeAll()
        list = CityList.region[(btnProductCity.titleLabel?.text)!] ?? []
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
    @IBAction func typeClick(_ sender: Any) {
        currentButton = btnProductType
        list.removeAll()
        list = ["PlayStation","Xbox","Switch","桌遊"]
        //刷新pick內容
        pickerView.reloadAllComponents()
        displayPicker(true)
    }
    @IBAction func type1Click(_ sender: Any) {
        currentButton = btnProductType1
        list.removeAll()
        switch productType {
        case "PlayStation":
            lbProductType1.text = "主機型號"
            list = ["PS5","PS4"]
        case "Xbox":
            lbProductType1.text = "主機型號"
            list = ["One","Series"]
        case "Switch":
            lbProductType1.text = "主機型號"
            list = ["Switch"]
        case "桌遊":
            lbProductType1.text = "遊玩人數"
            list = ["4人以下","4-8人","8人以上"]
        default:
            list = ["PS5","PS4","Xbox One","Xbox Series","Switch","桌遊"]
        }
        //刷新pick內容
        pickerView.reloadAllComponents()
        displayPicker(true)
    }
    @IBAction func type2Click(_ sender: Any) {
        currentButton = btnProductType2
        list.removeAll()
        list = ["遊戲","主機","周邊","其他"]
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
    func emptyCheck()-> Bool{
        if(productIsSale){
            if(tfProductPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
                return false;
            }
        }
        if(productIsRent){
            if(tfProductRentDay.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
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
    @IBAction func addProductClick(_ sender: Any) {
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
            return
        }
        productTitle = tfProductTitle.text!
        productDescription = tfProductDescription.text!
        productAmount = Int(tfProductAmount.text!)
        if(productIsRent){
            productDeposit = Int(tfProductDeposit.text!)
            productRent = Int(tfProductRentDay.text!)
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
            for index in 0..<cellCount{
                let indexPath = IndexPath(item: index, section: 0)
                if let cell = wantChangeTableView.cellForRow(at: indexPath) as? WantChangeTableViewCell{
                    if(cell.tfChangeProduct.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""){
                        continue
                    }
                    tradeItems.append(cell.tfChangeProduct.text!)
                }
            }
            if(cellCount<productExangeAmount){
                let alertView = SwiftAlertView(title: "", message: "交換數量不可大於願望清單總數\n", delegate: nil, cancelButtonTitle: "確定")
                alertView.messageLabel.textColor = .white
                alertView.messageLabel.font = UIFont.systemFont(ofSize: 25)
                alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
                alertView.backgroundColor = UIColor(named: "Alert")
                alertView.buttonTitleColor = .white
                alertView.clickedButtonAction = { index in
                    alertView.dismiss()
                }
                alertView.show()
                return
            }
            if(tradeItems.count != cellCount){
                let alertView = SwiftAlertView(title: "", message: "請確認願望清單資料是否完整\n", delegate: nil, cancelButtonTitle: "確定")
                alertView.messageLabel.textColor = .white
                alertView.messageLabel.font = UIFont.systemFont(ofSize: 25)
                alertView.button(at: 0)?.backgroundColor = UIColor(named: "Button")
                alertView.backgroundColor = UIColor(named: "Alert")
                alertView.buttonTitleColor = .white
                alertView.clickedButtonAction = { index in
                    alertView.dismiss()
                }
                alertView.show()
                return
            }
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
}

extension AddProductViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    //設定有幾個bar可以滾動
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //設定bar的內容有幾項
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    //設定bar的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    //調整pickerview文字
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Helvetica Neue", size: 25)
        label.text =  list[row]
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
        productImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddProductImageCollectionViewCell", for: indexPath) as? AddProductImageCollectionViewCell {
            cell.configureWithImg(with: productImages[indexPath.row])
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
extension AddProductViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = addProductCV.frame.size
        return CGSize(width: size.width/3, height: size.height)
    }
}
extension AddProductViewController:TLPhotosPickerViewControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        productImages.append(image)
        addProductCV.reloadData()
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
        self.addProductCV.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        addProductCV.reloadData()
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        //選取超過最大上限數量的照片
    }
}
extension AddProductViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count\(self.cellCount)")
        return self.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("創造cell")
        if let cell = wantChangeTableView.dequeueReusableCell(withIdentifier: "WantChangeTableViewCell") as? WantChangeTableViewCell {
            cell.lbChangeTitle.text = "\(indexPath.row+1):"
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
}

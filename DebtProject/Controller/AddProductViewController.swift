//
//  AddProductViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/20.
//

import UIKit
import TLPhotoPicker

class AddProductViewController: BaseViewController {
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var tfProductName: UnderLineTextField!
    @IBOutlet weak var lbProductDescription: UILabel!
    @IBOutlet weak var tfProductDescription: UnderLineTextField!
    @IBOutlet weak var lbProductAmount: UILabel!
    @IBOutlet weak var tfProductAmount: UnderLineTextField!
    @IBOutlet weak var lbProductLocation: UILabel!
    @IBOutlet weak var lbProductHost: UILabel!
    @IBOutlet weak var lbProductType: UILabel!
    @IBOutlet weak var btnProductLocation: UIButton!
    @IBOutlet weak var btnProductType: UIButton!
    @IBOutlet weak var btnProductType2: UIButton!
    @IBOutlet weak var btnSellType: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnProductType1: UIButton!
    @IBOutlet weak var depositView: DesignableView!
    @IBOutlet weak var rentDayView: DesignableView!
    @IBOutlet weak var salePriceView: DesignableView!
    @IBOutlet weak var tfProductDeposit: UnderLineTextField!
    @IBOutlet weak var tfProductRentDay: UnderLineTextField!
    @IBOutlet weak var tfProductPrice: UnderLineTextField!
    var selectedAssets = [TLPHAsset]()
    var currentButton:UIButton!
    var productTitle:String!
    var productDescription:String!
    var productIsSale:Bool!
    var productIsRent:Bool!
    var productDeposit:Int!
    var productRentDay:Int!
    var productSalePrice:Int!
    var productRentMethod:String!
    var productAmount:Int!
    var productType:String!
    var productType1:String!
    var productType2:String!
    var productImages = [UIImage]()
    var list = [String]()
    //popoverview榜定
    @IBOutlet var selectView: UIView!
    //popover裡的picker榜定
    @IBOutlet weak var pickerView: UIPickerView!
    //設定popover出來的高度
    let popoverViewHeight = CGFloat(256)
    var location:String?
    var host:String?
    var type:String?
    //popover裡按下完成按鍵的action
    @IBAction func doneClick(_ sender: Any) {
        
        let title  = list[pickerView.selectedRow(inComponent: 0)]
        switch currentButton {
        case btnSellType:
            switch title {
            case "租借":
                depositView.isHidden = false
                rentDayView.isHidden = false
                salePriceView.isHidden = true
                productIsSale = false
                productIsRent = true
            case "販售":
                depositView.isHidden = true
                rentDayView.isHidden = true
                salePriceView.isHidden = false
                productIsSale = true
                productIsRent = false
            default:
                depositView.isHidden = false
                rentDayView.isHidden = false
                salePriceView.isHidden = false
                productIsSale = true
                productIsRent = true
            }
        case btnSend:
            productRentMethod = title
        case btnProductType:
            productType = title
            print("??????\(productType)")
        case btnProductType1:
            productType1 = title
        case btnProductType2:
            productType2 = title
        default:
            print("沒篩到")
        }
        currentButton.setTitle(title, for: .normal)
        //關閉pickerview
        displayPicker(false)
    }
    
    //popover裡按下取消按鍵的action
    @IBAction func sendClick(_ sender: Any) {
        currentButton = btnSend
        list.removeAll()
        list = ["7-11店到店","全家店到店","OK店到店","萊爾富店到店","宅急便","郵寄","面交"]
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
    @IBAction func cancelClick(_ sender: Any) {
        
        //關閉popoverview
        displayPicker(false)
    }
    //按下選擇販售方式
    @IBAction func sellTypeClick(_ sender: Any) {
        currentButton = btnSellType
        list.removeAll()
        list = ["租借","販售","全部"]
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
    //按下位置按鈕後的action
    @IBAction func locationClick(_ sender: Any) {
        currentButton = btnProductLocation
        list.removeAll()
        list = ["台北市","新北市","基隆市","桃園市","臺中市","臺南市","高雄市","新竹縣","苗栗縣","彰化縣","南投縣","雲林縣","嘉義縣","屏東縣","宜蘭縣","花蓮縣","臺東縣","澎湖縣","金門縣","連江縣","新竹市","嘉義市"]
        //刷新pick內容
        pickerView.reloadAllComponents()
        //跳出popoverview
        displayPicker(true)
    }
    @IBAction func typeClick(_ sender: Any) {
        currentButton = btnProductType
        list.removeAll()
        list = ["PlayStation","Xbox","任天堂","桌遊"]
        //刷新pick內容
        pickerView.reloadAllComponents()
        displayPicker(true)
    }
    @IBAction func type1Click(_ sender: Any) {
        currentButton = btnProductType1
        list.removeAll()
        print("!!!!!!!!!!!!!!")
        print(productType)
        switch productType {
        case "PlayStation":
            list = ["PS5","PS4"]
        case "Xbox":
            list = ["Xbox One","Xbox Series"]
        case "任天堂":
            list = ["Switch"]
        case "桌遊":
            list = ["桌遊"]
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
    @IBOutlet weak var addProductCV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addProductCV.delegate = self
        addProductCV.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
    }
    //點擊空白收回鍵盤
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
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
//圖片轉bmp再轉64bit

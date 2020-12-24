//
//  AddProductViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/20.
//

import UIKit
import TLPhotoPicker

class AddProductViewController: BaseViewController {
    var images = [UIImage]()
    var list = [String]()
    @IBOutlet var selectView: UIView!
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var tfProductName: UnderLineTextField!
    @IBOutlet weak var lbProductDescription: UILabel!
    @IBOutlet weak var tfProductDescription: UnderLineTextField!
    @IBOutlet weak var lbProductPrice: UILabel!
    @IBOutlet weak var tfProductPrice: UnderLineTextField!
    @IBOutlet weak var lbProductAmount: UILabel!
    @IBOutlet weak var tfProductAmount: UnderLineTextField!
    @IBOutlet weak var lbProductLocation: UILabel!
    @IBOutlet weak var lbProductHost: UILabel!
    @IBOutlet weak var lbProductType: UILabel!
    @IBOutlet weak var btnProductLocation: UIButton!
    @IBOutlet weak var btnProductHost: UIButton!
    @IBOutlet weak var btnProductType: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    var currentButton:UIButton!
    let popoverViewHeight = CGFloat(256)
    var selectedAssets = [TLPHAsset]()
    var location:String?
    var host:String?
    var type:String?
    
    @IBAction func doneClick(_ sender: Any) {
        let title  = list[pickerView.selectedRow(inComponent: 0)]
        currentButton.setTitle(title, for: .normal)
        displayPicker(false)
    }
    @IBAction func cancelClick(_ sender: Any) {
        displayPicker(false)
    }
    @IBAction func locationClick(_ sender: Any) {
        currentButton = btnProductLocation
        list.removeAll()
        list = ["台北市","新北市","基隆市","桃園市","臺中市","臺南市","高雄市","新竹縣","苗栗縣","彰化縣","南投縣","雲林縣","嘉義縣","屏東縣","宜蘭縣","花蓮縣","臺東縣","澎湖縣","金門縣","連江縣","新竹市","嘉義市"]
        pickerView.reloadAllComponents()
        displayPicker(true)
    }
    @IBAction func hostClick(_ sender: Any) {
        
        currentButton = btnProductHost
        list.removeAll()
        list = ["PS5","PS4","Xbox One","Xbox Series","Switch","桌遊"]
        pickerView.reloadAllComponents()
        displayPicker(true)
    }
    @IBAction func typeClick(_ sender: Any) {
        currentButton = btnProductType
        list.removeAll()
        list = ["遊戲","主機","周邊","其他"]
        pickerView.reloadAllComponents()
        displayPicker(true)
    }
    //設定彈出的方法 ture就顯示false就藏在下面
    func displayPicker(_ show:Bool){
        for c in view.constraints{
            if(c.identifier == "bottom"){
                c.constant = (show) ? -10 : popoverViewHeight
                break
            }
        }
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(selectView)
        selectView.translatesAutoresizingMaskIntoConstraints = false
        //一定要加isActive = true 不然排版會沒有用
        selectView.heightAnchor.constraint(equalToConstant: popoverViewHeight).isActive = true
        //設定左右邊界(左邊要是-10)
        selectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        selectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //先設定這個畫面在螢幕bottom下方height高度位置，等等調整這個數值就可以達到由下往上滑出的效果
        //設為變數等等才方便調整
        let constraint = selectView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: popoverViewHeight)
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
//    private func setPicker(){
//        let locationPicker = PickerViewController()
//        self.addChild(locationPicker)
//        locationPicker.pickerData = ["台北市","新北市","基隆市"]
//        pvProductLocation.delegate = locationPicker
//        pvProductLocation.dataSource = locationPicker
//
//        //將點擊事件塞給reusableView(Footer)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickerViewTapped))
//        pvProductLocation.addGestureRecognizer(tapGesture)
////        self.view.addSubview(pvProductLocation)
//
//
//        let hostPicker = PickerViewController()
//        self.addChild(hostPicker)
//        hostPicker.pickerData = ["PS5","PS4","Xbox-one","Xbox-series","Switch","桌遊"]
//        pvProductLocation.delegate = hostPicker
//        pvProductLocation.dataSource = hostPicker
////        self.view.addSubview(pvProductHost)
//
//        let typePicker = PickerViewController()
//        self.addChild(typePicker)
//        typePicker.pickerData = ["遊戲","主機","周邊","其他"]
//        pvProductLocation.delegate = typePicker
//        pvProductLocation.dataSource = typePicker
////        self.view.addSubview(pvProductType)
//    }
}

extension AddProductViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
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
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        50
    }
}
extension AddProductViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddProductImageCollectionViewCell", for: indexPath) as? AddProductImageCollectionViewCell {
            cell.configureWithImg(with: images[indexPath.row])
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
        images.append(image)
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
                images.append(image)
            }
        }
        //自動滑到新增照片的最尾端
        let index = IndexPath.init(item: images.count-1, section: 0)
        self.addProductCV.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        addProductCV.reloadData()
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        //選取超過最大上限數量的照片
    }
}
//圖片轉bmp再轉64bit

//
//  MakeOrderViewController.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/2.
//

import UIKit



class MakeOrderViewController: PresentBottomVC {
    
    override var controllerHeight: CGFloat{
        return UIScreen.main.bounds.size.height * 5/7
    }
    
    var product:ProductModel!
    //tavleView
    @IBOutlet weak var exchangeListTableView: UITableView!
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
    var tradeItem:String?
    var tradeQuantity:Int?//交易數量
    @IBOutlet weak var exchangeListTableViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        exchangeListTableView.delegate = self
        exchangeListTableView.dataSource = self
        exchangeListTableView.backgroundColor = .clear
        //設定KVO
        exchangeListTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        //設定exchangeList資料
        for index in 0..<product.tradeItems.count{
            print("交換商品加入清單\(index)")
            exchangeList.append("\(product.tradeItems[index].exchangeItem)")
            exchangeList.append("99999999999")
        }
        exchangeListTableView.reloadData()
        //設定pickview
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        //設定按外面會把鍵盤收起
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
        //設定背景顏色
        //設定navigation bar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
        //設定barItem 的顏色
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let layer = Global.setBackgroundColor(view);
        view.layer.insertSublayer(layer, at: 0)
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
        case btnTradeType:
            switch title{
            case "購買":
                tradeMethod = 1
            case "租借":
                tradeMethod = 0
            case "交換":
                tradeMethod = 2
            default:
                tradeMethod = 3
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
}
extension MakeOrderViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exchangeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = exchangeListTableView.dequeueReusableCell(withIdentifier: TableViewCell.makeOrderTableViewCell.rawValue) as? MakeOrderTableViewCell{
            cell.lbExchangeProductName.text = exchangeList[indexPath.row]
            
            print("創到正常的")
            return cell
        }
        print("創到空的")
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("點擊cell")
        if let cell = tableView.cellForRow(at: indexPath) as? MakeOrderTableViewCell{
            print("有找到cell")
//            cell.btnSeleted.isSelected = !cell.btnSeleted.isSelected
//            if(cell.btnSeleted.isSelected){
//                cell.btnSeleted.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
//                cell.btnSeleted.tintColor = UIColor(named: "Button")
//            }else{
//                cell.btnSeleted.setImage(UIImage(systemName:"circle"), for: .normal)
//                cell.btnSeleted.tintColor = .darkGray
//            }
        }
        print("沒找到cell")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
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

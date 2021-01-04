//
//  WantListViewController.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/4.
//

import UIKit

class WantListViewController: BaseViewController {
    // 願望清單
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnModify: UIButton!
    @IBOutlet weak var wantExchangeListTV: UITableView!
    @IBOutlet weak var wantExchangeListTVHeight: NSLayoutConstraint!
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        wantExchangeListTV.layer.removeAllAnimations()
        wantExchangeListTVHeight.constant = wantExchangeListTV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    var newCellCount = 0
    var wantExchangeList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定KVO
        wantExchangeListTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        wantExchangeList = ["111111","2222222","3333333","4444444"]
        wantExchangeListTV.delegate = self
        wantExchangeListTV.dataSource = self
        wantExchangeListTV.reloadData()
        
        setTextFieldUnderLine(size: CGFloat(0))
        changeTextFieldEnable(bool:false)
    }
    private func changeTextFieldEnable( bool:Bool){
        for index in 0..<wantExchangeList.count{
            if let cell = wantExchangeListTV.cellForRow(at: IndexPath(row: index, section: 0)) as? WantChangeTableViewCell{
//                cell.tfExchangeProduct.isEnabled = bool
//                cell.tfExchangeAmount.isEnabled = bool
//                cell.tfEXchangeWorth.isEnabled = bool
                cell.isUserInteractionEnabled = bool
            }
        }
        for index in 0..<self.newCellCount{
            if let cell = wantExchangeListTV.cellForRow(at: IndexPath(row: index, section: 0)) as? WantChangeTableViewCell{
//                cell.tfExchangeProduct.isEnabled = bool
//                cell.tfExchangeAmount.isEnabled = bool
//                cell.tfEXchangeWorth.isEnabled = bool
                cell.isUserInteractionEnabled = bool
            }
        }
    
        wantExchangeListTV.isUserInteractionEnabled = bool
    }
    private func setBtnModify(){
        changeTextFieldEnable(bool:false)
        setTextFieldUnderLine(size: CGFloat(0))
        btnModify.setTitle("編輯", for:.normal)
        btnCancel.isHidden = true
        self.btnModify.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    @IBAction func btnCancelClick(_ sender: Any) {
        setBtnModify()
    }
    @IBAction func btnModifyClick(_ sender: Any) {
        switch btnModify.titleLabel?.text{
        case "編輯":
            changeTextFieldEnable(bool:true)
            self.setTextFieldUnderLine(size: CGFloat(1))
            btnModify.setTitle("完成", for:.normal)
            self.btnModify.backgroundColor = UIColor(named: "Button")
            btnCancel.isHidden = false
        case "完成":
//            if(tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
//                tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" /*||
//               tfAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
//               tfNickName.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""*/){
//                lbErrorHint.textColor = .red
//                lbErrorHint.text = "姓名或電話為必填"
//                return
//            }
            self.setTextFieldUnderLine(size: CGFloat(0))
            setBtnModify()
            btnCancel.isHidden = true
            btnModify.setTitle("編輯", for:.normal)
        case .none:
            print("按鈕按下1")
        case .some(_):
            print("按鈕按下2")
        }
    }
    private func setTextFieldUnderLine(size:CGFloat){
        for index in 0..<wantExchangeList.count{
            if let cell = wantExchangeListTV.cellForRow(at: IndexPath(row: index, section: 0)) as? WantChangeTableViewCell{
                cell.tfExchangeProduct.lineHeight = size
                cell.tfExchangeAmount.lineHeight = size
                cell.tfEXchangeWorth.lineHeight = size
            }
        }
        for index in 0..<self.newCellCount{
            if let cell = wantExchangeListTV.cellForRow(at: IndexPath(row: index, section: 0)) as? WantChangeTableViewCell{
                cell.tfExchangeProduct.lineHeight = size
                cell.tfExchangeAmount.lineHeight = size
                cell.tfEXchangeWorth.lineHeight = size
            }
        }
    }
    @IBAction func btnRemoveCellClick(_ sender: Any) {
        if(self.newCellCount==0){
            wantExchangeList.remove(at: wantExchangeList.count-1)
        }else{
            self.newCellCount -= 1
        }
        wantExchangeListTV.reloadData()
    }
    @IBAction func btnAddCellClick(_ sender: Any) {
        self.newCellCount += 1
        wantExchangeListTV.reloadData()
    }
}
extension WantListViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count\(self.newCellCount)")
        return (self.newCellCount+self.wantExchangeList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        for index in 0..<wantExchangeList.count{
            print("\(wantExchangeList[index])")
        }
        if let cell = wantExchangeListTV.dequeueReusableCell(withIdentifier: "WantChangeTableViewCell") as? WantChangeTableViewCell {
            print("創造cell位置\(indexPath.row)")
            if(indexPath.row<wantExchangeList.count){
                cell.tfExchangeProduct.text = wantExchangeList[indexPath.row]
            }else{
                cell.tfExchangeProduct.text = ""
            }
            cell.lbNumber.text = "\(indexPath.row+1):"
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選到後馬上解除選取
        wantExchangeListTV.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            if(indexPath.row<self.wantExchangeList.count){
                self.wantExchangeList.remove(at: indexPath.row)
            }else{
                self.newCellCount -= 1
            }
//                tableView.deleteRows(at: [indexPath], with: .automatic)
            //0.5秒後刷新資料內容
//            let seconds = 0.5
//            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.wantExchangeListTV.reloadData()
//            }
                
                   // 需要返回true，否则没有反应
                   completionHandler(true)
               }

        deleteAction.backgroundColor = .red
               deleteAction.image = UIImage(systemName: "trash")

               let config = UISwipeActionsConfiguration(actions: [deleteAction])

               // 取消拉長後自動執行
               config.performsFirstActionWithFullSwipe = false

               return config
    }
}

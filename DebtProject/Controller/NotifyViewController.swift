//
//  NotifyViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/22.
//

import UIKit

class NotifyViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    var notifyList = [NotifyModel]()
    
    @IBOutlet weak var notifyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        notifyList.append(NotifyModel.init(title: "test1"))
        notifyList.append(NotifyModel.init(title: "test2"))
        notifyList.append(NotifyModel.init(title: "test3"))
        // Do any additional setup after loading the view.
        notifyTableView.delegate = self
        notifyTableView.dataSource = self
        notifyTableView.backgroundColor = .darkGray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyModelCell",for: indexPath) as? NotifyModelCell {
            cell.lbNotify.textColor = .white
            cell.lbNotify.text = notifyList[indexPath.row].title
            
            //設定cell背景顏色
            let layer = Global.setBackgroundColor(view)
            cell.layer.insertSublayer(layer, at: 0)
            return cell
        }
        return UITableViewCell()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


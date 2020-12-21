//
//  MainPageViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/16.
//

import UIKit

class MainPageViewController: BaseSideMenuViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var products = [ProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        products = ProductModel.defaultGameLists
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PageTableViewCell", bundle: nil), forCellReuseIdentifier: "PageTableViewCell")
//        tableView.register(UINib(nibName: "MainPageTableViewCell", bundle: nil), forCellReuseIdentifier: "MainPageTableViewCell")
        // Do any additional setup after loading the view.
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
extension MainPageViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PageTableViewCell",for: indexPath) as? PageTableViewCell {
             switch indexPath.row {
            case 0:
                cell.lbMainPageTitle.text = "PlayStation最新資訊"
                //設定label的手勢
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleTapPS))
                cell.lbMainPageHint.addGestureRecognizer(gestureRecognizer)
            case 1:
                cell.lbMainPageTitle.text = "Xbox最新資訊"
                //設定label的手勢
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleTapXbox(gestureRecognizer:)))
                cell.lbMainPageHint.addGestureRecognizer(gestureRecognizer)
            case 2:
                cell.lbMainPageTitle.text = "Switch最新資訊"
                //設定label的手勢
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleTapSwitch(gestureRecognizer:)))
                cell.lbMainPageHint.addGestureRecognizer(gestureRecognizer)
            case 3:
                cell.lbMainPageTitle.text = "桌遊最新資訊"
                //設定label的手勢
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleTapBoardgame(gestureRecognizer:)))
                cell.lbMainPageHint.addGestureRecognizer(gestureRecognizer)
            default:
                cell.lbMainPageTitle.text = ""
            }
            cell.lbMainPageHint.text = "查看更多 >"
            //設定cell內容
            cell.products = ProductModel.defaultGameLists
            let layer = Global.setBackgroundColor(view)
            cell.layer.insertSublayer(layer, at: 0)
            return cell;
        }
        return UITableViewCell()
    }
    //設定點擊查看更多會發生的事件
    @objc func handleTapPS(gestureRecognizer: UIGestureRecognizer) {
        //設定跳轉
        if let vcMain = self.storyboard?.instantiateViewController(identifier: "ProductListView") as?  ProductListController{
            vcMain.title = "PlayStation"
            vcMain.slider.backgroundColor = .blue
            vcMain.buttonText = ["所有","遊戲","主機","周邊","其他"]
        self.show(vcMain, sender: nil);
        }
    }
    @objc func handleTapXbox(gestureRecognizer: UIGestureRecognizer) {
        //設定跳轉
        if let vcMain = self.storyboard?.instantiateViewController(identifier: "ProductListView") as?  ProductListController{
            vcMain.title = "Xbox"
            vcMain.slider.backgroundColor = .green
            
            vcMain.buttonText = ["所有","遊戲","主機","周邊","其他"]
        self.show(vcMain, sender: nil);
        }
    }
    @objc func handleTapSwitch(gestureRecognizer: UIGestureRecognizer) {
        //設定跳轉
        if let vcMain = self.storyboard?.instantiateViewController(identifier: "ProductListView") as?  ProductListController{
            vcMain.title = "Switch"
            vcMain.buttonText = ["所有","遊戲","主機","周邊","其他"]
            vcMain.slider.backgroundColor = .red
        self.show(vcMain, sender: nil);
        }
    }
    @objc func handleTapBoardgame(gestureRecognizer: UIGestureRecognizer) {
        //設定跳轉
        if let vcMain = self.storyboard?.instantiateViewController(identifier: "ProductListView") as?  ProductListController{
            vcMain.title = "桌遊"
            vcMain.buttonText = ["所有","遊戲","主機","周邊","其他"]
            vcMain.slider.backgroundColor = .blue
        self.show(vcMain, sender: nil);
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}


//
//  MenuListControllerTableViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/11.
//

import UIKit
import SideMenu

protocol SideMenuControllerDelegate {
    func didSelectMenuItem(titleNamed:SideMenuSelectTitle, itemNamed:SideMenuItem)
}
class SideMenuController: UITableViewController {
    
    var menu :SideMenuNavigationController?
    public var delegate: SideMenuControllerDelegate?
    private let sideMenuList:[SideMenuListModel]
    
    private let colr = UIColor(red: 33/255.0,
                                green: 33/255.0,
                                blue: 33/255.0,
                                alpha: 1)
    
    init(with sideMeunList:[SideMenuListModel]) {
        self.sideMenuList = sideMeunList;
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "SideMenuIconTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuIconTableViewCell")
//        tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: "SideMenuTableViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(named: "NavigationBar")
        tableView.separatorStyle = .none
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sideMenuList.count
    }
//
//    override func tableView(_ tableView: UITableView,
//                            titleForHeaderInSection section: Int) -> String? {
//        return sideMenuList[section].title.rawValue;
//    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section<2){
            return 0
        }
        return 30
    }
    //    //設定section標題
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30));
        view.backgroundColor = UIColor(named: "NavigationBar")
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30));
        view.addSubview(label);
        label.textColor = UIColor(named: "textMainCardTitle")
        label.text = sideMenuList[section].title.rawValue
        label.font = label.font.withSize(24)
        label.textAlignment = .center
        return view;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sideMenuList[section].item.count;
    }
    //設定內容
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row==0 && indexPath.section==0){
        return 100
        }
        return 40
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row==0 && indexPath.section==0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuIconTableViewCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sideMenuList[indexPath.section].item[indexPath.row].rawValue
        cell.textLabel?.textColor = UIColor(named: "MainPageCellTradeMethod")
//        cell.textLabel?.frame = CGRect(x: 200, y: 0, width: 200, height: 20)
        //为textLabel重新添加约束
//        cell.textLabel?.trailingAnchor
        cell.backgroundColor = UIColor(named: "Card-2")
        cell.contentView.backgroundColor = UIColor(named: "Card-2")
        return cell
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as? SideMenuTableViewCell{
//            print("創抽屜cell")
//            cell.lbTitle?.text = sideMenuList[indexPath.section].item[indexPath.row].rawValue
//            if(indexPath.row == 0 || indexPath.row == 1){
//                cell.lbTitle?.font = UIFont.systemFont(ofSize: 25)
//            }
//            return cell
//        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell")
//
//        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //設定點擊要做什麼
        let selectTitle = sideMenuList[indexPath.section].title
        let selectItem = sideMenuList[indexPath.section].item[indexPath.row];
        if let delegate = delegate{
            delegate.didSelectMenuItem(titleNamed: selectTitle, itemNamed: selectItem )
        }
    }
    
}

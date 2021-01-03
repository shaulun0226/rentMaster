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
    
    private let color = UIColor(red: 33/255.0,
                                green: 33/255.0,
                                blue: 33/255.0,
                                alpha: 1)
    
    init(with sideMeunList:[SideMenuListModel]) {
        self.sideMenuList = sideMeunList;
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sideMenuList.count
    }
    //設定section標題
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return sideMenuList[section].title.rawValue;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sideMenuList[section].item.count;
    }
    //設定內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sideMenuList[indexPath.section].item[indexPath.row].rawValue
        cell.textLabel?.textColor = .white
        cell.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
        cell.contentView.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
        return cell
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

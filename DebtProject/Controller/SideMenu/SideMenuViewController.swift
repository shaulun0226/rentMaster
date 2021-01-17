//
//  SideMenuViewController.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/14.
//

import UIKit
import SideMenu

protocol SideMenuViewControllerDelegate {
    func didSelectMenuItem(titleNamed:SideMenuSelectTitle, itemNamed:SideMenuItem)
}

class SideMenuViewController: UIViewController {
    
    var menu :SideMenuNavigationController?
    public var delegate: SideMenuViewControllerDelegate?
    private let sideMenuList:[SideMenuListModel]

    @IBOutlet weak var sideMenuTableView: UITableView!
    
    init(with sideMeunList:[SideMenuListModel]) {
        self.sideMenuList = sideMeunList;
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuTableView.dataSource = self
        sideMenuTableView.delegate = self
        sideMenuTableView.backgroundColor = UIColor(named: "Card-2")
        sideMenuTableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
}
extension SideMenuViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return sideMenuList[section].title.rawValue;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section==0 || section==1){
            return 0
        }
        return 30
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sideMenuList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuList[section].item.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as? SideMenuTableViewCell{
            print("創抽屜cell")
            cell.lbTitle?.text = sideMenuList[indexPath.section].item[indexPath.row].rawValue
            if(indexPath.row == 0 || indexPath.row == 1){
                cell.lbTitle?.font = UIFont.systemFont(ofSize: 25)
            }
            return cell
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //設定點擊要做什麼
        let selectTitle = sideMenuList[indexPath.section].title
        let selectItem = sideMenuList[indexPath.section].item[indexPath.row];
        if let delegate = delegate{
            delegate.didSelectMenuItem(titleNamed: selectTitle, itemNamed: selectItem )
        }
    }
    
}

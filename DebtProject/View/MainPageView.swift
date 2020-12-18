//
//  MainPageView.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/13.
//

import UIKit
protocol MainPageViewDelegate {
    func updatePage(_ page:Int);
}
class MainPageView: UIPageViewController {
    private var page = 0;
    private var maxPage = 0;
    var pageDelegate:MainPageViewDelegate?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        guard let tableView = setTableViewController(page: page) else {
            return
        }
        self.setViewControllers([tableView], direction: .forward, animated: false, completion: nil)
        // Do any additional setup after loading the view.
    }
    //根據頁數設定tableController
    private func setTableViewController(page:Int)->UIViewController?{
        if page<0 || page>maxPage{
            return nil
        }
//        guard let mainTableViewController = storyboard?.instantiateViewController(identifier: "mainTableView") as? MainTableViewController else {
//            return nil
//        }
//        mainTableViewController.page = page
        return mainTableViewController
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
extension MainPageView : UIPageViewControllerDataSource{
    //上一頁
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return setTableViewController(page: page - 1)
    }
    //下一頁
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return setTableViewController(page: page + 1)
    }
}
extension MainPageView : UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished{
//            guard let tableView = viewControllers?.first as? MainTableViewController , let page  = tableView.page else {
//                return
//            }
            self.page = page;
            pageDelegate?.updatePage(page)
        }
    }
}

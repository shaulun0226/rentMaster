//
//  Global.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/3.
//
import UIKit
import Foundation
enum Storyboard:String, CaseIterable {
    case main = "Main"
    case product = "Product"
}
enum MainStoryboardController:String, CaseIterable{
    case login = "loginView"
    case forgotPasswordViewController = "ForgotPasswordViewController"
    case registerViewController = "RegisterViewController"
    case mainPageViewController = "MainPageViewController"
    case notifyViewController = "NotifyViewController"
    case changePasswordViewController = "ChangePasswordViewController"
    case memberCenterViewController = "MemberCenterViewController"
    case changeUserInfoViewController = "ChangeUserInfoViewController"
    case customAlertViewController = "CustomAlertViewController"
    case wishListViewController = "WishListViewController"
}
enum ProductStoryboardController:String,CaseIterable{
    case cartViewController = "CartViewController"
    case productListController = "ProductListView"
    case productInfoViewController = "ProductInfoView"
    case addProductViewController = "AddProductViewController"
    case cartCellMenuViewController = "CartCellMenuViewController"
    case myBuyerOrderListViewController = "MyBuyerOrderListViewController"
    case makeOrderViewController = "MakeOrderViewController"
    case orderViewController = "OrderViewController"
}
enum TableViewCell:String,CaseIterable{
    case pageTableViewCell = "PageTableViewCell"
    case memberCenterTableViewCell = "MemberCenterTableViewCell"
    case productModelCell = "ProductModelCell"
    case myOrderListTableViewCell = "MyOrderListTableViewCell"
    case makeOrderTableViewCell = "MakeOrderTableViewCell"
    case myStoreTableViewCell = "MyStoreTableViewCell"
    case noteTableViewCell = "NoteTableViewCell"
    case mainPageTableViewCell = "MainPageTableViewCell"
}
enum CollectionViewCell:String,CaseIterable{
    case pageCollectionViewCell = "PageCollectionViewCell"
    case tabBarCell = "TabBarCell"
    case myOrderListTabBarCell = "MyOrderListTabBarCell"
    case productInfoImageCollectionViewCell = "ProductInfoImageCollectionViewCell"
    case mainPageCollectionViewCell = "MainPageCollectionViewCell"
}
class Global{
    
    //notifyBadge
    static var badgeIsHidden = false
    //device token
    static var deviceToken = ""
    //預計跳轉的頁面
    static var presentView = UIViewController()
    //前個頁面
    static var lastView = UIViewController()
    //網路參數
    static var isOnline = true
    //搜尋的起始頁跟結束頁
    static let pageBegin = 1
    static let pageEnd = 100
    
    //storyboard
    static let productStoryboard = UIStoryboard(name: Storyboard.product.rawValue, bundle: nil)
    static let mainStoryboard = UIStoryboard(name: Storyboard.main.rawValue, bundle: nil)
    
//    static var token:String? = "";
    
    static let URL:String = "http://35.184.167.119:3000/api";
    
    static let BACKGROUND_COLOR = [UIColor(named: "GradientBegin")?.cgColor
                                   ,UIColor(named: "GradientEnd")?.cgColor] ;
    
    //螢幕尺寸
    static let screenSize = UIScreen.main.bounds.size
    static func setBackgroundColor(_ view:UIView)->CAGradientLayer{
        let layer = CAGradientLayer();
        layer.frame = view.bounds;
        layer.colors = BACKGROUND_COLOR as [Any]
        layer.startPoint = CGPoint(x: 0.5,y: 0);
        layer.endPoint = CGPoint(x: 0.5,y: 1);
        return layer;
    }
}


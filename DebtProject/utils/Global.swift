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
}
enum ProductStoryboardController:String,CaseIterable{
    case cartViewController = "CartViewController"
    case productListController = "ProductListView"
    case productInfoViewController = "ProductInfoView"
    case addProductViewController = "AddProductViewController"
    case cartCellMenuViewController = "CartCellMenuViewController"
    case myOrderListViewController = "MyOrderListViewController"
}
enum TableViewCell:String,CaseIterable{
    case pageTableViewCell = "PageTableViewCell"
    case memberCenterTableViewCell = "MemberCenterTableViewCell"
    case productModelCell = "ProductModelCell"
}
enum CollectionViewCell:String,CaseIterable{
    case pageCollectionViewCell = "PageCollectionViewCell"
    case tabBarCell = "TabBarCell"
}
class Global{
    
    static var isOnline = false
    static let pageBegin = 1
    static let pageEnd = 10
    
    //storyboard
    static let productStoryboard = UIStoryboard(name: Storyboard.product.rawValue, bundle: nil)
    static let mainStoryboard = UIStoryboard(name: Storyboard.main.rawValue, bundle: nil)
    
//    static var token:String? = "";
    
    static let URL:String = "http://35.184.167.119:3000/api";
    
    static let BACKGROUND_COLOR = [UIColor(named: "GradientBegin")?.cgColor
                                   ,UIColor(named: "GradientEnd")?.cgColor] ;
    
    
    static func setBackgroundColor(_ view:UIView)->CAGradientLayer{
        let layer = CAGradientLayer();
        layer.frame = view.bounds;
        layer.colors = BACKGROUND_COLOR as [Any]
        layer.startPoint = CGPoint(x: 0.5,y: 0);
        layer.endPoint = CGPoint(x: 0.5,y: 1);
        return layer;
    }
}


//
//  SideMenuList.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/13.
//

import Foundation

enum SideMenuItem: String, CaseIterable {
    case store = "我的賣場"
    case home = "Home"
    case ps4 = "PS4"
    case ps5 = "PS5"
    case xbox = "Xbox"
    case one = "Xbox One"
    case Switch = "Switch"
    case boardgame = "桌遊"
    case changePassword = "修改密碼"
    case logout = "帳號登出"
}
enum SideMenuSelectTitle:String,CaseIterable{
    case store = "Store"
    case homePage = "Home"
    case ps = "PlayStation"
    case xbox = "XBOX"
    case Switch = "Switch"
    case boardgame = "桌遊"
    case memberCenter = "會員中心"
}

struct SideMenuListModel {
    var title:SideMenuSelectTitle
    var item:[SideMenuItem]
}


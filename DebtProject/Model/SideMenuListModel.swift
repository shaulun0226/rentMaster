//
//  SideMenuList.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/13.
//

import Foundation

enum SideMenuItem: String, CaseIterable {
    case icon = "Icon"
    case myOrder = "我的訂單"
    case wishList = "願望清單"
    case store = "我的賣場"
    case home = "主畫面"
    case ps4 = "PS4"
    case ps5 = "PS5"
    case series = "Series"
    case one = "One"
    case Switch = "Switch"
    case boardgame = "桌遊"
    case fourPlayerBoardGame = "4人以下"
    case fourToEightPlayerBoardGame = "4-8人"
    case eightPlayerBoardGame = "8人以上"
//    case changePassword = "修改密碼"
//    case logout = "帳號登出"
//    case memberCenter = "會員中心"
}
enum SideMenuSelectTitle:String,CaseIterable{
    case icon = "Icon"
    case store = "MyStore"
    case homePage = "Home"
    case ps = "PlayStation"
    case xbox = "Xbox"
    case Switch = "Switch"
    case boardgame = "桌遊"
//    case memberCenter = "會員中心"
}

struct SideMenuListModel {
    var title:SideMenuSelectTitle
    var item:[SideMenuItem]
}


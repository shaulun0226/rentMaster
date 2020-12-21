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
}
enum SideMenuSelectTitle:String,CaseIterable{
    case store = "Store"
    case homePage = "Home"
    case ps = "PlayStation"
    case xbox = "XBOX"
    case Switch = "Switch"
}

struct SideMenuListModel {
    var title:SideMenuSelectTitle
    var item:[SideMenuItem]
}


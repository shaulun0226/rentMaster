//
//  ContractListModel.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/13.
//

import Foundation

struct ProductModel {
    var name:String
    var house:String
    var money:Int
    var date:String
    var imgUrl:String
}
extension ProductModel{
    static var defaultGameLists:[ProductModel] = [
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 555, date: "2020-12-12", imgUrl: "monsterhunter2"),
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 555, date: "2020-12-12", imgUrl: "monsterhunter2"),
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 555, date: "2020-12-12", imgUrl: "monsterhunter2"),
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 555, date: "2020-12-12", imgUrl: "monsterhunter"),
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 555, date: "2020-12-12", imgUrl: "monsterhunter"),
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 555, date: "2020-12-12", imgUrl: "monsterhunter"),
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 555, date: "2020-12-12", imgUrl: "monsterhunter"),
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 555, date: "2020-12-12", imgUrl: "https://storage.googleapis.com/gold-bruin-237907.appspot.com/1590032783606-f11c50ab-b5db-45d5-a6d1-969da850cfc3.jpg"),
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 555, date: "2020-12-12", imgUrl: "https://storage.googleapis.com/gold-bruin-237907.appspot.com/1590032783606-f11c50ab-b5db-45d5-a6d1-969da850cfc3.jpg"),
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 555, date: "2020-12-12", imgUrl: "https://storage.googleapis.com/gold-bruin-237907.appspot.com/1590032783606-f11c50ab-b5db-45d5-a6d1-969da850cfc3.jpg"),
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 555, date: "2020-12-12", imgUrl: "https://storage.googleapis.com/gold-bruin-237907.appspot.com/1590032783606-f11c50ab-b5db-45d5-a6d1-969da850cfc3.jpg"),
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 777, date: "2020-12-12", imgUrl: "https://storage.googleapis.com/gold-bruin-237907.appspot.com/1590032783606-f11c50ab-b5db-45d5-a6d1-969da850cfc3.jpg"),
        ProductModel.init(name: "MonsterHunter", house: "信義", money: 666, date: "2020-12-12", imgUrl: "https://storage.googleapis.com/gold-bruin-237907.appspot.com/1590032783606-f11c50ab-b5db-45d5-a6d1-969da850cfc3.jpg")]
    static var defaultHostLists:[ProductModel] = [
        ProductModel.init(name: "PS5", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps4"),
        ProductModel.init(name: "PS5", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps4")]
    static var defaultMerchLists:[ProductModel] = [
        ProductModel.init(name: "PS5搖桿", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps5Controller"),
        ProductModel.init(name: "PS4搖桿", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps4Controller"),
        ProductModel.init(name: "PS5搖桿", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps5Controller"),
        ProductModel.init(name: "PS4搖桿", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps4Controller"),
        ProductModel.init(name: "PS5搖桿", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps5Controller"),
        ProductModel.init(name: "PS4搖桿", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps4Controller"),
        ProductModel.init(name: "PS5搖桿", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps5Controller"),
        ProductModel.init(name: "PS4搖桿", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps4Controller"),
        ProductModel.init(name: "PS5搖桿", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps5Controller"),
        ProductModel.init(name: "PS4搖桿", house: "信義", money: 555, date: "2020-12-12", imgUrl: "ps4Controller"),]
}

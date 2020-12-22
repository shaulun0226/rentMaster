//
//  ContractListModel.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/13.
//

import Foundation

struct ProductModel {
    var name:String
    var discription:String
    var price:Int
    var date:String
    var imgUrl:String
}
extension ProductModel{
    static var defaultGameLists:[ProductModel] = [
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 555, date: "2020-12-12", imgUrl: "monsterhunter2"),
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 555, date: "2020-12-12", imgUrl: "monsterhunter2"),
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 555, date: "2020-12-12", imgUrl: "monsterhunter2"),
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 555, date: "2020-12-12", imgUrl: "monsterhunter"),
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 555, date: "2020-12-12", imgUrl: "monsterhunter"),
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 555, date: "2020-12-12", imgUrl: "monsterhunter"),
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 555, date: "2020-12-12", imgUrl: "monsterhunter"),
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 555, date: "2020-12-12", imgUrl: "https://storage.googleapis.com/gold-bruin-237907.appspot.com/1590032783606-f11c50ab-b5db-45d5-a6d1-969da850cfc3.jpg"),
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 555, date: "2020-12-12", imgUrl: "https://storage.googleapis.com/gold-bruin-237907.appspot.com/1590032783606-f11c50ab-b5db-45d5-a6d1-969da850cfc3.jpg"),
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 555, date: "2020-12-12", imgUrl: "https://storage.googleapis.com/gold-bruin-237907.appspot.com/1590032783606-f11c50ab-b5db-45d5-a6d1-969da850cfc3.jpg"),
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 555, date: "2020-12-12", imgUrl: "https://storage.googleapis.com/gold-bruin-237907.appspot.com/1590032783606-f11c50ab-b5db-45d5-a6d1-969da850cfc3.jpg"),
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 777, date: "2020-12-12", imgUrl: "https://storage.googleapis.com/gold-bruin-237907.appspot.com/1590032783606-f11c50ab-b5db-45d5-a6d1-969da850cfc3.jpg"),
        ProductModel.init(name: "MonsterHunter", discription: "派對遊戲，便宜租", price: 666, date: "2020-12-12", imgUrl: "https://storage.googleapis.com/gold-bruin-237907.appspot.com/1590032783606-f11c50ab-b5db-45d5-a6d1-969da850cfc3.jpg")]
    static var defaultHostLists:[ProductModel] = [
        ProductModel.init(name: "PS5", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps4"),
        ProductModel.init(name: "PS5", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", discription: "信義", price: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS5", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", discription: "信義", price: 555, date: "2020-12-12", imgUrl: "ps5"),ProductModel.init(name: "PS5", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", discription: "信義", price: 555, date: "2020-12-12", imgUrl: "ps5"),ProductModel.init(name: "PS5", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", discription: "信義", price: 555, date: "2020-12-12", imgUrl: "ps5"),ProductModel.init(name: "PS5", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", discription: "信義", price: 555, date: "2020-12-12", imgUrl: "ps5"),ProductModel.init(name: "PS5", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", discription: "信義", price: 555, date: "2020-12-12", imgUrl: "ps5"),ProductModel.init(name: "PS5", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", discription: "信義", price: 555, date: "2020-12-12", imgUrl: "ps5"),ProductModel.init(name: "PS5", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps5"),
        ProductModel.init(name: "PS4", discription: "主機", price: 555, date: "2020-12-12", imgUrl: "ps4"),ProductModel.init(name: "PS5", discription: "信義", price: 555, date: "2020-12-12", imgUrl: "ps5"),
        ]
    static var defaultMerchLists:[ProductModel] = [
        ProductModel.init(name: "PS5搖桿", discription: "PS5搖桿", price: 555, date: "2020-12-12", imgUrl: "ps5Controller"),
        ProductModel.init(name: "PS4搖桿", discription: "PS4搖桿", price: 555, date: "2020-12-12", imgUrl: "ps4Controller"),
        ProductModel.init(name: "PS5搖桿", discription: "PS5搖桿", price: 555, date: "2020-12-12", imgUrl: "ps5Controller"),
        ProductModel.init(name: "PS4搖桿", discription: "PS4搖桿", price: 555, date: "2020-12-12", imgUrl: "ps4Controller"),
        ProductModel.init(name: "PS5搖桿", discription: "PS5搖桿", price: 555, date: "2020-12-12", imgUrl: "ps5Controller"),
        ProductModel.init(name: "PS4搖桿", discription: "PS4搖桿", price: 555, date: "2020-12-12", imgUrl: "ps4Controller"),
        ProductModel.init(name: "PS5搖桿", discription: "PS5搖桿", price: 555, date: "2020-12-12", imgUrl: "ps5Controller"),
        ProductModel.init(name: "PS4搖桿", discription: "PS4搖桿", price: 555, date: "2020-12-12", imgUrl: "ps4Controller"),
        ProductModel.init(name: "PS5搖桿", discription: "PS5搖桿", price: 555, date: "2020-12-12", imgUrl: "ps5Controller"),
        ProductModel.init(name: "PS4搖桿", discription: "PS4搖桿", price: 555, date: "2020-12-12", imgUrl: "ps4Controller"),
        ProductModel.init(name: "PS5搖桿", discription: "PS5搖桿", price: 555, date: "2020-12-12", imgUrl: "ps5Controller"),
        ProductModel.init(name: "PS4搖桿", discription: "PS4搖桿", price: 555, date: "2020-12-12", imgUrl: "ps4Controller"),
        ProductModel.init(name: "PS5搖桿", discription: "PS5搖桿", price: 555, date: "2020-12-12", imgUrl: "ps5Controller"),
        ProductModel.init(name: "PS4搖桿", discription: "PS4搖桿", price: 555, date: "2020-12-12", imgUrl: "ps4Controller")]
}

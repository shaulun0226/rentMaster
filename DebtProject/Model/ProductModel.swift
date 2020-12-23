//
//  ContractListModel.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/13.
//

import Foundation

struct ProductModel {
    var title:String
    var description:String
    var isSale:Bool
    var isRent:Bool
    var deposit:Int
    var rent:Int
    var salePrice:Int
    var rentMethod:String
    var amount:Int
    var type1:String
    var type2:String
    var userId:String
    var pics:[String]
}
extension ProductModel{
    static var defaultGameLists:[ProductModel] = [
        ProductModel.init(title: "MonsterHunter", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 999, rentMethod: "7-11店到店", amount: 1, type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter"]),
        ProductModel.init(title: "MonsterHunter", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 999, rentMethod: "7-11店到店", amount: 1, type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter"]),
        ProductModel.init(title: "MonsterHunter", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 999, rentMethod: "7-11店到店", amount: 1, type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter"]),
        ProductModel.init(title: "MonsterHunter", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 999, rentMethod: "7-11店到店", amount: 1, type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter"]),
        ProductModel.init(title: "MonsterHunter", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 666, rentMethod: "7-11店到店", amount: 1, type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter2"]),
        ProductModel.init(title: "MonsterHunter2", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 666, rentMethod: "全家店到店", amount: 1, type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter2"]),
        ProductModel.init(title: "MonsterHunter", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 666, rentMethod: "7-11店到店", amount: 1, type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter2"]),
        ProductModel.init(title: "MonsterHunter", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 666, rentMethod: "7-11店到店", amount: 1, type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter2"]),
        ]
    static var defaultHostLists:[ProductModel] = [
        
        ]
    static var defaultMerchLists:[ProductModel] = [
        ]
}

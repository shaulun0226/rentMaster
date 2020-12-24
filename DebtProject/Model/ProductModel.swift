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
    var type:String
    var type1:String
    var type2:String
    var userId:String
    var pics:[String]
}
extension ProductModel{
    static var defaultAllList:[ProductModel] = [
        ProductModel.init(title: "MonsterHunter", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 999, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter"]),
        ProductModel.init(title: "MonsterHunter2", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 999, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter2"])
        ,ProductModel.init(title: "PS5", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps5"]),
        ProductModel.init(title: "PS4", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps4"]),
        ProductModel.init(title: "PS5搖桿", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps5Controller"]),
        ProductModel.init(title: "PS4搖桿", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps4Controller"]),
    ]
    static var defaultGameLists:[ProductModel] = [
        ProductModel.init(title: "MonsterHunter", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 999, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter"]),
        ProductModel.init(title: "MonsterHunter2", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 999, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter2"])
        ,ProductModel.init(title: "MonsterHunter3", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 993219, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter"])
        ,ProductModel.init(title: "MonsterHunter4", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 1111, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter2"])
        ,ProductModel.init(title: "MonsterHunter5", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 994449, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter"])
        ,ProductModel.init(title: "MonsterHunter6", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 92399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter2"])
        ,ProductModel.init(title: "MonsterHunter7", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["monsterhunter"]),
        ]
    static var defaultHostLists:[ProductModel] = [
        ProductModel.init(title: "PS5", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps5"]),
        ProductModel.init(title: "PS4", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps4"]),
        ProductModel.init(title: "PS5d", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps5"]),
        ProductModel.init(title: "PS4", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps4"]),
        ProductModel.init(title: "PS5", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps5"]),
        ProductModel.init(title: "PS4", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps4"]),
        ProductModel.init(title: "PS5", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps5"]),
        ProductModel.init(title: "PS4", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps4"]),
        ProductModel.init(title: "PS5", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps5"]),
        ProductModel.init(title: "PS4", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps4"]),
        ]
    static var defaultMerchLists:[ProductModel] = [
            ProductModel.init(title: "PS5搖桿", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps5Controller"]),
            ProductModel.init(title: "PS4搖桿", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps4Controller"]),
        
                ProductModel.init(title: "PS5搖桿", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps5Controller"]),
                ProductModel.init(title: "PS4搖桿", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps4Controller"]),
        
                ProductModel.init(title: "PS5搖桿", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps5Controller"]),
                ProductModel.init(title: "PS4搖桿", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps4Controller"]),
                ProductModel.init(title: "PS5搖桿", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps5Controller"]),
                ProductModel.init(title: "PS4搖桿", description: "便宜租", isSale: true, isRent: true, deposit: 500, rent: 10, salePrice: 912399, rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: ["ps4Controller"]),
        ]
}

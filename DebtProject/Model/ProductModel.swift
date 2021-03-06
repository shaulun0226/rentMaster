//
//  ContractListModel.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/13.
//

import Foundation

struct ProductModel {
    var id:String
    var title:String
    var description:String
    var isSale:Bool
    var isRent:Bool
    var isExchange:Bool
    var deposit:Int
    var rent:Int
    var salePrice:Int
    var address:String
    var rentMethod:String
    var amount:Int
    var type:String
    var type1:String
    var type2:String
    var userId:String
    var pics:[PicModel]
    var weightPrice:Float
}
struct PicModel{
    var id:String
    var path:String
    var productId:String
}
struct TradeItem {
    var id:String
    var exchangeItem:String
}
extension ProductModel{
    static var defaultAllList:[ProductModel] = [
        ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "MonsterHunter", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 999, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: [PicModel.init(id: "asdas", path: "monsterhunter", productId: "asdasd"),PicModel.init(id: "asdas", path: "monsterhunter2", productId: "asdasd")], weightPrice: 1.5),
        ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "MonsterHunter2", description: "便宜租", isSale: true, isRent: true, isExchange: false, deposit: 500, rent: 10, salePrice: 999, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",  pics: [PicModel.init(id: "asdas", path: "monsterhunter", productId: "asdasd"),PicModel.init(id: "asdas", path: "monsterhunter2", productId: "asdasd")], weightPrice: 1.5)
        ,ProductModel.init(id: " 08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS5", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",  pics: [PicModel.init(id: "asdas", path: "ps5", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4", productId: "asdasd")], weightPrice: 1.5),
        ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS4", description: "便宜租", isSale: true, isRent: true, isExchange: false, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: [PicModel.init(id: "asdas", path: "ps5", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4", productId: "asdasd")], weightPrice: 1.5),
        ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS5搖桿", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",pics: [PicModel.init(id: "asdas", path: "ps5Controller", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4Controller", productId: "asdasd")], weightPrice: 1.5),
        ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS5搖桿", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",pics: [PicModel.init(id: "asdas", path: "ps5Controller", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4Controller", productId: "asdasd")], weightPrice: 1.5),
    ]
    static var defaultGameLists:[ProductModel] = [
        ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "MonsterHunter", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 999, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",  pics: [PicModel.init(id: "asdas", path: "monsterhunter", productId: "asdasd"),PicModel.init(id: "asdas", path: "monsterhunter2", productId: "asdasd")], weightPrice: 1.5),
        ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "MonsterHunter2", description: "便宜租", isSale: true, isRent: true, isExchange: false, deposit: 500, rent: 10, salePrice: 999, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",  pics: [PicModel.init(id: "asdas", path: "monsterhunter", productId: "asdasd"),PicModel.init(id: "asdas", path: "monsterhunter2", productId: "asdasd")], weightPrice: 1.5)
        ,ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "MonsterHunter3", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 993219, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",  pics: [PicModel.init(id: "asdas", path: "monsterhunter", productId: "asdasd"),PicModel.init(id: "asdas", path: "monsterhunter2", productId: "asdasd")], weightPrice: 1.5)
        ,ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "MonsterHunter4", description: "便宜租", isSale: true, isRent: true, isExchange: false, deposit: 500, rent: 10, salePrice: 1111, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",  pics: [PicModel.init(id: "asdas", path: "monsterhunter", productId: "asdasd"),PicModel.init(id: "asdas", path: "monsterhunter2", productId: "asdasd")], weightPrice: 1.5)
        ,ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "MonsterHunter5", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 994449, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",  pics: [PicModel.init(id: "asdas", path: "monsterhunter", productId: "asdasd"),PicModel.init(id: "asdas", path: "monsterhunter2", productId: "asdasd")], weightPrice: 1.5)
        ,ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "MonsterHunter6", description: "便宜租", isSale: true, isRent: true, isExchange: false, deposit: 500, rent: 10, salePrice: 92399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",  pics: [PicModel.init(id: "asdas", path: "monsterhunter", productId: "asdasd"),PicModel.init(id: "asdas", path: "monsterhunter2", productId: "asdasd")], weightPrice: 1.5)
        ,ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "MonsterHunter7", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS4", type2: "game", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",  pics: [PicModel.init(id: "asdas", path: "monsterhunter", productId: "asdasd"),PicModel.init(id: "asdas", path: "monsterhunter2", productId: "asdasd")], weightPrice: 1.5),
        ]
    static var defaultHostLists:[ProductModel] = [
        ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS5", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: [PicModel.init(id: "asdas", path: "ps5", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4", productId: "asdasd")], weightPrice: 1.5),
        ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS5", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: [PicModel.init(id: "asdas", path: "ps5", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4", productId: "asdasd")], weightPrice: 1.5),ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS5", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: [PicModel.init(id: "asdas", path: "ps5", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4", productId: "asdasd")], weightPrice: 1.5),ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS5", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a", pics: [PicModel.init(id: "asdas", path: "ps5", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4", productId: "asdasd")], weightPrice: 1.5),
        ]
    static var defaultMerchLists:[ProductModel] = [
        ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS5搖桿", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",pics: [PicModel.init(id: "asdas", path: "ps5Controller", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4Controller", productId: "asdasd")], weightPrice: 1.5),ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS5搖桿", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",pics: [PicModel.init(id: "asdas", path: "ps5Controller", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4Controller", productId: "asdasd")], weightPrice: 1.5),ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS5搖桿", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",pics: [PicModel.init(id: "asdas", path: "ps5Controller", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4Controller", productId: "asdasd")], weightPrice: 1.5),ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS5搖桿", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",pics: [PicModel.init(id: "asdas", path: "ps5Controller", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4Controller", productId: "asdasd")], weightPrice: 1.5),ProductModel.init(id: "08d8a985-1318-41a7-89f6-07efa81a6e02", title: "PS5搖桿", description: "便宜租", isSale: true, isRent: true, isExchange: true, deposit: 500, rent: 10, salePrice: 912399, address: "台北市信義區", rentMethod: "7-11店到店", amount: 1, type: "PlayStation", type1: "PS5", type2: "host", userId: "08d8a57d-545d-483e-8ed4-db1b4a16d82a",pics: [PicModel.init(id: "asdas", path: "ps5Controller", productId: "asdasd"),PicModel.init(id: "asdas", path: "ps4Controller", productId: "asdasd")], weightPrice: 1.5),
        ]
}

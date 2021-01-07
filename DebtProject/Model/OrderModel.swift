//
//  OrderModel.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/7.
//

import Foundation
struct OrderModel{
    var id:String
    var p_Title:String
    var p_Desc:String
    var p_Address:String
    var p_isSale:Bool
    var p_isRent:Bool
    var p_isExchange:Bool
    var p_Deposit: Int
    var p_Rent: Int
    var p_salePrice: Int
    var p_RentMethod:String
    var p_Type: String
    var p_Type1: String
    var p_Type2: String
    var p_ownerId: String
    var p_tradeCount: Int
    var tradeMethod: Int   //(0:租 1:買 2:換)
    var orderExchangeItems: [ExchangeModel]
    var tradeQuantity:Int //(交易數量)
    var status: String
    var orderTime: String
    var payTime: String //支付時間
    var productSend: Any
    var productArrive: Any
    var productSendBack: Any
    var productGetBack: Any
    var productId: String
    var lender: String //借方
    var notes: [NoteModel]
}
struct ExchangeModel {
    var id:String
    var orderId:String
    var wishItemId:String
    var exchangeItem:String
    var packageQuantity:Int
}
struct NoteModel {
    var id:String
    var orderId:String
    var senderId: String
    var senderName: String
    var message: String
    var createTime:String
}

//
//  APIHelper.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkController{
    static private var networkController : NetworkController?
    private init() {}
    private let serverUrl = "http://35.221.140.217/api"
    //單例
    static func instance() -> NetworkController{
        if (networkController == nil){
            networkController = NetworkController()
        }
        return networkController!
    }
    //解析jason
    private func wrappingJSON(json: JSON) -> Bool{
        //取jason key=errorcode的值
        let errorCode = json["errorcode"]
        if(errorCode >= 500){
            print("\(String(describing: json["msg"].string))")
            return false
        }else if(errorCode == 200){
            return true
        }
        print("something going wrong")
        return false
    }
    
    private func textNotCode200(status: Int,value: Any){
        print("error with response status: \(status)")
//        let json = JSON(value)
//        let msg = value
        print("error msg: \(value)")
    }
    private func parseUser(json:JSON)->UserModel{
        let id = json["id"].string ?? ""
        let email = json["email"].string ?? ""
        let name = json["name"].string ?? ""
        let nickName = json["nickName"].string ?? ""
        let phone = json["phone"].string ?? ""
        let address = json["address"].string ?? ""
        let wishItemsArr = json["wishItems"].array ?? []
        var wishList = [WishItemModel]()
                for index in 0..<wishItemsArr.count{
                    let id = wishItemsArr[index]["id"].string  ?? ""
                    let userId = wishItemsArr[index]["userId"].string ?? ""
                    let wishProductName = wishItemsArr[index]["exchangeItem"].string ?? ""
                    let wishProductAmount = wishItemsArr[index]["requestQuantity"].int ?? 0
                    let wishProductWeightPrice = wishItemsArr[index]["weightPoint"].float ?? 99.0
                    wishList.append(WishItemModel.init(id: id, userId: userId, productName: wishProductName, amount: wishProductAmount, weightPrice: wishProductWeightPrice))
                }
        return UserModel.init(id: id, email: email, name: name, nickName: nickName, phone: phone, address: address, products: [], wishItems: wishList)
    }
//    private func parseWishItem(jsonArr:JSON)-> [WishItemModel]{
//        var wishListTmp = [WishItemModel]()
//        print("下訂單頁面解析願望清單,共\(jsonArr.count)項")
//        for index in 0..<jsonArr.count{
//            let id = jsonArr[index]["id"].string  ?? ""
//            let userId = jsonArr[index]["userId"].string ?? ""
//            let wishProductName = jsonArr[index]["exchangeItem"].string ?? ""
//            let wishProductAmount = jsonArr[index]["requestQuantity"].int ?? 0
//            let wishProductWeightPrice = jsonArr[index]["weightPoint"].float ?? 99.0
//            print("\(id)\(userId)\(wishProductName)\(wishProductAmount)\(wishProductWeightPrice)")
//            self.wishNameList.append(wishProductName)
//            self.wishAmountList.updateValue(wishProductAmount, forKey: wishProductName)
//            wishListTmp.append(WishItemModel.init(id: id, userId: userId, productName: wishProductName, amount: wishProductAmount, weightPrice: wishProductWeightPrice))
//        }
//        return wishListTmp
//    }
    private func parseProduct(json:JSON) -> ProductModel{
        let id = json["id"].string  ?? ""
        let title = json["title"].string  ?? ""
        let description = json["description"].string  ?? ""
        let isSale = json["isSale"].bool  ?? false
        let isRent = json["isRent"].bool  ?? false
        let isExchange = json["isExchange"].bool ?? false
        let address = json["address"].string ?? ""
        let deposit = json["deposit"].int ?? 0
        let rent = json["rent"].int ?? 0
        let salePrice = json["salePrice"].int ?? 0
        let rentMethod = json["rentMethod"].string  ?? ""
        let amount = json["amount"].int ?? 0
        let type = json["type"].string ?? ""
        let type1 = json["type1"].string  ?? ""
        let type2 = json["type2"].string ?? ""
        let userId = json["userId"].string ?? ""
        let picsArr = json["pics"].array ?? []
        let weightPrice = json["weightPrice"].float ?? 0.0
        var pics = [PicModel]()
        for index in 0..<picsArr.count{
            let id  = picsArr[index]["id"].string ?? ""
            let path  = picsArr[index]["path"].string ?? ""
            let productId  = picsArr[index]["productId"].string ?? ""
            pics.append(PicModel.init(id: id, path: path, productId: productId))
        }
       return ProductModel.init(id: id, title: title, description: description, isSale: isSale, isRent: isRent, isExchange: isExchange, deposit: deposit, rent: rent, salePrice: salePrice, address: address, rentMethod: rentMethod, amount: amount, type: type, type1: type1, type2: type2, userId: userId, pics: pics, weightPrice: weightPrice)
    }
    private func parseProductArr(jsonArr:JSON) -> [ProductModel]{
        var products = [ProductModel]()
        for index in 0..<jsonArr.count{
            let id = jsonArr[index]["id"].string ?? ""
            let title = jsonArr[index]["title"].string  ?? ""
            let description = jsonArr[index]["description"].string ?? ""
            let isSale = jsonArr[index]["isSale"].bool ?? false
            let isRent = jsonArr[index]["isRent"].bool ?? false
            let isExchange = jsonArr[index]["isExchange"].bool ?? false
            let address = jsonArr[index]["address"].string ?? ""
            let deposit = jsonArr[index]["deposit"].int ?? 0
            let rent = jsonArr[index]["rent"].int ?? 0
            let salePrice = jsonArr[index]["salePrice"].int ?? 0
            let rentMethod = jsonArr[index]["rentMethod"].string ?? ""
            let amount = jsonArr[index]["amount"].int ?? 0
            let type = jsonArr[index]["type"].string ?? ""
            let type1 = jsonArr[index]["type1"].string ?? ""
            let type2 = jsonArr[index]["type2"].string ?? ""
            let userId = jsonArr[index]["userId"].string ?? ""
            let picsArr = jsonArr[index]["pics"].array ?? []
            let weightPrice = jsonArr[index]["weightPrice"].float ?? 0.0
            
            var pics = [PicModel]()
            for index in 0..<picsArr.count{
                let id  = picsArr[index]["id"].string ?? ""
                let path  = picsArr[index]["path"].string ?? ""
                let productId  = picsArr[index]["productId"].string ?? ""
                pics.append(PicModel.init(id: id, path: path, productId: productId))
            }
            products.append(ProductModel.init(id: id, title: title, description: description, isSale: isSale, isRent: isRent, isExchange: isExchange, deposit: deposit, rent: rent, salePrice: salePrice, address: address, rentMethod: rentMethod, amount: amount, type: type, type1: type1, type2: type2, userId: userId, pics: pics, weightPrice: weightPrice))
        }
        return products
    }
    private func parseOrderArr(jsonArr:JSON) -> [OrderModel]{
        var orders = [OrderModel]()
        for index in 0..<jsonArr.count{
            let id = jsonArr[index]["id"].string ?? ""
            let p_Title = jsonArr[index]["p_Title"].string ?? ""
            let p_Desc = jsonArr[index]["p_Desc"].string ?? ""
            let p_Address = jsonArr[index]["p_Address"].string ?? ""
            let p_isSale = jsonArr[index]["p_isSale"].bool ?? false
            let p_isRent = jsonArr[index]["p_isRent"].bool ?? false
            let p_isExchange = jsonArr[index]["p_isExchange"].bool ?? false
            let p_Deposit = jsonArr[index]["p_Deposit"].int ?? 0
            let p_Rent = jsonArr[index]["p_Rent"].int ?? 0
            let p_salePrice = jsonArr[index]["p_salePrice"].int ?? 0
            let p_RentMethod = jsonArr[index]["p_RentMethod"].string ?? ""
            let p_Type = jsonArr[index]["p_Type"].string ?? ""
            let p_Type1 = jsonArr[index]["p_Type1"].string ?? ""
            let p_Type2 = jsonArr[index]["p_Type2"].string ?? ""
            let p_ownerId = jsonArr[index]["p_ownerId"].string ?? ""
            let p_weightPrice = jsonArr[index]["p_WeightPrice"].float ?? 0.0
            let tradeMethod = jsonArr[index]["tradeMethod"].int!
            let picsArr = jsonArr[index]["pics"].array ?? []
            let orderExchangeItemsArr = jsonArr[index]["orderExchangeItems"].array ?? []
            let tradeQuantity = jsonArr[index]["tradeQuantity"].int!
            let status = jsonArr[index]["status"].string ?? ""
            let orderTime = jsonArr[index]["orderTime"].string ?? ""
            let payTime = jsonArr[index]["payTime"].string ?? ""
            
            let productSend = jsonArr[index]["productSend"].object
            let productArrive = jsonArr[index]["productArrive"].string ?? ""
            let productSendBack = jsonArr[index]["productSendBack"].string ?? ""
            let productGetBack = jsonArr[index]["productGetBack"].string ?? ""
            let productId = jsonArr[index]["productId"].string ?? ""
            let lender = jsonArr[index]["lender"].string ?? ""
            
            let notesArr = jsonArr[index]["notes"].array ?? []
            var pics = [PicModel]()
            for index in 0..<picsArr.count{
                let id = picsArr[index]["id"].string ?? ""
                let path = picsArr[index]["path"].string ?? ""
                let productId = picsArr[index]["productId"].string ?? ""
                pics.append(PicModel.init(id: id, path: path, productId: productId))
            }
            var orderExchangeItems = [ExchangeModel]()
            for index in 0..<orderExchangeItemsArr.count{
                let id  = orderExchangeItemsArr[index]["id"].string ?? ""
                let orderId  = orderExchangeItemsArr[index]["orderId"].string ?? ""
                let wishItemId  = orderExchangeItemsArr[index]["wishItemId"].string ?? ""
                let exchangeItem  = orderExchangeItemsArr[index]["exchangeItem"].string ?? ""
                let packageQuantity  = orderExchangeItemsArr[index]["packageQuantity"].int ?? 0
                orderExchangeItems.append(ExchangeModel.init(id: id, orderId: orderId, wishItemId: wishItemId, exchangeItem: exchangeItem, packageQuantity: packageQuantity))
            }
            var notes = [NoteModel]()
            for index in 0..<notesArr.count{
                let id  = notesArr[index]["id"].string ?? ""
                let orderId  = notesArr[index]["orderId"].string ?? ""
                let senderId  = notesArr[index]["senderId"].string ?? ""
                let senderName  = notesArr[index]["senderName"].string ?? ""
                let message  = notesArr[index]["message"].string ?? ""
                let createTime  = notesArr[index]["createTime"].string ?? ""
                notes.append(NoteModel.init(id: id, orderId: orderId, senderId: senderId, senderName: senderName, message: message, createTime: createTime))
            }
            orders.append(OrderModel.init(id: id, p_Title: p_Title, p_Desc: p_Desc, p_Address: p_Address, p_isSale: p_isSale, p_isRent: p_isRent, p_isExchange: p_isExchange, p_Deposit: p_Deposit, p_Rent: p_Rent, p_salePrice: p_salePrice, p_RentMethod: p_RentMethod, p_Type: p_Type, p_Type1: p_Type1, p_Type2: p_Type2, p_ownerId: p_ownerId, p_weightPrice: p_weightPrice,pics:pics, tradeMethod: tradeMethod, orderExchangeItems: orderExchangeItems, tradeQuantity: tradeQuantity, status: status, orderTime: orderTime, payTime: payTime, productSend: productSend, productArrive: productArrive, productSendBack: productSendBack, productGetBack: productGetBack, productId: productId, lender: lender, notes: notes))
        }
        return orders
    }
    // MARK: - memberCenter
    func login(email:String,password:String,deviceToken:String,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Users/login";
        let parameter: [String: String] = ["Email":email,"Password":password,"DeviceToken":deviceToken]
        print(parameter)
        AF.request(url,method: .post,parameters: parameter,encoding:JSONEncoding.default)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func register(email:String,verityCode:String,password:String,name:String,phone:String,completionHandler:@escaping (_ status :String,Bool) -> ()){
        let url = "\(serverUrl)/Users/register";
        let parameters: Parameters = ["Email":email,"VerityCode":verityCode,"Password":password,"Name":name,"Phone":phone]
        AF.request(url,method: .post,parameters: parameters,encoding:JSONEncoding.default,headers: nil)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    print("連線成功")
                    //當響應成功時，使用臨時變數value接收伺服器返回的資訊並判斷是否為[String: AnyObject]型別，如果是那麼將其傳給定義方法中的success
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            print("success")
                            print(value)
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler(error.localizedDescription,false)
                    break
                    
                }
            }
    }
    
    func forgotPassword(email:String,verityCode:String,newPassword:String,completionHandler:@escaping (_ :String,Bool) -> ()){
        let url = "\(serverUrl)/Users/security/vp";
        let parameters: Parameters = ["Email":email,"VerityCode":verityCode,"NewPassword":newPassword]
        AF.request(url,method: .post,parameters: parameters,encoding:JSONEncoding.default)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    print("連線成功")
                    //當響應成功時，使用臨時變數value接收伺服器返回的資訊並判斷是否為[String: AnyObject]型別，如果是那麼將其傳給定義方法中的success
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            print("success")
                            print(value)
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler(error.localizedDescription,false)
                    break
                    
                }
            }
    }
    func changePasswordByTokenAnd(oldPassword:String,newPassword:String,completionHandler:@escaping (_ :String,Bool) -> ()){
        let url = "\(serverUrl)/Users/security/op";
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        let parameters: Parameters = ["OldPassword":oldPassword,"NewPassword":newPassword]
        AF.request(url,method: .post,parameters: parameters,encoding:JSONEncoding.default,headers: header)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    print("連線成功")
                    //當響應成功時，使用臨時變數value接收伺服器返回的資訊並判斷是否為[String: AnyObject]型別，如果是那麼將其傳給定義方法中的success
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            print("success")
                            print(value)
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler(error.localizedDescription,false)
                    break
                    
                }
            }
    }
    func changeUserInfo(name:String,nickName:String,phone:String,address:String,completionHandler:@escaping (Bool) -> ()){
        let url = "\(serverUrl)/Users/info";
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        let parameters: Parameters = ["name":name,"nickName":nickName,"phone":phone,"address":address]
        print("傳出去\(parameters)")
        AF.request(url,method: .patch,parameters: parameters,encoding:JSONEncoding.default,headers: header)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    print("連線成功")
                    //當響應成功時，使用臨時變數value接收伺服器返回的資訊並判斷是否為[String: AnyObject]型別，如果是那麼將其傳給定義方法中的success
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            print("success")
                            print(value)
                            completionHandler(true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler(false)
                    break
                    
                }
            }
    }
    func getUserInfo(completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Users/info";
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        AF.request(url,method: .get,encoding:JSONEncoding.default,headers: header)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            let json = JSON(value)
                            let user = self.parseUser(json: json)
                            completionHandler(user,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func getUserBasicInfo(userId:String,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Users/baseinfo/\(userId)";
        AF.request(url,method: .get,encoding:JSONEncoding.default)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            let json = JSON(value)
                            let user = self.parseUser(json: json)
                            completionHandler(user,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func emailConfirm(email:String,completionHandler:@escaping (Bool) -> ()){
        let parameters :Parameters = ["Email":email]
        let url = "\(serverUrl)/Users/security/check";
        AF.request(url,method: .post,parameters: parameters,encoding:JSONEncoding.default)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            completionHandler(true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( false)
                    break
                }
            }
    }
    // MARK: - productList
    //產品清單區
    func getProductListByType(type:String,pageBegin:Int,pageEnd:Int,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Products/listByType/\(type)/\(pageBegin)/\(pageEnd)";
        //因為網址含有中文，需要做編碼處理
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(encodedUrl!,method: .get,encoding:JSONEncoding.default)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func getProductListByType1(type1:String,pageBegin:Int,pageEnd:Int,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Products/listByType1/\(type1)/\(pageBegin)/\(pageEnd)";
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(encodedUrl!,method: .get,encoding:JSONEncoding.default)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        } 
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func getProductListByType2(type1:String,type2:String,pageBegin:Int,pageEnd:Int,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Products/listByType2/\(type1)/\(type2)/\(pageBegin)/\(pageEnd)";
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(encodedUrl!,method: .get,encoding:JSONEncoding.default)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func getProductListBy(type:String,type1:String,type2:String,pageBegin:Int,pageEnd:Int,completionHandler:@escaping (_ :Any,Bool) -> ()){
        var typeTmp = "All"
        var type1Tmp = "All"
        var type2Tmp = "All"
        if(!type.elementsEqual("")){
            typeTmp = type
        }
        if(!type1.elementsEqual("")){
            type1Tmp = type1
        }
        if(!type2.elementsEqual("")){
            type2Tmp = type2
        }
        let url = "\(serverUrl)/Products/listBy/\(typeTmp)/\(type1Tmp)/\(type2Tmp)/\(pageBegin)/\(pageEnd)";
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(encodedUrl!,method: .get,encoding:JSONEncoding.default)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            let jsonArr =  JSON(value)
                            let products =  self.parseProductArr(jsonArr: jsonArr)
                            completionHandler(products,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func getProductListByKeyword(keyword:String,type1:String,type2:String,pageBegin:Int,pageEnd:Int,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Products/listByKeyWord/\(type1)/\(type2)/\(keyword)/\(pageBegin)/\(pageEnd)";
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(encodedUrl!,method: .get,encoding:JSONEncoding.default)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func getProductListByTypeAndType2(type:String,type2:String,pageBegin:Int,pageEnd:Int,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Products/listByTypeNType2/\(type)/\(type2)/\(pageBegin)/\(pageEnd)";
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(encodedUrl!,method: .get,encoding:JSONEncoding.default)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
   
    func getProductListBySellerId(sellerId:String,pageBegin:Int,pageEnd:Int,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Products/listBySeller/\(sellerId)/\(pageBegin)/\(pageEnd)";
        //因為網址含有中文，需要做編碼處理
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(encodedUrl!,method: .get,encoding:JSONEncoding.default)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            let jsonArr = JSON(value)
                            let products = self.parseProductArr(jsonArr: jsonArr)
                            completionHandler(products,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func getProductById(productId:String,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Products/ById/\(productId)";
        AF.request(url,method: .get,encoding:JSONEncoding.default)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            let json = JSON(value)
                            let product = self.parseProduct(json: json)
                            completionHandler(product,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func addProduct(title:String,description:String,isSale:Bool,isRent:Bool,isExchange:Bool,deposit:Int,rent:Int,salePrice:Int,rentMethod:String,amount:Int,address:String,type:String,type1:String,type2:String,pics:[UIImage],weightPrice:Float,completionHandler:@escaping (_ status :String,Bool) -> ()){
        var picsJsonArr = [Parameters]()
        for index in 0..<pics.count{
            //先拿到imageDate (設定圖片質量為原圖的0.9)
            let imageData = pics[index].jpegData(compressionQuality: 0.7)
            //將imageData轉為base64
            let imageBase64String = imageData?.base64EncodedString()
//            let pic:Parameters = ["Desc":title+"_"+String(index+1),"Path":imageBase64String ?? ""]
            let pic:Parameters = ["Desc":"\(title)_\(index+1)","Path":imageBase64String ?? ""]
            picsJsonArr.append(pic)
        }
        
        let parameters :Parameters = ["Title":title,"Description":description,"isSale":isSale,"isRent":isRent,"isExchange":isExchange,"Deposit":deposit,"Rent":rent,"salePrice":salePrice,"RentMethod":rentMethod,"amount":amount,"Address":address,"Type":type,"Type1":type1,"Type2":type2,"pics":picsJsonArr,"weightPrice":weightPrice]
        print(parameters)
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        let url = "\(serverUrl)/Products/add";
        AF.request(url,method: .post,parameters: parameters,encoding:JSONEncoding.default, headers: header)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler(error.localizedDescription, false)
                    break
                }
            }
    }
    func productModify(id:String,title:String,description:String,isSale:Bool,isRent:Bool,isExchange:Bool,deposit:Int,rent:Int,salePrice:Int,rentMethod:String,amount:Int,address:String,type:String,type1:String,type2:String,oldPics:[PicModel],pics:[UIImage],weightPrice:Float,completionHandler:@escaping (_ status :String,Bool) -> ()){
        var picsJsonArr = [Parameters]()
        for index in 0..<oldPics.count{
            let pic:Parameters = ["Id":oldPics[index].id]
            picsJsonArr.append(pic)
        }
        for index in 0..<pics.count{
            //先拿到imageDate (設定圖片質量為原圖的0.9)
            let imageData = pics[index].jpegData(compressionQuality: 0.9)
            //將imageData轉為base64
            let imageBase64String = imageData?.base64EncodedString()
            let pic:Parameters = ["Desc":"\(title)_\(index+1)","Path":imageBase64String ?? ""]
            picsJsonArr.append(pic)
        }
        let parameters :Parameters = ["Id":id,"Title":title,"Description":description,"isSale":isSale,"isRent":isRent,"isExchange":isExchange,"Deposit":deposit,"Rent":rent,"salePrice":salePrice,"RentMethod":rentMethod,"amount":amount,"Address":address,"Type":type,"Type1":type1,"Type2":type2,"pics":picsJsonArr,"weightPrice":weightPrice]
        print(parameters)
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        let url = "\(serverUrl)/Products/modify";
        AF.request(url,method: .patch ,parameters: parameters,encoding:JSONEncoding.default, headers: header)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler(error.localizedDescription, false)
                    break
                }
            }
    }
    //MARK:- ownItem 我的賣場
    func getMyOwnItem(completionHandler:@escaping (_ :Any,Bool) -> ()){
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        let url = "\(serverUrl)/Products/ownItem";
        AF.request(url,method: .get,encoding:JSONEncoding.default,headers: header)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func getMyOwnItemOnShelf(completionHandler:@escaping (_ :Any,Bool) -> ()){
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        let url = "\(serverUrl)/Products/ownItemOnShelf";
        AF.request(url,method: .get,encoding:JSONEncoding.default,headers: header)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            let jsonArr = JSON(value)
                            let products =  self.parseProductArr(jsonArr: jsonArr)
                            completionHandler(products,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func getMyOwnItemNotOnShelf(completionHandler:@escaping (_ :Any,Bool) -> ()){
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        let url = "\(serverUrl)/Products/ownItemNotOnShelf";
        AF.request(url,method: .get,encoding:JSONEncoding.default,headers: header)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            let jsonArr = JSON(value)
                            let products =  self.parseProductArr(jsonArr: jsonArr)
                            completionHandler(products,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error, false)
                    break
                }
            }
    }
    func deleteMyOwnItem(id:String,completionHandler:@escaping (_ :String,Bool) -> ()){
        let url = "\(serverUrl)/Products/ownItem/\(id)";
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        AF.request(url,method: .delete,encoding:JSONEncoding.default,headers: header)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            
                            print(value)
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
    
    // MARK: - WishList
    func getWishItemAll(completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Users/wishlist/All";
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        AF.request(url,method: .get,encoding:JSONEncoding.default,headers: header)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
    func addWishItem(wishProductName:String,wishProductAmount:Int,wishProductWeightPrice:Float,completionHandler:@escaping (_ :String,Bool) -> ()){
        let url = "\(serverUrl)/Users/wishlist/new";
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        let parameters: Parameters = ["ExchangeItem":wishProductName,"RequestQuantity":wishProductAmount,"WeightPoint":wishProductWeightPrice]
        AF.request(url,method: .post,parameters: parameters,encoding:JSONEncoding.default,headers: header)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            
                            print(value)
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
    func deleteWishItem(id:String,completionHandler:@escaping (_ :String,Bool) -> ()){
        let url = "\(serverUrl)/Users/wishlist/\(id)";
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        AF.request(url,method: .delete,encoding:JSONEncoding.default,headers: header)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            
                            print(value)
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
    // MARK: - OrderList
    //訂單清單區
    func addOrder(productId:String,tradeMethod:Int,tradeItems:[WishItemModel],tradeQuantity:Int,completionHandler:@escaping (_ :String,Bool) -> ()){
        let url = "\(serverUrl)/Orders/add";
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        var orderExchangeItems = [Parameters]()
        for index in 0..<tradeItems.count{
            let tradeItemId = tradeItems[index].id
            let tradeItemAmount = tradeItems[index].amount
            let orderExchangeItem:Parameters = ["WishItemId":tradeItemId,"packageQuantity":tradeItemAmount]
            orderExchangeItems.append(orderExchangeItem)
        }
        let parameters: Parameters = ["ProductId":productId,"TradeMethod":tradeMethod,"OrderExchangeItems":orderExchangeItems,"TradeQuantity":tradeQuantity]
        print(parameters)
        AF.request(url,method: .post,parameters: parameters,encoding:JSONEncoding.default,headers: header)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
    func getMyOrderById(id:String,completionHandler:@escaping (_ :String,Bool) -> ()){
        let url = "\(serverUrl)/Orders/\(id)";
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        AF.request(encodedUrl!,method: .get,encoding:JSONEncoding.default,headers: header)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        switch(status){
                        case 200:
                            //to get JSON return value
                            let json = JSON(value)
                            let orderName = json["p_Title"].string ?? ""
                            completionHandler(orderName,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler("",false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
    func getMyOrderListBuyer(status:String,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Orders/Mylist/buyer/\(status)";
        //因為網址含有中文，需要做編碼處理
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        AF.request(encodedUrl!,method: .get,encoding:JSONEncoding.default,headers: header)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        switch(status){
                        case 200:
                            let jsonArr = JSON(value)
                            let orders = self.parseOrderArr(jsonArr: jsonArr)
                            completionHandler(orders,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
    func getMyOrderListSeller(status:String,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Orders/Mylist/seller/\(status)";
        //因為網址含有中文，需要做編碼處理
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        AF.request(encodedUrl!,method: .get,encoding:JSONEncoding.default,headers: header)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        switch(status){
                        case 200:
                            //to get JSON return value
                            let jsonArr = JSON(value)
                            let orders = self.parseOrderArr(jsonArr: jsonArr)
                            completionHandler(orders,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
    func changeOrdersStatus(id:String,status:String,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Orders/status/\(id)/\(status)";
        //因為網址含有中文，需要做編碼處理
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        AF.request(encodedUrl!,method: .patch,encoding:JSONEncoding.default,headers: header)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            print(value)
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
    //MARK: - Cart
    func addCart(productId:String,completionHandler:@escaping (_ :String,Bool) -> ()){
        let url = "\(serverUrl)/CartItems/add";
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        let parameters: Parameters = ["ProductId":productId]
        AF.request(url,method: .post,parameters: parameters,encoding:JSONEncoding.default,headers: header)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
    func getCartList(completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/CartItems/productList";
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        AF.request(url,method: .get,encoding:JSONEncoding.default,headers: header)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            let jsonArr = JSON(value)
                            let products = self.parseProductArr(jsonArr: jsonArr)
                            completionHandler(products,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
    func deleteCartItem(id:String,completionHandler:@escaping (_ :String,Bool) -> ()){
        let url = "\(serverUrl)/CartItems/\(id)";
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        AF.request(url,method: .delete,encoding:JSONEncoding.default,headers: header)
            .responseString{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        case 200:
                            //to get JSON return value
                            
                            print(value)
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
    
//MARK:- Note
    func addNote(orderId:String,message:String,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Notes/add";
        let header : HTTPHeaders = ["Authorization" : "bearer \(User.token)"]
        let parameters: Parameters = ["OrderId":orderId,"Message":message]
        AF.request(url,method: .post,parameters: parameters,encoding:JSONEncoding.default,headers: header)
            .responseJSON{ response in
                switch response.result {
                //先看連線有沒有成功
                case.success(let value):
                    //再解析errorCode
                    if let status = response.response?.statusCode {
                        print(status)
                        switch(status){
                        
                        case 200:
                            //to get JSON return value
                            completionHandler(value,true)
                            break
                        default:
                            self.textNotCode200(status: status, value: value)
                            completionHandler(value,false)
                            break
                        }
                    }
                case .failure(let error):
                    print("error:\(error)")
                    completionHandler( error.localizedDescription, false)
                    break
                }
            }
    }
}



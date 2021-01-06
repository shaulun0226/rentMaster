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
    // MARK: - memberCenter
    func login(email:String,password:String,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Users/login";
        let parameter: [String: String] = ["Email":email,"Password":password]
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
    func getOwnitem(completionHandler:@escaping (_ :Any,Bool) -> ()){
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
}



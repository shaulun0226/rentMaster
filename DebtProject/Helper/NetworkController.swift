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
        let json = JSON(value)
        let msg = json["msg"]
        print("error mag: \(msg)")
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
    func getProductListByType2(type1:String,type2:String,pageBegin:Int,pageEnd:Int,completionHandler:@escaping (_ :Any,Bool) -> ()){
        let url = "\(serverUrl)/Products/listByType2/\(type1)/\(type2)/\(pageBegin)/\(pageEnd)";
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
    func addProduct(title:String,description:String,isSale:Bool,isRent:Bool,isExchange:Bool,deposit:Int,rent:Int,salePrice:Int,rentMethod:String,amount:Int,address:String,type:String,type1:String,type2:String,pics:[UIImage],trideItems:[String],completionHandler:@escaping (_ status :String,Bool) -> ()){
        var picsJsonArr = [Parameters]()
        for index in 0..<pics.count{
            //先拿到imageDate (設定圖片質量為原圖的0.9)
            let imageData = pics[index].jpegData(compressionQuality: 0.9)
            //將imageData轉為base64
            let imageBase64String = imageData?.base64EncodedString()
//            let pic:Parameters = ["Desc":title+"_"+String(index+1),"Path":imageBase64String ?? ""]
            let pic:Parameters = ["Desc":"\(title)_\(index+1)","Path":imageBase64String ?? ""]
            picsJsonArr.append(pic)
        }
        var trideItemsJsonArr = [Parameters]()
        print(trideItems.count)
        print(trideItems[0])
        for index in 0..<trideItems.count{
            let trideItems:Parameters = ["ExchangeItem":"\(trideItems[index])"]
            trideItemsJsonArr.append(trideItems)
        }
        print(trideItemsJsonArr)
        let parameters :Parameters = ["Title":title,"Description":description,"isSale":isSale,"isRent":isRent,"isExchange":isExchange,"Deposit":deposit,"Rent":rent,"salePrice":salePrice,"RentMethod":rentMethod,"amount":amount,"Address":address,"Type":type,"Type1":type1,"Type2":type2,"pics":picsJsonArr,"TrideItems":trideItemsJsonArr]
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
    //     這裡傳入的匿名內部類 handler:@escaping (Bool) -> () 要是逃逸閉包，因為 AF.request 後面的閉包是逃逸閉包，只有逃逸閉包能在逃逸閉包裡使用
    //        func getNewestEpisodeList(userID:Int, handler:@escaping (Bool) -> ()) { // 帶進來的 bool 參數（此寫法可不用帶兩個閉包進去）
    //            AF.request("\(serverUrl)PodcastRSS/GetNewestList?userId=\(userID)").responseJSON { (data) in
    //                switch data.result {
    //                case .success: // 連線成功時
    //                    let json = try! JSON(data: data.data!)
    //                    if(self.wrappingJSON(json: json)){
    //                        let jsonArr = json["msg"]
    //                        let showingPlaylist = ShowingPlaylist.instance()
    //                        showingPlaylist.clear()
    //                        for index in 0...jsonArr.count - 1 {
    //                            showingPlaylist.add(episode: Episode(id: jsonArr[index]["podcastRSSId"].int!, title: jsonArr[index]["title"].string!, author: jsonArr[index]["author"].string!, img: jsonArr[index]["imgLink"].string!, duration: jsonArr[index]["duration"].int!, pubDate: jsonArr[index]["pubdate"].string!, mp3: jsonArr[index]["mp3Link"].string!, desc: jsonArr[index]["description"].string!, timestamp: jsonArr[index]["timestamp"].int!, isCollect: jsonArr[index]["isCollect"].bool!, isToListen: jsonArr[index]["isToListen"].bool!))
    //                        }
    //                        PlayingPlaylist.instance().add(showingPlaylist: ShowingPlaylist.instance().getPlaylist())
    //                    }
    //                    handler(true)
    //                    break;
    //                case .failure: // 連線失敗時
    //                    handler(false)
    //                    break;
    //                }
    //            }
    //        }
    //
    //        func getHashTagList( handler:@escaping (Bool) -> ()){
    //            AF.request("\(serverUrl)PodcastRSS/GetAllTag").responseJSON { (data) in
    //                switch data.result {
    //                case .success: // 連線成功時
    //                    let json = try! JSON(data: data.data!)
    //                    if(self.wrappingJSON(json: json)){
    //                        let jsonArr = json["msg"]
    //                        let hashtagList = HashtagList.instance()
    //
    //                        for index in 0...jsonArr.count - 1 {
    //                            hashtagList.add(hashtag: Hashtag(name: jsonArr[index]["hashTag"].string!, hashtagID: jsonArr[index]["hashTagId"].int!))
    //                        }
    //                    }
    //                    handler(true)
    //                    break;
    //                case .failure: // 連線失敗時
    //                    handler(false)
    //                    break;
    //                }
    //            }
    //        }
    //
    //    func getHashTagEpisodeList(userID:Int, hashID: Int, handler:@escaping (Bool) -> ()) { // 帶進來的 bool 參數（此寫法可不用帶兩個閉包進去）
    //        AF.request("\(serverUrl)PodcastRSS/GetTagList?userId=\(userID)&hashtagId=\(hashID)").responseJSON { (data) in
    //
    //            switch data.result {
    //            case .success: // 連線成功時
    //                let json = try! JSON(data: data.data!)
    //                if(self.wrappingJSON(json: json)){
    //                    let jsonArr = json["msg"]
    //                    let showingPlaylist = ShowingPlaylist.instance()
    //                    showingPlaylist.clear()
    //                    for index in 0...jsonArr.count - 1 {
    //                        showingPlaylist.add(episode: Episode(id: jsonArr[index]["podcastRSSId"].int!, title: jsonArr[index]["title"].string!, author: jsonArr[index]["author"].string!, img: jsonArr[index]["imgLink"].string!, duration: jsonArr[index]["duration"].int!, pubDate: jsonArr[index]["pubdate"].string!, mp3: jsonArr[index]["mp3Link"].string!, desc: jsonArr[index]["description"].string!, timestamp: jsonArr[index]["timestamp"].int!, isCollect: jsonArr[index]["isCollect"].bool!, isToListen: jsonArr[index]["isToListen"].bool!))
    //                    }
    //                    PlayingPlaylist.instance().add(showingPlaylist: ShowingPlaylist.instance().getPlaylist())
    //                }
    //                handler(true)
    //                break;
    //            case .failure: // 連線失敗時
    //                handler(false)
    //                break;
    //            }
    //        }
    //    }
    //
    
    //
    //    func addCollect(userId: Int,RSSId: Int,completionHandler: @escaping(_ result: Bool) -> ()){
    //        let afUrl = "\(serverUrl)user/collect"
    //        let parameter: Parameters = ["usersId":(userId),"podcastRSSId":(RSSId)]
    //        AF.request(afUrl,method: .post,parameters: parameter)
    //            .responseJSON{ response in
    //                switch response.result {
    //                case.success(let value):
    //                    if let status = response.response?.statusCode {
    //                        switch(status){
    //                        case 200:
    //                            //to get JSON return value
    //                            self.textCode200(value: value)
    //                            completionHandler(true)
    //                            break
    //                        default:
    //                            self.textNotCode200(status: status, value: value)
    //                            completionHandler(false)
    //                            break
    //                        }
    //                    }
    //                case .failure(let error):
    //                    print("error:\(error)")
    //                    completionHandler(false)
    //                    break
    //                }
    //            }
    //    }
    //
    //
    //    func removeCollect(userId: Int,RSSId: Int,completionHandler: @escaping(_ result: Bool) -> ()){
    //        let afUrl = "\(serverUrl)user/collect?usersId=\(userId)&podcastRSSId=\(RSSId)"
    //        let parameter: Parameters = ["usersId":"\(userId)","podcastRSSId":"\(RSSId)"]
    //        AF.request(afUrl,method: .delete, parameters: parameter, encoding: URLEncoding.httpBody)
    //            .responseJSON{ response in
    //                switch response.result {
    //                case.success(let value):
    //                    if let status = response.response?.statusCode {
    //                        switch(status){
    //                        case 200:
    //                            //to get JSON return value
    //                            self.textCode200(value: value)
    //                            completionHandler(true)
    //                            break
    //                        default:
    //                            self.textNotCode200(status: status, value: value)
    //                            completionHandler(false)
    //                            break
    //                        }
    //                    }
    //                case .failure(let error):
    //                    print("error:\(error)")
    //                    completionHandler(false)
    //                    break
    //                }
    //            }
    //    }
    //
    //    func addComment(podcastRSSId: Int,content: String,completionHandler: @escaping(_ result: Bool) -> ()){
    //        let afUrl = "\(serverUrl)user/comment"
    //        let parameter: Parameters = ["podcastRSSId":podcastRSSId,"content":content]
    //        AF.request(afUrl,method: .post,parameters: parameter)
    //            .responseJSON{ response in
    //                switch response.result {
    //                case.success(let value):
    //                    if let status = response.response?.statusCode {
    //                        switch(status){
    //                        case 200:
    //                            //to get JSON return value
    //                            self.textCode200(value: value)
    //                            completionHandler(true)
    //                            break
    //                        default:
    //                            self.textNotCode200(status: status, value: value)
    //                            completionHandler(false)
    //                            break
    //                        }
    //                    }
    //                case .failure(let error):
    //                    print("error:\(error)")
    //                    completionHandler(false)
    //                    break
    //                }
    //            }
    //    }
    //
    //    private func analysisJSONToComments(value: Any) -> Array<Comment>{
    //        let json = JSON(value)
    //        var commentsArray = Array<Comment>()
    //        if let msg = json["msg"].array{
    //            for comment in msg{
    //                let commentsId: Int = comment["commentsId"].int!
    //                let content: String = comment["content"].string!
    //                let likeCount: Int = comment["likeCount"].int!
    //                let newComment: Comment = Comment(commentsId: commentsId, content: content, likeCount: likeCount)
    //                commentsArray.append(newComment)
    //            }
    //        }
    //        return commentsArray
    //    }
}

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
    private func textCode200(value: Any){
        print("code200")
        let json = JSON(value)
        let a = json["msg"]
        print("response mag: \(a)")
    }
    
    private func textNotCode200(status: Int,value: Any){
        print("error with response status: \(status)")
        let json = JSON(value)
        let msg = json["msg"]
        print("error mag: \(msg)")
    }
    func register(email:String,password:String,name:String,phone:String,completionHandler:@escaping (Bool) -> ()){
        let url = "\(serverUrl)/Users/register";
        let parameter: Parameters = ["Email":(email),"Password":(password),"Name":(name),"Phone":(phone)]
        print(parameter)
        AF.request(url,method: .post,parameters: parameter)
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
                            self.textCode200(value: value)
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
    // 這裡傳入的匿名內部類 handler:@escaping (Bool) -> () 要是逃逸閉包，因為 AF.request 後面的閉包是逃逸閉包，只有逃逸閉包能在逃逸閉包裡使用
//    func getNewestEpisodeList(userID:Int, handler:@escaping (Bool) -> ()) { // 帶進來的 bool 參數（此寫法可不用帶兩個閉包進去）
//        AF.request("\(serverUrl)PodcastRSS/GetNewestList?userId=\(userID)").responseJSON { (data) in
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
//    func getHashTagList( handler:@escaping (Bool) -> ()){
//        AF.request("\(serverUrl)PodcastRSS/GetAllTag").responseJSON { (data) in
//            switch data.result {
//            case .success: // 連線成功時
//                let json = try! JSON(data: data.data!)
//                if(self.wrappingJSON(json: json)){
//                    let jsonArr = json["msg"]
//                    let hashtagList = HashtagList.instance()
//                    
//                    for index in 0...jsonArr.count - 1 {
//                        hashtagList.add(hashtag: Hashtag(name: jsonArr[index]["hashTag"].string!, hashtagID: jsonArr[index]["hashTagId"].int!))
//                    }
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

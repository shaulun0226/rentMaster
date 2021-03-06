//
//  AppDelegate.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/2.
//

import UIKit
import Firebase
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    var deviceToken = ""
    var userDefault = UserDefaults()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initiazlie Firebase
        FirebaseApp.configure()
        // Set Firebase messaging delegate
        Messaging.messaging().delegate = self
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (state, error) in
            }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        //傳來的資料是AnyHashable的話要用這樣拆開
        let noteType = userInfo[AnyHashable("noteType")] as? String ?? ""
        let message = userInfo[AnyHashable("Message")] as? String ?? ""
        let sender = userInfo[AnyHashable("Sender")] as? String ?? ""
        let productTitle = userInfo[AnyHashable("ProductTitle")] as? String ?? ""
        let newStatus = userInfo[AnyHashable("newStatus")] as? String ?? ""
        
        let content = UNMutableNotificationContent()
        content.title = "商品:\(productTitle)"
        print("通知格式\(noteType)")
        switch noteType {
        case "message":
            content.body = "\(sender):\(message)"
        case "status":
            content.body = "狀態變更為:\(newStatus)"
        default:
            content.body = "您有新的通知"
        }
        content.badge = 1
        content.sound = UNNotificationSound.default
        //timeInterval設定收到訊息後多久跳出
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        //        NetworkController.instance().getMyOrderById(id: orderId){
        //           (orderTitle,isSuccess) in
        //            if isSuccess{
        //                let content = UNMutableNotificationContent()
        //                        content.title = "商品:\(orderTitle)"
        //                        content.body = "\(sender):\(message)"
        //                        content.badge = 1
        //                        content.sound = UNNotificationSound.default
        //                        //timeInterval設定收到訊息後多久跳出
        //                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        //                        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        //                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        //            }
        //        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        for byte in deviceToken {
        //             let hexString = String(format: "%02x", byte)
        //            self.deviceToken += hexString
        //        }
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound,.badge]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
}
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            print("沒拿到token")
            return
        }
        self.deviceToken = fcmToken
        userDefault.setValue( self.deviceToken, forKey: "DeviceToken")
        guard let account = userDefault.value(forKey: "Account") as? String else{return}
        guard let password = userDefault.value(forKey: "Password") as? String else{return}
        if(account.isEmpty||password.isEmpty){
            return
        }
        if(Global.isOnline && User.token.isEmpty){
            NetworkController.instance().login(email: account, password: password,deviceToken: self.deviceToken) {
                // [weak self]表此類為弱連結(結束後會自動釋放)，(isSuccess)自訂方法時會帶進來的 bool 參數（此寫法可不用帶兩個閉包進去
                (value,isSuccess)  in
                if(isSuccess){
                    User.token = value as? String ?? ""
                    if(!User.token.isEmpty){
                        print("登入成功")
                    }
                }else{
                    print("登入失敗")
                }
            }
        }
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

//
//  AppDelegate.swift
//  PushNotificationWithP8_Test
//
//  Created by 翁禹斌(William.Weng) on 2018/5/31.
//  Copyright © 2018年 翁禹斌(William.Weng). All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    typealias PayloadInfo = (tab: Int?, page: Int?, item: Int?)
    
    var window: UIWindow?
    
    private let PayloadKey = "customInfo"
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Utility.shared.pushNotificationSetting(); return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let token = Utility.shared.hexString(with: deviceToken) { print(token) }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        pushNotificationAction(with: userInfo, forPayloadKey: PayloadKey)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        pushNotificationAction(with: userInfo, forPayloadKey: PayloadKey)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { print("error = \(error)") }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.init(rawValue: 8)!)
        print("performFetchWithCompletionHandler")
    }
}

extension AppDelegate {

    /// 收到推播後的處理
    private func pushNotificationAction(with userInfo: [AnyHashable : Any], forPayloadKey key: String) {
        let apnsInfo = Utility.shared.apnsInfoMaker(with: userInfo, forPayloadKey: key)
        changeTab(withApnsInfo: apnsInfo)
    }

    /// 通知改變Tab
    private func changeTab(withApnsInfo apnsInfo: Utility.ApnsInfo) {
        let payload = payloadInfoMaker(apnsInfo.payload as? [String: Int])
        changeTab(withPayload: payload)
    }

    /// 通知改變Tab (主程式 ==> 切換Tab --> 換頁)
    private func changeTab(withPayload payload: PayloadInfo?) {

        guard let payload = payload,
              let tabbarcontroller = window?.rootViewController as? UITabBarController
        else {
            return
        }

        let index = payload.tab ?? 0

        tabbarcontroller.selectedIndex = index

        for childViewController in tabbarcontroller.childViewControllers {

            if childViewController.restorationIdentifier == "MyNavigationController" {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController3A = storyboard.instantiateViewController(withIdentifier: "ViewController3A")
                let viewController3B = storyboard.instantiateViewController(withIdentifier: "ViewController3B")

                if let myNavigationController = childViewController as? UINavigationController {
                                        
                    myNavigationController.popToRootViewController {
                        
                        if payload.page != 0 {
                            myNavigationController.pushViewController(viewController: viewController3A) {
                                
                                if payload.item != 0 {
                                    myNavigationController.pushViewController(viewController: viewController3B, completion: nil) }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension UINavigationController {
    
    /// 回到RootViewController => 有完成動作
    func popToRootViewController(completion: (() -> Void)?) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        popToRootViewController(animated: true)
        
        CATransaction.commit()
    }
    
    /// 回到上一頁ViewController => 有完成動作
    func popViewControllerWithHandler(completion: (() -> Void)?) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        popViewController(animated: true)
        
        CATransaction.commit()
    }
    
    /// 轉至下一頁ViewController => 有完成動作
    func pushViewController(viewController: UIViewController, completion: (() -> Void)?) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        pushViewController(viewController, animated: true)
        
        CATransaction.commit()
    }
}

// MARK: - 小工具
extension AppDelegate {
    
    /// 解出Payload的值
    /// {"tab":1,"page":2,"item":3}
    private func payloadInfoMaker(_ info: [String: Int]?) -> PayloadInfo? {
        
        guard let info = info else { return (tab: nil, page: nil, item: nil) }

        let tab = info["tab"]
        let page = info["page"]
        let item = info["item"]

        return (tab: tab, page: page, item: item)
    }
}

// MARK: - 常用工具
final class Utility: NSObject {

    typealias ApnsInfo = (alert: String?, badge: Int?, sound: String?, payload: Any?)

    static let shared = Utility()
    private override init() {}
}

extension Utility {

    /// 推播設定
    func pushNotificationSetting() {
        
        let notificationTypes: UIUserNotificationType = [.alert, .badge, .sound]
        let pushNotificationSettings = UIUserNotificationSettings.init(types: notificationTypes, categories: nil)
        
        UIApplication.shared.registerUserNotificationSettings(pushNotificationSettings)
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    /// Data => 16進位文字 (%02x - 推播Token常用)
    func hexString(with data: Data?) -> String? {

        guard let data = data,
              let hexString = Optional.some(data.reduce("") { return $0 + String(format: "%02x", $1) })
        else {
            return nil
        }

        return hexString
    }
    
    /// 解出從推播而來的相關訊息 (APNS)
    /// {"aps":{"alert":"Hello Word!!!","badge":100,"sound":"default"},"<payload>":{}}
    func apnsInfoMaker(with userInfo: [AnyHashable : Any], forPayloadKey key: String) -> ApnsInfo {

        guard let apsInfo = userInfo["aps"] as? [String: Any] else { fatalError() }

        let alert = apsInfo["alert"] as? String
        let badge = apsInfo["badge"] as? Int
        let sound = apsInfo["sound"] as? String
        let payload = userInfo[key]
        
        return  (alert: alert, badge: badge , sound: sound, payload: payload)
    }
}

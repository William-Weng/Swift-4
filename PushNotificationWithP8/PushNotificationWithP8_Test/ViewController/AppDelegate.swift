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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var apsInfo: (alert: String?, badge: Int?, sound: String?) = (nil, nil, nil)
    static var customInfo: (tab: Int?, page: Int?, item: Int?) = (nil, nil, nil)
    static var deviceToken: Data? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        pushNotificationSetting()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AppDelegate.deviceToken = deviceToken
        print("DEVICE TOKEN = \(deviceToken as NSData)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        pushNotificationData(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        pushNotificationData(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error = \(error)")
    }
}

extension AppDelegate {
    
    /// 通知改變Tab
    fileprivate func changeTab() {
        
        guard let tabbarcontroller = self.window?.rootViewController as? MyTabBarController else { return }
        
        let index = AppDelegate.customInfo.tab ?? 0
        
        tabbarcontroller.selectedIndex = index

        for childViewController in tabbarcontroller.childViewControllers {
            if childViewController.restorationIdentifier == "MyNavigationController" {
                
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let viewController3A = storyboard.instantiateViewController(withIdentifier: "ViewController3A")
                let viewController3B = storyboard.instantiateViewController(withIdentifier: "ViewController3B")

                if let myNavigationController = childViewController as? UINavigationController {
                    
                    myNavigationController.popToRootViewController(animated: true)
                    
                    if AppDelegate.customInfo.page != 0 {
                        myNavigationController.pushViewController(viewController3A, animated: true)
                    }
                    
                    if AppDelegate.customInfo.item != 0 {
                        myNavigationController.pushViewController(viewController3B, animated: true)
                    }
                }
            }
        }
    }
    
    /// 推播設定
    fileprivate func pushNotificationSetting() {
        
        let notificationTypes: UIUserNotificationType = [.alert, .badge, .sound]
        let pushNotificationSettings = UIUserNotificationSettings.init(types: notificationTypes, categories: nil)
        
        UIApplication.shared.registerUserNotificationSettings(pushNotificationSettings)
        UIApplication.shared.registerForRemoteNotifications()
    }

    /// 收到推播後的處理
    fileprivate func pushNotificationData(userInfo: [AnyHashable : Any]) {
        
        if UIApplication.shared.applicationState == .active {
            print("前臺")
        } else {
            print("後臺")
        }
        
        print(userInfo)
        
        if let _aps = userInfo["aps"], let aps = _aps as? NSDictionary {
            AppDelegate.apsInfo.alert = aps["alert"] as? String
            AppDelegate.apsInfo.badge = aps["badge"] as? Int
            AppDelegate.apsInfo.sound = aps["sound"] as? String
            
            print(AppDelegate.apsInfo)
        }
        
        if let _payload = userInfo["customInfo"], let payload = _payload as? NSDictionary {
            AppDelegate.customInfo.tab = payload["tab"] as? Int
            AppDelegate.customInfo.page = payload["page"] as? Int
            AppDelegate.customInfo.item = payload["item"] as? Int

            print(AppDelegate.customInfo)
        }
        
        changeTab()
    }
}


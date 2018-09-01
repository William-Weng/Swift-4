//
//  MyTabBarController.swift
//  TabBarWithCustomButton
//
//  Created by William.Weng on 2018/8/6.
//  Copyright © 2018年 William.Weng. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
}

extension MyTabBarController: MyTabBarDelegate {
    
    func centerButtonClick() {
        myAlertController(with: "MyTabBarDelegate")
    }
}

extension MyTabBarController {
    
    func initSetting() {
        if let tabbar = tabBar as? MyTabBar { tabbar.myTabBarDelegate = self }
    }
    
    /// Alert
    func myAlertController(with message: String) {
        
        let alertController = UIAlertController(title: "我被按了", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認",style: .default, handler: nil)
        
        alertController.addAction(okAction)
        present( alertController, animated: true, completion: nil)
    }
}


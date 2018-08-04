//
//  MyTabBarController.swift
//  PushNotificationWithP8_Test
//
//  Created by 翁禹斌(William.Weng) on 2018/5/31.
//  Copyright © 2018年 翁禹斌(William.Weng). All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 100
        return sizeThatFits
    }
}

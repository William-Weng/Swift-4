//
//  WWBaseHUD.swift
//  WWBaseHUD
//
//  Created by William-Weng on 2018/4/21.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class WWBaseHUD: NSObject {
    
    static let sharedInstance = WWBaseHUD()
    
    // UIScreen.main.bounds
    fileprivate let windowFrame = CGRect.init(x: 100, y: 100, width: 200, height: 200)
    fileprivate let windowAlpha: (show: CGFloat, hide: CGFloat) = (0.5, 0.0)
    fileprivate let windowDuration: (show: TimeInterval, hide: TimeInterval) = (0.3, 1.0)
    
    fileprivate var newWindow: UIWindow!

    fileprivate override init() {
        super.init()
        newWindow = hudWindow()
        print("init...")
    }
    
    deinit { print("deinit...") }
    
    /// 顯示HUD
    func show() {
        UIView.animate(withDuration: self.windowDuration.show) {
            self.newWindow.alpha = self.windowAlpha.show
        }
    }
    
    /// 隱藏HUD
    func hide() {
        newWindow.layer.removeAllAnimations()
        UIView.animate(withDuration: self.windowDuration.hide) {
            self.newWindow.alpha = self.windowAlpha.hide
        }
    }
}

extension WWBaseHUD {
    
    fileprivate func hudWindow() -> UIWindow {
        
        let newWindow = UIWindow.init(frame: windowFrame)
        
        newWindow.alpha = windowAlpha.hide
        newWindow.windowLevel = UIWindowLevelAlert + 1000
        newWindow.backgroundColor = .clear
        newWindow.rootViewController = WWBaseHUDViewController()
        newWindow.makeKeyAndVisible()
        
        return newWindow
    }
}


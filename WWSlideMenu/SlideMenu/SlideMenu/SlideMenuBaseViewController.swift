//
//  SlideMenuBaseViewController.swift
//  SlideMenu
//
//  Created by William-Weng on 2018/10/24.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class SlideMenuBaseViewController: UIViewController {
    
    let SlideMenuStatus: (open: SlideMenuConstant.Status, close: SlideMenuConstant.Status) = (open: .open, close: .close)
    let identifier = "SlideMenuViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Selector
extension SlideMenuBaseViewController {
    
    /// 開關側邊選單
    @objc func slideMenuButtonPressed(_ sender : UIButton) {
        
        guard let status = SlideMenuConstant.Status.init(rawValue: sender.tag) else { return }
        
        switch status {
        case .open:
            slideMenuItemSelectedAtIndex(SlideMenuConstant.Status.other.rawValue)
            removeSlideMenu(with: sender)
        case .close:
            showSlideMenu(with: sender)
        default:
            break
        }
    }
}

// MARK: - 公開的函式
extension SlideMenuBaseViewController {
    
    public func slideMenuSetting() {
        
        let menuButton = UIButton(type: .system)
        let customBarItem = UIBarButtonItem(customView: menuButton)
        
        menuButton.setImage(menuIcon(), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuButton.addTarget(self, action: #selector(slideMenuButtonPressed(_:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = customBarItem;
    }
}

// MARK: - SlideMenuDelegate
extension SlideMenuBaseViewController: SlideMenuDelegate {
    
    func slideMenuItemSelectedAtIndex(_ index: Int) {
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        print(index)
        
        switch(index) {
        case 0:
            pushViewController(for: "ViewController_1")
        case 1:
            pushViewController(for: "ViewController_2")
        default:
            break
        }
    }
}

// MARK: - 小工具
extension SlideMenuBaseViewController {
    
    /// 設定Menu的圖示
    private func menuIcon() -> UIImage {
        
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage
    }
    
    /// 加入側邊選單
    private func showSlideMenu(with button: UIButton) {
        
        guard let storyboard = storyboard,
              let slideMenuVC = storyboard.instantiateViewController(withIdentifier: identifier) as? SlideMenuViewController
        else {
            return
        }
        
        button.tag = SlideMenuStatus.open.rawValue
        button.isEnabled = false
        
        slideMenuVC.myDelegate = self
        slideMenuVC.menuButton = button
        
        slideMenuVC.view.layoutIfNeeded()
        slideMenuVC.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        view.addSubview(slideMenuVC.view)
        addChild(slideMenuVC)
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            slideMenuVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            button.isEnabled = true
        }, completion: nil)
    }
    
    /// 移除側邊選單
    private func removeSlideMenu(with button: UIButton) {
        
        guard let menuView = view.subviews.last else { return }
        
        var menuFrame = menuView.frame

        menuFrame.origin.x = -1 * UIScreen.main.bounds.width
        button.tag = SlideMenuStatus.close.rawValue;

        UIView.animate(withDuration: 0.3, animations: {
            menuView.backgroundColor = .clear
            menuView.frame = menuFrame
            menuView.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            menuView.removeFromSuperview()
        })
    }
    
    /// 移動到所選的ViewController (根據RestorationIdentifier來判定是否重複)
    private func pushViewController(for identifier: String) {
        
        guard let navigationController = navigationController,
              let storyboard = storyboard,
              let topViewController = navigationController.topViewController,
              let destViewController = Optional.some(storyboard.instantiateViewController(withIdentifier: identifier)),
              let topRestorationIdentifier = topViewController.restorationIdentifier,
              let destRestorationIdentifier = destViewController.restorationIdentifier
        else {
            return
        }
        
        guard (topRestorationIdentifier != destRestorationIdentifier) else {
            print("Same VC"); return
        }
        
        navigationController.pushViewController(destViewController, animated: true)
    }
}



//
//  MenuViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/6.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [SideMenuSwift](https://github.com/kukushi/SideMenu)

import UIKit

class MenuViewController: UIViewController {
    
    lazy var page1ViewController: Page1_ViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "Page1") as! Page1_ViewController
    }()
    
    lazy var pageTabBarController: UITabBarController = {
        self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
    }()
    
    lazy var pageNavigationController: UINavigationController = {
        self.storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showPage1(_ sender: UIButton) {
        changePage(to: page1ViewController)
    }
    
    @IBAction func showPage2(_ sender: UIButton) {
        changePage(to: pageTabBarController)
    }
    
    @IBAction func showPage3(_ sender: UIButton) {
        changePage(to: pageNavigationController)
    }
    
    @IBAction func hideMenuView(_ sender: UIButton) {
        guard let menuViewController = ViewController.menuViewController else { return }
        menuViewController.hideMenuView()
    }
}

extension MenuViewController {
    
    /// 切換ContainerView的內容
    public func changePage(to newViewController: UIViewController) {
        
        guard let menuViewController = ViewController.menuViewController,
              let containerView = menuViewController.mainView,
              var selectedViewController = menuViewController.ViewController.main
        else {
            return
        }
        
        selectedViewController.willMove(toParent: nil)
        selectedViewController.view.removeFromSuperview()
        selectedViewController.removeFromParent()
        
        menuViewController.addChild(newViewController)
        containerView.addSubview(newViewController.view)
        newViewController.view.frame = containerView.bounds
        newViewController.didMove(toParent: menuViewController)
        
        if let pageViewController = findPageViewController(with: newViewController) {
            selectedViewController = pageViewController
            DispatchQueue.main.async { menuViewController.hideMenuView() }
        }
    }
    
    /// 取得主頁面的ViewController
    private func findPageViewController(with viewController: UIViewController) -> PageViewController? {
        
        if let pageViewController = viewController as? PageViewController {
            return pageViewController
        }
        
        if let navigationController = viewController as? UINavigationController {
            guard let pageViewController = navigationController.viewControllers.first as? PageViewController else { return nil }
            return pageViewController
        }
        
        if let tabBarController = viewController as? UITabBarController {
            guard let pageViewController = tabBarController.viewControllers?.first as? PageViewController else { return nil }
            return pageViewController
        }
        
        return nil
    }
}

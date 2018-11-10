//
//  PageViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/7.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    var isLoaded = false
    
    enum MenuStatus {
        case show
        case hide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PageViewController {
    
    /// 切換側邊選單開關的狀態
    func menuStatus(_ status: MenuStatus) {
        
        guard let menuViewController = ViewController.menuViewController else { return }
        
        switch status {
        case .show:
            menuViewController.showMenuView()
        case .hide:
            menuViewController.hideMenuView()
        }
    }
}

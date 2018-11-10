//
//  ViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/6.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var slideView: UIView!
    @IBOutlet public weak var mainView: UIView!
    
    let Segue = (main: "MainSegue", menu: "MenuSegue")
    let AnimateDuration: (show: TimeInterval, hide: TimeInterval) = (0.5, 0.5)
    let MenuPoint: (show: CGPoint, hide: CGPoint) = (.zero, CGPoint.init(x: -UIScreen.main.bounds.width, y: 0))
    
    lazy var page1ViewController: Page1_ViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "Page1") as! Page1_ViewController
    }()
    
    var ViewController: (main: PageViewController?, menu: MenuViewController?) = (nil, nil)
    
    static var menuViewController: ViewController? = { return rootViewController() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slideViewFrameSetting(with: MenuPoint.hide)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        menuViewControllerSetting(for: segue)
    }
}

// MARK: - 公開的函式
extension ViewController {
    
    /// 記錄畫面跟選單的ViewController
    private func menuViewControllerSetting(for segue: UIStoryboardSegue) {
        if segue.identifier == Segue.main { ViewController.main = segue.destination as? PageViewController; return }
        if segue.identifier == Segue.menu { ViewController.menu = segue.destination as? MenuViewController; return }
    }
    
    /// 顯示側邊選單
    public func showMenuView() {
        
        UIView.animate(withDuration: AnimateDuration.show, animations: {
            self.slideViewFrameSetting(with: self.MenuPoint.show)
        }, completion: { isOK in
            print("show => \(self.slideView.frame)")
        })
    }
    
    /// 隱藏側邊選單
    public func hideMenuView() {
        
        UIView.animate(withDuration: AnimateDuration.hide, animations: {
            self.slideViewFrameSetting(with: self.MenuPoint.hide)
        }, completion: { isOK in
            print("hide => \(self.slideView.frame)")
        })
    }
}

// MARK: - 小工具
extension ViewController {
    
    /// 取得主要ViewController
    static private func rootViewController() -> ViewController? {
        return UIApplication.shared.keyWindow?.rootViewController as? ViewController
    }
    
    /// 設定側邊選單的初始位置
    private func slideViewFrameSetting(with origin: CGPoint) {
        slideView.frame.origin = origin
    }
}


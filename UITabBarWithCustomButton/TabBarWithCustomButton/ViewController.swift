//
//  ViewController.swift
//  TabBarWithCustomButton
//
//  Created by William.Weng on 2018/8/6.
//  Copyright © 2018年 William.Weng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class ViewController2: UIViewController {
    
    lazy var height = { tabBarController?.tabBar.frame.height ?? 49.0 }()
    lazy var originY: (show: CGFloat, hidden: CGFloat) = { return tabBarControllerHeight(with: self.tabBarController) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 0.5) { self.tabBarController?.tabBar.frame.origin.y = self.originY.hidden }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5) { self.tabBarController?.tabBar.frame.origin.y = self.originY.show }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class ViewController3: UIViewController {
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    let delayTime = TimeInterval(0.3)
    lazy var originY = { return tabBarControllerHeight(with: self.tabBarController) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: delayTime) { self.tabBarController?.tabBar.frame.origin.y = self.originY.show }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController3: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let originY = (scrollView.contentOffset.y > 0) ? self.originY.hidden : self.originY.show
        UIView.animate(withDuration: delayTime) { self.tabBarController?.tabBar.frame.origin.y = originY }
    }
}

/// 取得TabBarController的高度
func tabBarControllerHeight(with tabBarController: UITabBarController?) -> (show: CGFloat, hidden: CGFloat) {
    
    guard let originY = tabBarController?.tabBar.frame.origin.y,
          let originHight = tabBarController?.tabBar.frame.size.height
    else {
        return (CGFloat(0), CGFloat(0))
    }
    
    return (originY, originY + originHight)
}

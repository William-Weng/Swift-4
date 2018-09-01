//
//  MyTabBarController.swift
//  TabBarWithCustomButton
//
//  Created by William.Weng on 2018/8/6.
//  Copyright © 2018年 William.Weng. All rights reserved.
//
/// [swift——特殊的自定義UITabBar，UITabBarController和UINavigationController](https://www.jianshu.com/p/e45a1c239451)

import UIKit

protocol MyTabBarDelegate: NSObjectProtocol {
    func centerButtonClick()
}

class MyTabBar: UITabBar {
    
    lazy var moveHeight: CGFloat = {
        
        if #available(iOS 11.0, *) {
            if let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom, bottom > 0 { return bottom }
        }
        return 18.0
    }()
    
    weak var myTabBarDelegate: MyTabBarDelegate? = nil
    
    private var centerButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCenterButton()
        addSubview(centerButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCenterButton()
        addSubview(centerButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        centerButtonSetting()
    }
    
    @objc func centerButtonClick(_ sender: UIButton) {
        myTabBarDelegate?.centerButtonClick()
    }
}

extension MyTabBar {
    
    /// 初始化CenterButton
    private func initCenterButton() {
        centerButton.setBackgroundImage(#imageLiteral(resourceName: "Icon_add"), for: .normal)
        centerButton.addTarget(self, action: #selector(centerButtonClick(_:)), for: .touchUpInside)
    }
    
    /// 在中間加上UIButton，然後放到最前面
    private func centerButtonSetting() {
        centerButton.frame.size = centerButton.currentBackgroundImage?.size ?? .zero
        centerButton.center = CGPoint.init(x: frame.size.width / 2, y: frame.size.height / 2 - moveHeight)
        bringSubview(toFront: centerButton)
    }
    
    /// 讓Center按鈕的外緣部分可以被按到 (隱藏或沒點到裡面就不算)
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let _centerButton = convert(point, to: centerButton)
        
        guard !isHidden,
              centerButton.point(inside: _centerButton, with: event)
        else {
            return super.hitTest(point, with: event)
        }
        
        return centerButton
    }
}

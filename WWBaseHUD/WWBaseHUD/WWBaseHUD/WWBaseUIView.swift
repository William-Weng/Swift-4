//
//  WWBaseUIView.swift
//  WWBaseHUD
//
//  Created by William-Weng on 2018/4/21.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class WWBaseUIView: UIView {

    @IBOutlet weak var view: UIView!
    
    private let xibName = "WWBaseUIView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib(with: xibName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib(with: xibName)
    }
}

/// MARK: @小工具
extension WWBaseUIView {
    
    /// 載入XIB的一些基本設定
    private func initViewFromXib(with name: String) {
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
    }
}

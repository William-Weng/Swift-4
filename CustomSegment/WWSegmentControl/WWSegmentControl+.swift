//
//  WWSegmentControl+.swift
//  WWSegmentControl
//
//  Created by William-Weng on 2018/8/15.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

extension WWSegmentControl {
    
    /// 設定Segment按鈕的文字
    public func titleSetting(_ titles: [String]) {
        
        guard let buttons = baseSegmentView.arrangedSubviews as? [UIButton] else { return }
        
        for (index, title) in titles.enumerated() {
            if index < buttons.count { buttons[index].setTitle(title, for: .normal) }
        }
    }
}

extension WWSegmentControl {
    
    /// 按鈕移動動畫 => 變長變扁 => 移動中點
    @objc  func moveButton(_ sender: UIButton) {
        
        if sender.tag == nowSelectedTag { return }
        guard let myButtons = baseSegmentView.arrangedSubviews as? [UIButton] else { return }
        
        let multiple = CGFloat(abs(sender.tag - nowSelectedTag) + 1)
        
        for button in myButtons {
            button.isEnabled = true
            button.setTitleColor(disableTextColor, for: .normal)
        }
        
        sender.setTitleColor(enableTextColor, for: .normal)
        
        animator = UIViewPropertyAnimator.init(duration: 0.3, dampingRatio: 1, animations: {
            self.stretchMoveUIView(with: multiple, size: sender.frame.size)
        })
        
        animator?.addAnimations({
            
            if sender.tag > self.nowSelectedTag {
                self.changeMoveUIViewCenter(to: myButtons[self.nowSelectedTag])
            } else {
                self.changeMoveUIViewCenter(to: myButtons[sender.tag])
            }
        })
        
        animator?.addCompletion({ _ in
            _ = UIViewPropertyAnimator.init(duration: 0.3, dampingRatio: 0.7, animations: {
                self.revertMoveUIViewSize(to: sender)
                self.nowSelectedTag = sender.tag
                self.delegate?.nowSelectedIndex(self.nowSelectedTag, for: sender)
            }).startAnimation()
        })
        
        animator?.startAnimation()
    }
}

extension WWSegmentControl {
    
    /// 載入XIB的一些基本設定
     func initViewFromXib() {
        
        let bundle = Bundle.init(for: WWSegmentControl.self)
        let name = String(describing: WWSegmentControl.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds
        
        addSubview(contentView)
    }
    
    /// 設定相關的半徑
     func radiusSetting(with radius: CGFloat) {
        layer.cornerRadius = radius
        moveUIView.layer.cornerRadius = radius
    }
    
    /// 設定外框的顏色
     func borderColorSetting(with color: UIColor) {
        layer.borderColor = color.cgColor
        moveUIView.layer.backgroundColor = color.cgColor
        
        guard let buttons = baseSegmentView.arrangedSubviews as? [UIButton] else { return }
        
        for button in buttons {
            button.setTitleColor(color, for: .normal)
        }
    }
    
    /// 設定外框粗細
     func borderWidthSetting(with width: CGFloat) {
        layer.borderWidth = width
    }
    
    /// 設定Segment按鈕的文字
     func titleStringSetting(with titleString: String) {
        
        let titles = titleString.split(separator: ",").map { (string) -> String in
            return string.description
        }
        titleSetting(titles)
    }
    
    /// 設定一開始的選在哪一個選項
     func selectedTagSetting(with tag: UInt) {
        
        guard let segmentButtons = baseSegmentView.arrangedSubviews as? [UIButton] else { return }
        
        nowSelectedTag = (tag < count) ? Int(tag) : 0
        let selectedButton = segmentButtons[nowSelectedTag]
        
        moveUIViewLeading = moveUIViewLeading.setSecondItem(selectedButton)
        selectedButton.setTitleColor(enableTextColor, for: .normal)
    }
    
    /// 按鈕與背後的移動View的初始化設定
     func buttonsSetting(with count: UInt) {
        
        for index in 0..<count {
            
            let button = UIButton()
            
            button.tag = Int(index)
            button.setTitleColor(disableTextColor, for: .normal)
            button.backgroundColor = .clear
            button.setTitle("\(index)", for: .normal)
            button.addTarget(self, action: #selector(moveButton(_:)), for: .touchUpInside)
            
            baseSegmentView.addArrangedSubview(button)
        }
        
        moveUIViewWidth = moveUIViewWidth.setMultiplier(1 / CGFloat(count))
    }
    
    /// 拉伸選擇框的大小
     func stretchMoveUIView(with multiple: CGFloat, size: CGSize) {
        moveUIView.frame.size.width = size.width * multiple
        moveUIView.frame.size.height = size.height / multiple
        moveUIView.layer.cornerRadius = size.height / multiple / 2
    }
    
    /// 改變中點的位置
     func changeMoveUIViewCenter(to button: UIButton) {
        moveUIView.frame.origin.x = button.frame.origin.x
        moveUIView.center.y = button.center.y
    }
    
    /// 還原選擇框的大小
     func revertMoveUIViewSize(to button: UIButton) {
        moveUIView.frame.size = button.frame.size
        moveUIView.center = button.center
        moveUIView.layer.cornerRadius = radius
        moveUIViewLeading = moveUIViewLeading.setSecondItem(button)
    }
}

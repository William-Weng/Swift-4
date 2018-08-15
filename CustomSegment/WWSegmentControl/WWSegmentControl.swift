//
//  WWSegmentControl.swift
//  CustomSegment
//
//  Created by William-Weng on 2018/8/14.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [快速入門指南：使用 UIViewPropertyAnimator 做動畫](https://swift.gg/2017/04/20/quick-guide-animations-with-uiviewpropertyanimator/)

import UIKit

public protocol WWSegmentControlDelegate: class {
    /// 現在選到哪一個
    func nowSelectedIndex(_ index: Int, for button: UIButton)
}

@IBDesignable
public class WWSegmentControl: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var baseUIView: UIView!
    @IBOutlet weak var baseSegmentView: UIStackView!
    @IBOutlet weak var moveUIView: UIView!
    @IBOutlet weak var moveUIViewWidth: NSLayoutConstraint!
    @IBOutlet weak var moveUIViewLeading: NSLayoutConstraint!
    
    @IBInspectable var count: UInt = 0 { willSet { buttonsSetting(with: newValue) }}
    @IBInspectable var radius: CGFloat = 0 { willSet { radiusSetting(with: newValue) }}
    @IBInspectable var width: CGFloat = 0 { willSet { borderWidthSetting(with: newValue) }}
    @IBInspectable var titles: String = String() { willSet { titleStringSetting(with: newValue) }}
    @IBInspectable var disableTextColor: UIColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1) { willSet { borderColorSetting(with: newValue) }}
    @IBInspectable var enableTextColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    @IBInspectable var selectedTag: UInt = 0 { willSet { selectedTagSetting(with: newValue)}}

    var animator: UIViewPropertyAnimator?
    var nowSelectedTag = 0
    
    public weak var delegate: WWSegmentControlDelegate? = nil
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib()
    }
}



//
//  NSLayoutConstraint+Extension.swift
//  CustomSegment
//
//  Created by William-Weng on 2018/8/14.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [如何修改NSLayoutConstraint的multiplier](https://www.jianshu.com/p/afa79ad6605e)

import UIKit

extension NSLayoutConstraint {
    
    /// 修改倍數大小
    func setMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier
        
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
    
    /// 修改第二個基準點
    func setSecondItem(_ secondItem: UIView) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier
        
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}


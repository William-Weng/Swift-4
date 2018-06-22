//
//  ViewController.swift
//  WWSwitch
//
//  Created by William-Weng on 2018/4/7.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// https://dribbble.com/shots/2346141-Bmitch-happy-worry

import UIKit

typealias SwitchInfo = (center: CGPoint, angle: CGFloat)

/* 開關的相關設定 (方向，顏色) */
enum SwitchDirection: Int {
    
    case left = 0
    case right = 1
    
    /// 設定Switch的背景色
    func color() -> UIColor {
        let colors = [#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)]; return colors[self.rawValue]
    }
    
    /// 設定View的背景色
    func viewColor() -> UIColor {
        let colors = [#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)]; return colors[self.rawValue]
    }
    
    /// 設定下一次的方向
    func nextDirection() -> Int {
        let tag = (self == .left) ? SwitchDirection.right.rawValue : SwitchDirection.left.rawValue
        return tag
    }
}

// MARK: 本體
class ViewController: UIViewController {
    
    @IBOutlet weak var switchBar: UIView!
    @IBOutlet weak var switchBarLeft: UIView!
    @IBOutlet weak var switchBarRight: UIView!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var upStackView: UIStackView!
    @IBOutlet weak var downStackView: UIStackView!
    @IBOutlet weak var smileImageView: UIImageView!
    
    override func viewDidLoad() { super.viewDidLoad() }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    /// 切換開關 (設定下一次的值 => 設定下一次的位置 => 動畫開始)
    @IBAction func buttonSwitch(_ sender: UIButton) {
        
        guard let nowDirection = SwitchDirection.init(rawValue: sender.tag) else { return }
        
        let nextInfo: SwitchInfo = switchValueSetting(with: nowDirection)
        switchNextDirectionSetting(with: nowDirection)
        switchAnimation(with: nowDirection, and: nextInfo)
    }
}

// MARK: 小工具
extension ViewController {
    
    /// 設定開關的一些變量 (中點，角度)
    private func switchValueSetting(with direction: SwitchDirection) -> SwitchInfo {
        
        var nextSwitchInfo: SwitchInfo = (CGPoint.zero, 0)
        
        switch direction {
        case .left:
            nextSwitchInfo = (switchBarRight.center, .pi)
            switchButton.tag = SwitchDirection.right.rawValue
        case .right:
            nextSwitchInfo = (switchBarLeft.center, 0)
            switchButton.tag = SwitchDirection.left.rawValue
        }
        
        return nextSwitchInfo
    }
    
    /// 利用Tag記錄下一次Switch的方向
    private func switchNextDirectionSetting(with direction: SwitchDirection) {
        switchButton.tag = direction.nextDirection()
    }
    
    /// 開關動畫 (移動中點 => 上下對調 => 下上對調 => 旋轉跟變色)
    private func switchAnimation(with direction: SwitchDirection, and switchInfo: SwitchInfo) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.switchView.center = switchInfo.center
            (self.upStackView.center, self.downStackView.center) = (self.downStackView.center, self.upStackView.center)
            
        }, completion: { isCompletion in
            
            UIView.animate(withDuration: 0.5, animations: {
                (self.upStackView.center, self.downStackView.center) = (self.downStackView.center, self.upStackView.center)
                self.smileImageView.transform = CGAffineTransform(rotationAngle: switchInfo.angle)
                self.switchView.backgroundColor = direction.color()
                self.view.backgroundColor = direction.viewColor()
            })
        })
    }
}

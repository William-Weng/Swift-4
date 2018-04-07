//
//  ViewController.swift
//  WWSwitch
//
//  Created by William-Weng on 2018/4/7.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// https://dribbble.com/shots/2346141-Bmitch-happy-worry

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var switchBar: UIView!
    @IBOutlet weak var switchBarLeft: UIView!
    @IBOutlet weak var switchBarRight: UIView!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var upStackView: UIStackView!
    @IBOutlet weak var downStackView: UIStackView!
    @IBOutlet weak var smileImageView: UIImageView!

    enum SwitchDirection: Int {
        case left = 0
        case right = 1
        
        func color() -> UIColor {
            let colors = [#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)]
            return colors[self.rawValue]
        }
        
        func viewColor() -> UIColor {
            let colors = [#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)]
            return colors[self.rawValue]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonSwitch(_ sender: UIButton) {
        
        guard let nowDirection = SwitchDirection.init(rawValue: sender.tag) else { return }
        
        var nextCenter = CGPoint.zero
        var nextAngle = CGFloat.pi
        
        switch nowDirection {
        case .left:
            nextCenter = switchBarRight.center
            nextAngle = .pi
            switchButton.tag = SwitchDirection.right.rawValue
        case .right:
            nextCenter = switchBarLeft.center
            nextAngle = 0
            switchButton.tag = SwitchDirection.left.rawValue
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.switchView.center = nextCenter
            (self.upStackView.center, self.downStackView.center) = (self.downStackView.center, self.upStackView.center)
            
        }, completion: { isCompletion in
            
            UIView.animate(withDuration: 0.5, animations: {
                (self.upStackView.center, self.downStackView.center) = (self.downStackView.center, self.upStackView.center)
                self.smileImageView.transform = CGAffineTransform(rotationAngle: nextAngle)
                self.switchView.backgroundColor = nowDirection.color()
                self.view.backgroundColor = nowDirection.viewColor()
            })
        })
    }
}


//
//  ViewController.swift
//  LayerAnimation
//
//  Created by William-Weng on 2018/2/10.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// @圖片先遮起來，再慢慢出現的動畫 - Swift 4

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var startAnimationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = myImageView.frame.size
        myImageView.mask(withRect: CGRect.init(x: 0, y: 0, width: size.width, height: size.height), isInverse: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// 動畫開始
    @IBAction func startAnimation(_ sender: UIButton) {
        startAnimationButton.setTitle("進行中…", for: .normal)
        startAnimationButton.isEnabled = false
        layerAnimation()
    }
}

// MARK: @小工具
extension ViewController {
    
    /// 以x軸的方向移動 ==> 左右移動一個跟原View一樣大的遮罩
    func layerAnimation(fromValue: Int = -200, toValue: Int = 0 ,with repeatCount: Float = 1, and duration: Double = 5.0)  {
        
        CATransaction.setCompletionBlock {
            self.startAnimationButton.setTitle("開始", for: .normal)
            self.startAnimationButton.isEnabled = true
        }
        
        let layerValue = (keyPath: "position.x", duration: duration)
        let maskLayer = myImageView.layer.mask as? CAShapeLayer
        let animation = CABasicAnimation(keyPath: layerValue.keyPath)

        animation.repeatCount = repeatCount
        animation.duration = duration
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        maskLayer?.add(animation, forKey: layerValue.keyPath)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.commit()
    }
}

// MARK: @UIView+Extension
extension UIView {
    
    /// 跟遮罩重疊在一起的才會顯示 / kCAFillRuleEvenOdd ==> 負負得正
    func mask(withRect rect: CGRect, isInverse: Bool = false) {
        
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()
        
        if isInverse {
            path.append(UIBezierPath(rect: bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        layer.mask = maskLayer
    }
}

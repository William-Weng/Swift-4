//
//  ViewController.swift
//  ImageDeleteShakeAnimation
//
//  Created by William.Weng on 2018/8/7.
//  Copyright © 2018年 William.Weng All rights reserved.
//
/// [仿iOS圖標抖動、iOS刪除App效果](https://blog.csdn.net/zhaojian3513012/article/details/46532707)
/// [IOS開發CAKeyframeAnimation的基本使用與keypath的列舉](https://my.oschina.net/u/2532565/blog/551227)

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var myBaseView: UIView!

    let rotationZ = "transform.rotation.z"
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(imageLongPress(_:)))
        myImageView.addGestureRecognizer(longPress)
        closeButton.isHidden = !isLoading
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func imageLongPress(_ longPress: UILongPressGestureRecognizer) {
        
        if longPress.state == .began {
            
            if isLoading {
                myImageView.layer.removeAnimation(forKey: rotationZ)
                isLoading = false
                closeButton.isHidden = !isLoading
                return
            }
            
            let animation = CAKeyframeAnimation()
            let shakeAngle = angleToRadian(7)
            let animationKey = rotationZ

            animation.keyPath = animationKey
            animation.values = [shakeAngle, -1 * shakeAngle, shakeAngle]
            animation.repeatCount = .infinity
            animation.duration = 0.5
            
            myImageView.layer.add(animation, forKey: animationKey)
            
            isLoading = true
            closeButton.isHidden = !isLoading
        }
    }
    
    /// 移除ImageView (變小 -> 轉轉轉 -> 移除)
    @IBAction func removeImage(_ button: UIButton) {
        
        let transform = (from: CATransform3DMakeScale(1.0, 1.0, 1.0), to: CATransform3DMakeScale(0.1, 0.1, 0.1))
        let animation = CAKeyframeAnimation()
        let animationKey = rotationZ
        
        animation.keyPath = animationKey
        animation.values = [angleToRadian(0), angleToRadian(360)]
        animation.repeatCount = .infinity
        animation.duration = 0.5
        
        myImageView.layer.add(animation, forKey: animationKey)

        button.isEnabled = true
        myBaseView.layer.transform = transform.from
        
        UIView.animate(withDuration: 2.0, animations: {
            self.myBaseView.layer.transform = transform.to
        }, completion: { _ in
            self.myBaseView.removeFromSuperview()
            let alert = self.myAlertController()
            self.present(alert, animated: true, completion: nil)
        })
    }
}

extension ViewController {
    
    /// 180° => π
    private func angleToRadian(_ angle: Float) -> Float {
        return (angle / 180.0) * Float.pi
    }
    
    /// 謝幕
    private func myAlertController() -> UIAlertController {
        
        let alertController = UIAlertController.init(title: "沒了", message: "謝謝收看", preferredStyle: .alert)
        let overAction = UIAlertAction.init(title: "終わり", style: .cancel, handler: nil)
        
        alertController.addAction(overAction)
        
        return alertController
    }
}

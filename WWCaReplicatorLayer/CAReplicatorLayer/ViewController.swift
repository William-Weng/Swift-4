//
//  ViewController.swift
//  CAReplicatorLayer
//
//  Created by William.Weng on 2018/8/9.
//  Copyright © 2018年 William.Weng. All rights reserved.
//
/// [CALayer Tutorial for iOS: Getting Started](https://www.raywenderlich.com/402-calayer-tutorial-for-ios-getting-started)
/// [Swift語言iOS開發：CALayer十則示例](http://www.cocoachina.com/ios/20150318/11350.html)
/// [iOS - CAReplicatorLayer的運用](https://www.jianshu.com/p/a927157ac62a)
/// [CAReplicatorLayer的使用](https://www.jianshu.com/p/9ed9ce30a2e8)
/// [CAReplicatorLayer](https://zsisme.gitbooks.io/ios-/content/chapter6/careplicatorLayer.html)

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewForReplicatorLayer: UIView!
    @IBOutlet weak var layerSizeSlider: UISlider!
    @IBOutlet weak var instanceCountSlider: UISlider!
    @IBOutlet weak var instanceDelaySlider: UISlider!
    @IBOutlet weak var layerSizeLabel: UILabel!
    @IBOutlet weak var instanceCountLabel: UILabel!
    @IBOutlet weak var instanceDelayLabel: UILabel!
    
    let lengthMultiplier: Float = 3.0
    let animationKey = "opacity"
    
    var replicatorLayer: CAReplicatorLayer!
    var instanceLayer: CALayer!
    var fadeAnimation: CABasicAnimation!

    override func viewDidLoad() {
        super.viewDidLoad()

        fadeAnimation = makeFadeAnimation()
        replicatorLayer = makeReplicatorLayer()
        instanceLayer = makeInstanceLayer(withImage: #imageLiteral(resourceName: "crab"))
        
        viewForReplicatorLayer.layer.addSublayer(replicatorLayer)
        replicatorLayer.addSublayer(instanceLayer)
        instanceLayer.add(fadeAnimation, forKey: animationKey)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// 修改圖形的大小 (bounds)
    @IBAction func layerSizeSliderChanged(_ sender: UISlider) {
        
        let value = sender.value.rounded()
        sender.value = value
        layerSizeLabel.text = "\(Int(value))"

        instanceLayer.bounds = CGRect(origin: CGPoint.zero, size: CGSize.init(width: CGFloat(value), height: CGFloat(value)))
    }
    
    /// 改變圖形的個數 (一圈360度有幾個)
    @IBAction func instanceCountSliderChanged(_ sender: UISlider) {
        
        let value = sender.value.rounded()
        let angle = Float.pi * 2.0 / value.rounded()

        sender.value = value
        instanceCountLabel.text = "\(Int(value))"

        replicatorLayer.instanceCount = Int(value)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        replicatorLayer.instanceDelay = CFTimeInterval(instanceDelaySlider.value / value)
    }
    
    /// 修改轉動的頻率 (一圈 -> 10秒 / 20個)
    @IBAction func instanceDelaySliderChanged(_ sender: UISlider) {
        
        let value = sender.value.rounded()
        
        sender.value = value
        instanceDelayLabel.text = "\(Int(value))"

        fadeAnimation.duration = CFTimeInterval(value)
        instanceLayer.add(fadeAnimation, forKey: animationKey)
        replicatorLayer.instanceDelay = CFTimeInterval(value / instanceCountSlider.value)
    }
}

extension ViewController {
    
    /// 產生ReplicatorLayer (複製圖層 => 利用產生的時間差異的假象 ~> 在圓形的路徑上，10秒內產生20個反射的layer)
    func makeReplicatorLayer() -> CAReplicatorLayer {
        
        let _replicatorLayer = CAReplicatorLayer()
        let count = instanceCountSlider.value
        let angle = Float.pi * 2.0 / count
        let freqfrequency = Float(instanceDelaySlider.value / count)

        _replicatorLayer.frame = viewForReplicatorLayer.bounds
        _replicatorLayer.preservesDepth = false

        _replicatorLayer.instanceCount = Int(count)
        _replicatorLayer.instanceColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        _replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)

        _replicatorLayer.instanceRedOffset = 0.05
        _replicatorLayer.instanceGreenOffset = 0.05
        _replicatorLayer.instanceBlueOffset = 0.05
        _replicatorLayer.instanceAlphaOffset = 0
        
        _replicatorLayer.instanceDelay = CFTimeInterval(freqfrequency)

        return _replicatorLayer
    }
    
    /// 產生CALayer (做一個複製的基底標本)
    func makeInstanceLayer(withImage image: UIImage) -> CALayer {
        
        let layerWidth = CGFloat(layerSizeSlider.value)
        let middleX = viewForReplicatorLayer.bounds.midX - layerWidth / 2.0
        let imageView = UIImageView.init(frame: CGRect(x: middleX, y: 0.0, width: layerWidth * 2, height: layerWidth * 2))
        
        imageView.image = image
        imageView.layer.opacity = 0.0

        return imageView.layer
    }
    
    /// 產生動畫 (改變透明度，及利用時間的差異，一明一暗，造成動畫的假象)
    func makeFadeAnimation() -> CABasicAnimation {
        
        let _fadeAnimation = CABasicAnimation(keyPath: animationKey)
        
        _fadeAnimation.fromValue = 1.0
        _fadeAnimation.toValue = 0.0
        _fadeAnimation.repeatCount = Float.infinity
        _fadeAnimation.duration = CFTimeInterval(instanceDelaySlider.value)
        
        return _fadeAnimation
    }
}



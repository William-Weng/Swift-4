//
//  CAShapeLayerAnimationView.swift
//  CAShapeLayer_Animation
//
//  Created by IIT-翁禹斌(William.Weng) on 2018/4/27.
//  Copyright © 2018年 IIT-翁禹斌(William.Weng). All rights reserved.
//

import UIKit

@IBDesignable class CAShapeLayerAnimationView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var percentLabel: UILabel!
    
    @IBInspectable var lineWidth: CGFloat = 10.0
    @IBInspectable var percent: CGFloat = 0.0
    @IBInspectable var baseLineColor: UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    @IBInspectable var drawLineColor: UIColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    @IBInspectable var animationDuration: Double = 1.0
    
    private let rootLayer = CALayer()
    private let pathAnimationKey = "strokeEndAnimation"
    private let xibName = String(describing: CAShapeLayerAnimationView.self)

    private var parameter: (radius: CGFloat, center: CGPoint) = (0.0, CGPoint.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib(with: xibName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib(with: xibName)
    }
    
    override func draw(_ rect: CGRect) {
        layerSetting(with: rect)
        shapeLayerDrawing()
        demoDrawLine()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        percentLabel.text = "\(percent) %"
    }
}

/// MARK: API
extension CAShapeLayerAnimationView {
    
    /// 繪製動畫
    func drawing(with percent: CGFloat) {
        
        rootLayer.removeAllAnimations()
        self.percent = percent
        percentLabel.text = "\(self.percent) %"
        
        shapeLayerDrawing()
        animateCAShapeLayerDrawing()
    }
}

/// MARK: 主功能
extension CAShapeLayerAnimationView {
    
    /// 載入XIB的一些基本設定
    private func initViewFromXib(with name: String) {
        
        let bundle = Bundle.init(for: CAShapeLayerAnimationView.self)

        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = self.bounds
        percentLabel.text = "\(self.percent) %"

        addSubview(contentView)
    }
    
    /// 基本設定
    private func layerSetting(with rect: CGRect) {
        
        parameter.radius = (rect.width > rect.height) ? rect.height / 2.0 : rect.width / 2.0
        parameter.center = contentView.center
        
        rootLayer.frame = rect
        rootLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        layer.addSublayer(rootLayer)
    }
    
    /// 畫圓
    private func shapeLayerDrawing() {
        
        let layer = baseShapeLayer(with: CGFloat(Double.pi) * 2.0, color: baseLineColor)
        rootLayer.addSublayer(layer)
    }
    
    /// 畫圓弧 (動畫)
    private func animateCAShapeLayerDrawing() {
        
        let layer = baseShapeLayer(with: CGFloat(Double.pi) * 2.0, color: drawLineColor)
        layer.add(pathAnimation(), forKey: pathAnimationKey)
        rootLayer.addSublayer(layer)
    }
}

/// MARK: 小工具
extension CAShapeLayerAnimationView {
    
    /// 基本的圓形路徑Layer
    private func baseShapeLayer(with endAngle: CGFloat, color: UIColor) -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        let path = CGMutablePath()
        
        path.addArc(center: parameter.center, radius: realRadius(), startAngle: CGFloat(0.0), endAngle: endAngle, clockwise: false)
        layer.path = path
        layer.strokeColor = color.cgColor
        layer.lineWidth = lineWidth
        layer.fillColor = nil
        
        return layer
    }
    
    /// 基本的圓弧動畫
    private func pathAnimation() -> CABasicAnimation {
        
        let animationKeyPath = "strokeEnd"
        let pathAnimation = CABasicAnimation(keyPath: animationKeyPath)
        
        pathAnimation.duration = animationDuration
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = realPercent()
        pathAnimation.repeatCount = 1
        
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.fillMode = kCAFillModeForwards

        return pathAnimation
    }
    
    /// 在Storyboard上畫出Demo的動畫線
    private func demoDrawLine() {
        #if TARGET_INTERFACE_BUILDER
            let layer = baseShapeLayer(with: CGFloat(Double.pi) * 2.0 * realPercent(), color: drawLineColor)
            rootLayer.addSublayer(layer)
        #endif
    }
    
    /// 取得有效半徑
    private func realRadius() -> CGFloat {
        return parameter.radius - lineWidth / 2.0
    }
    
    /// 百分比換算成有效小數
    private func realPercent() -> CGFloat {
        
        switch percent {
        case 0...100:
            return percent / 100.0
        default:
            return 0.0
        }
    }
}

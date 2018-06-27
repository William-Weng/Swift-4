//
//  WWBezierTextView.swift
//  BezierText
//
//  Created by William.Weng on 2018/6/25.
//  Copyright © 2018年 William.Weng. All rights reserved.
//
/// [Swift - 自動書寫文字的動畫效果（文字轉貝塞爾曲線、實現字跡動畫）](http://www.hangge.com/blog/cache/detail_1898.html)

import UIKit

class WWBezierTextView: UIView {

    private var animationKey = (position: "position", strokeEnd: "strokeEnd")
    private var bezierLayer = (text: CAShapeLayer(), pen: CALayer())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bezierLayer.text = pathLayer(with: 1.0)
        bezierLayer.pen = penLayer(with: #imageLiteral(resourceName: "pen"))
        
        layer.addSublayer(bezierLayer.text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: 公開的function
extension WWBezierTextView {
    
    /// show出文字
    func show(text: String) {
        
        let textPath = textBezierPath(from: text, size: 36.0)
        let duration: TimeInterval = 3.0
        
        bezierLayer.text.bounds = textPath.cgPath.boundingBoxOfPath
        bezierLayer.text.path = textPath.cgPath
        bezierLayer.text.add(textWriteAnimation(with: duration), forKey: animationKey.strokeEnd)
        bezierLayer.text.addSublayer(bezierLayer.pen)
        
        bezierLayer.pen.add(penWriteAnimation(with: textPath, duration: duration), forKey: animationKey.position)
    }
}

// MARK: 小工具
extension WWBezierTextView: CAAnimationDelegate {
    
    /// 取得字跡圖層 (全畫面)
    private func pathLayer(with lineWidth: CGFloat) -> CAShapeLayer {
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.frame = bounds
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        shapeLayer.strokeColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        shapeLayer.isGeometryFlipped = true
        
        return shapeLayer
    }
    
    /// 取得鋼筆圖標圖層 (跟原圖一樣大)
    private func penLayer(with pen: UIImage) -> CALayer {

        let penLayer = CALayer()
        
        penLayer.frame = CGRect.init(origin: .zero, size: pen.size)
        penLayer.contents = pen.cgImage
        penLayer.anchorPoint = .zero
        
        return penLayer
    }
    
    /// 文字動畫 (從頭畫到尾)
    private func textWriteAnimation(with duration: TimeInterval) -> CABasicAnimation {

        let animation = CABasicAnimation.init(keyPath: animationKey.strokeEnd)
        
        animation.duration = duration
        animation.fromValue = 0.00
        animation.toValue = 1.00
        animation.repeatCount = 1
        
        return animation
    }
    
    /// 筆跡動畫 (畫線的外框)
    private func penWriteAnimation(with textPath: UIBezierPath, duration: TimeInterval) -> CAKeyframeAnimation {
        
        let animation = CAKeyframeAnimation(keyPath: animationKey.position)
        
        animation.delegate = self
        animation.duration = duration
        animation.path = textPath.cgPath
        animation.calculationMode = kCAAnimationPaced
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards

        return animation
    }
    
    /// 將字串轉為貝茲曲線 (貼就對了)
    private func textBezierPath(from string: String, size: CGFloat) -> UIBezierPath {
        
        let paths = CGMutablePath()
        let fontName = __CFStringMakeConstantString("Chalkboard SE")!
        let fontRef = CTFontCreateWithName(fontName, size, nil)
        let attrString = NSAttributedString(string: string, attributes: [kCTFontAttributeName as NSAttributedStringKey: fontRef])
        let line = CTLineCreateWithAttributedString(attrString as CFAttributedString)
        let runA = CTLineGetGlyphRuns(line)
        let bezierPath = UIBezierPath()

        for runIndex in 0..<CFArrayGetCount(runA) {
            
            let run = CFArrayGetValueAtIndex(runA, runIndex);
            let runb = unsafeBitCast(run, to: CTRun.self)
            let CTFontName = unsafeBitCast(kCTFontAttributeName, to: UnsafeRawPointer.self)
            let runFontC = CFDictionaryGetValue(CTRunGetAttributes(runb),CTFontName)
            let runFontS = unsafeBitCast(runFontC, to: CTFont.self)
            let width = UIScreen.main.bounds.width
            
            var temp = 0
            var offset: CGFloat = 0.0
            
            for i in 0..<CTRunGetGlyphCount(runb) {
                
                let range = CFRangeMake(i, 1)
                let glyph = UnsafeMutablePointer<CGGlyph>.allocate(capacity: 1)
                let position = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
                
                glyph.initialize(to: 0)
                position.initialize(to: .zero)
                CTRunGetGlyphs(runb, range, glyph)
                CTRunGetPositions(runb, range, position);
                
                let temp3 = CGFloat(position.pointee.x)
                let temp2 = (Int) (temp3 / width)
                let temp1 = 0
                
                if(temp2 > temp1) {
                    temp = temp2
                    offset = position.pointee.x - (CGFloat(temp) * width)
                }
                
                if let path = CTFontCreatePathForGlyph(runFontS,glyph.pointee,nil) {
                    let x = position.pointee.x - (CGFloat(temp) * width) - offset
                    let y = position.pointee.y - (CGFloat(temp) * 80)
                    let transform = CGAffineTransform(translationX: x, y: y)
                    paths.addPath(path, transform: transform)
                }
                
                glyph.deinitialize(count: 1)
                glyph.deallocate()
                position.deinitialize(count: 1)
                position.deallocate()
            }
        }
        
        bezierPath.move(to: .zero)
        bezierPath.append(UIBezierPath(cgPath: paths))
        
        return bezierPath
    }
}

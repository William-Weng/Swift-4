//
//  PaintView.swift
//  PaintView
//
//  Created by William-Weng on 2019/2/20.
//  Copyright © 2019年 William-Weng. All rights reserved.
//
/// [swift3.0 CoreGraphics繪圖-實現畫板](https://www.jianshu.com/p/c0785249ffc5)
/// [Codable JSON 教學 (Swift 4)](https://medium.com/@jerrywang0420/codable-json-教學-swift-4-46aff2182bfe)

import UIKit

/*
 {
    "LinePoints": [
        [[11, 22], [22, 33], [33, 44]],
        [[12, 23], [23, 34], [34, 45]]
    ]
 }
 */

// MARK: - PaintView
class PaintView: UIView {
    
    public var pointListArray = [[CGPoint]]()
    
    private let ResultKey = "LinePoints"
    
    private var lineWidth = CGFloat(3)
    private var pointWidthArray = [CGFloat]()
    private var _pointArray = [CGPoint]()
    
    override func draw(_ rect: CGRect) {
        drawLines()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        saveMovedPoint(with: touches)
        show()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        saveLineInfo()
        updateFirebase(value: pointListArray, forKey: ResultKey)
        show()
    }
}

// MARK: - 公開的函式
extension PaintView {
    
    /// 畫出所有的線
    public func show() {
        setNeedsDisplay()
    }
    
    /// 清除所有的線
    public func clear() {
        
        pointListArray = [[CGPoint]]()
        _pointArray = [CGPoint]()
        show()
        
        updateFirebase(value: pointListArray, forKey: ResultKey)
    }
}

// MARK: - 小工具 (畫線)
extension PaintView {
    
    /// 重畫所有的線
    private func drawLines() {
        
        guard let context = cgContextMaker(with: .white) else { return }
        
        drawLineListArray(withPointListArray: pointListArray, on: context)
        drawLine(withPointArray: _pointArray, on: context)
    }

    /// 產生畫布
    private func cgContextMaker(with lineColor: UIColor) -> CGContext? {
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        lineColor.setStroke()

        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(lineWidth)
        
        return context
    }
    
    /// 根據記錄的點去畫線 (單)
    private func drawLine(withPointArray pointArray: [CGPoint], on context: CGContext) {
        
        guard let firstPoint = pointArray.first else { return }
        
        context.beginPath()
        context.move(to: firstPoint)
        
        for nextPoint in pointArray {
            context.addLine(to: nextPoint)
        }
        
        context.strokePath()
    }
    
    /// 根據記錄的點去畫線 (多)
    private func drawLineListArray(withPointListArray pointListArray: [[CGPoint]], on context: CGContext) {
        
        if pointListArray.count > 0 {
            for pointArray in pointListArray {
                drawLine(withPointArray: pointArray, on: context)
            }
        }
    }
}

// MARK: - 小工具 (記錄)
extension PaintView {
    
    /// 記錄移動的點
    private func saveMovedPoint(with touches: Set<UITouch>) {
        guard let point = touches.first?.location(in: self) else { return }
        _pointArray.append(point)
    }
    
    /// 記錄完整線條的資訊
    private func saveLineInfo() {
        pointWidthArray.append(lineWidth)
        pointListArray.append(_pointArray)
        _pointArray.removeAll()
    }
    
    /// 將CGPoint轉成Array
    private func pointToArray(pointArray: [CGPoint]) -> [[CGFloat]] {
        
        var listArray = [[CGFloat]]()
        
        for _point in pointArray {
            let _array = [_point.x, _point.y]
            listArray.append(_array)
        }
        
        return listArray
    }
    
    /// 將[[CGPint]] => [[[CGFloat]]]
    private func pointArrayToListArray(_ pointsArray: [[CGPoint]]) -> [[[CGFloat]]] {
        
        var listArray = [[[CGFloat]]]()
        
        for _pointArray in pointListArray {
            let array = pointToArray(pointArray: _pointArray)
            listArray.append(array)
        }
        
        return listArray
    }
    
    /// 更新線上資料庫
    private func updateFirebase(value: [[CGPoint]], forKey key: String) {
        
        let database = FIRDatabase.shared
        let listArray = pointArrayToListArray(value)
        
        // print("listArray = \(listArray)")

        database.setValue(listArray.description, forKey: ResultKey) { (isOK) in
            // print("isOK = \(isOK)")
        }
    }
}

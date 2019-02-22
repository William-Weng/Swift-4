//
//  ViewController.swift
//  PaintView
//
//  Created by William-Weng on 2019/2/20.
//  Copyright © 2019年 William-Weng. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    let ResultKey = "LinePoints"
    
    @IBOutlet var myPaintView: PaintView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func firebaseTest(_ sender: UIBarButtonItem) {
        
        let database = FIRDatabase.shared
        
        database.allValuesForRealTime { (result) in
            
            let testArray = self.linePointsToArray(with: result)
            let newListArray = self.arrayListArrayToCGPointListArray(testArray)
            
            self.myPaintView.pointListArray = newListArray
            self.myPaintView.show()
        }
    }
    
    @IBAction func clearPaintView(_ sender: UIBarButtonItem) {
        myPaintView.clear()
    }
    
    /// 將Array => CGPoint
    private func arrayListToCGPointList(_ arrayList: [[Double]]) -> [CGPoint] {
        
        let CGPointCount = 2
        var lineArray = [CGPoint]()
        
        for _array in arrayList {

            if _array.count == CGPointCount, let x = _array.first, let y = _array.last {
                let point = CGPoint(x: x, y: y)
                lineArray.append(point)
            }
        }
        
        return lineArray
    }

    /// 將[[[Double]]] => [[CGPoint]]
    private func arrayListArrayToCGPointListArray(_ arrayListArray: [[[Double]]]) -> [[CGPoint]] {
        
        var lineListArray = [[CGPoint]]()
        
        for _arrayList in arrayListArray {
            
            let arrayList = arrayListToCGPointList(_arrayList)
            lineListArray.append(arrayList)
        }
        
        return lineListArray
    }
}

// MARK: - 小工具
extension ViewController {
    
    /// 將JSON => [[[Double]]]，變成畫線要的資訊
    private func linePointsToArray(with result: [String : Any]?) -> [[[Double]]] {

        guard let result = result,
              let linePointsString = result[ResultKey] as? String,
              let linePointsList = JSON(parseJSON: linePointsString).array
        else {
            return [[[Double]]]()
        }
        
        let lineArray = lineArrayMaker(linePointsArray: linePointsList)
        
        var lineJSON = [[[JSON]]]()
        var linePointsValue = [[[Double]]]()
        
        for _line in lineArray {
            let pointArray = pointArrayMaker(lineArray: _line)
            lineJSON.append(pointArray)
        }
        
        for _line in lineJSON {
            let points = pointsMaker(pointArray: _line)
            linePointsValue.append(points)
        }
        
        return linePointsValue
    }
    
    /// 解開第一層(每條線的數據) => [[[CGPoint]]] => [[CGPoint]]
    private func lineArrayMaker(linePointsArray: [JSON]) -> [[JSON]] {
        
        var lineArray = [[JSON]]()
        
        for _linePoints in linePointsArray {
            if let pointArray = _linePoints.array {
                lineArray.append(pointArray)
            }
        }
        
        return lineArray
    }
    
    /// 解開第二層(每個點的數據)
    private func pointArrayMaker(lineArray: [JSON]) -> [[JSON]] {
        
        var pointArray = [[JSON]]()
        
        for _array in lineArray {
            let point = _array.array!
            pointArray.append(point)
        }
        
        return pointArray
    }
    
    /// 解開第三層(取得每個點的數據 ~> JSON => [Double])
    private func pointsMaker(pointArray: [[JSON]]) -> [[Double]] {
        
        var cgPointsArray = [[Double]]()
        
        for _point in pointArray {
            
            if _point.count == 2, let x = _point.first?.double, let y = _point.last?.double {
                let _array = [x, y]
                cgPointsArray.append(_array)
            }
        }
        
        return cgPointsArray
    }
}




//
//  FIRDatabase.swift
//  PaintView
//
//  Created by William-Weng on 2019/2/20.
//  Copyright © 2019年 William-Weng. All rights reserved.
//

import UIKit
import Firebase

class FIRDatabase: NSObject {
    
    public static let shared = FIRDatabase()
    private let database = Database.database().reference()
    
    private override init() { super.init() }
    
    /// 取得所有數據
    func allValues(result: @escaping ([String : Any]?) -> Void) {
        
        database.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDict = snapshot.value as? [String: Any] else { result(nil); return }
            result(userDict)
        }, withCancel: nil)
    }
    
    /// 取得所有數據 (Real Time)
    func allValuesForRealTime(result: @escaping ([String : Any]?) -> Void) {
        
        database.observe(.value, with: { (snapshot) in
            guard let userDict = snapshot.value as? [String: Any] else { result(nil); return }
            result(userDict)
        }, withCancel: nil)
    }
    
    /// 設定數據
    func setValue(_ value: String, forKey key: String, result: @escaping (Bool) -> Void) {
        
        database.child(key).setValue(value) { (error, reference) in
            if error != nil { result(false); return }
            result(true)
        }
    }
}

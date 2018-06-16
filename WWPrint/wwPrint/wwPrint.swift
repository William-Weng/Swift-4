//
//  ViewController2.swift
//  wwPrint
//
//  Created by William-Weng on 2018/6/14.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

/// 自定義的Print
public class wwPrint: UIViewController {
    
    static func verbose<T>(_ msg: T) { wwPrint(msg, logType: .verbose) }
    static func debug<T>(_ msg: T) { wwPrint(msg, logType: .debug) }
    static func info<T>(_ msg: T) { wwPrint(msg, logType: .info) }
    static func warning<T>(_ msg: T) { wwPrint(msg, logType: .warning) }
    static func error<T>(_ msg: T) { wwPrint(msg, logType: .error) }
}

extension wwPrint {
    
    private enum logType: String {
        case verbose = "✅"
        case debug = "🛃"
        case info = "📳"
        case warning = "🆘"
        case error = "🆖"
    }
    
    private static func wwPrint<T>(_ msg: T, file: String = #file, method: String = #function, line: Int = #line, logType: logType = .verbose) {
        #if DEBUG
            Swift.print("🚩 \((file as NSString).lastPathComponent)：\(line) - \(method) \n\t \(logType.rawValue) \(msg)")
        #endif
    }
}

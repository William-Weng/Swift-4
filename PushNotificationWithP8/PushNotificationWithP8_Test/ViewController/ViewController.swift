//
//  ViewController.swift
//  PushNotificationWithP8_Test
//
//  Created by 翁禹斌(William.Weng) on 2018/5/31.
//  Copyright © 2018年 翁禹斌(William.Weng). All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let personInfo = Person.Info.init(name: "William")
        let newPerson = Person(info: personInfo)
        
        print(newPerson.name)
    }
}

@dynamicMemberLookup
final class SystemFont: NSObject {
    
    static let shared = SystemFont()
    lazy var familyNames = familyNamesMaker()

    private override init() {}
    
    subscript(dynamicMember member: String) -> [String] {
        
        let properties = familyNames
        let defaultArray: [String] = []
        
        return properties[member, default: defaultArray]
    }
}

extension SystemFont {
    
    /// 將系統內的文字輸出
    /// {"PingFang_SC":["PingFangSC-Medium","PingFangSC-Semibold","PingFangSC-Light","PingFangSC-Ultralight","PingFangSC-Regular","PingFangSC-Thin"]}
    func familyNamesMaker() -> [String: [String]] {
    
        var familyNames: [String: [String]] = [:]

        UIFont.familyNames.forEach({ familyName in
            let newFamilyName = familyName.replacingOccurrences(of: " ", with: "_")
            familyNames[newFamilyName] = UIFont.fontNames(forFamilyName: familyName)
        })
                
        return familyNames
    }
}

@dynamicMemberLookup
struct Person {

    struct Info { var name: String }

    var info: Info

    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Info, Value>) -> Value {
        get { return info[keyPath: keyPath] }
        set { info[keyPath: keyPath] = newValue }
    }
}

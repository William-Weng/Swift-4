//
//  ViewController.swift
//  UILabel_AttributedString
//
//  Created by 翁禹斌(William.Weng) on 2018/6/8.
//  Copyright © 2018年 翁禹斌(William.Weng). All rights reserved.
//
/// [Swift生成屬性文本AttributedString](https://www.jianshu.com/p/e64a582bd4e2)
/// [為 iOS App 加入客製字型 (custom font)](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/為-ios-app-加入客製字型-custom-font-d2b28b0269e0)
/// [CoreText與TextKit入門](https://ivanyuan.farbox.com/post/coretextyu-textkitru-men)

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextField.addTarget(self, action: #selector(changeText(_:)), for: .editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func changeText(_ sender: UITextField) {
        let newAttributedText = attributedText(sender.text ?? "")
        sender.attributedText = newAttributedText
    }
}

extension ViewController {
    
    /// 設定屬性文字 -> 笨笨的一個字一個字去處理 (字太多會lag，或許用正規式比較好，原來UITextField是繼承WebKit啊)
    private func attributedText(_ text: String) -> NSMutableAttributedString? {
        
        let ttf = (english: "crayon_1-1.ttf", nonEnglish: "ShigotoMemogaki-Regular-1-01.ttf")
        let myAttrString = NSMutableAttributedString.init()
        
        let attribute : (english: [NSAttributedStringKey: Any], nonEnglish: [NSAttributedStringKey: Any]) = (
            english: [
                .foregroundColor: UIColor.blue,
                .font: UIFont.init(name: fontFullName(of: ttf.english)!, size: 40)!
            ],
            nonEnglish: [
                .foregroundColor: UIColor.red,
                .font: UIFont.init(name: fontFullName(of: ttf.nonEnglish)!, size: 20)!
            ]
        )

        for word in text.unicodeScalars {
            
            var _attrString = NSAttributedString.init()
            
            if word.isASCII {
                _attrString = NSAttributedString(string: "\(word)", attributes: attribute.english)
            } else {
                _attrString = NSAttributedString(string: "\(word)", attributes: attribute.nonEnglish)
            }
            
            myAttrString.append(_attrString)
        }
        
        return myAttrString
    }
    
    /// 取得字型檔的全名
    private func fontFullName(of ttf: String) -> String? {
       
        guard let url = Bundle.main.url(forResource: ttf, withExtension: nil) as CFURL?,
              let provider = CGDataProvider(url: url),
              let font = CGFont(provider)
        else {
            return nil
        }
        
        return font.fullName as String?
    }
}

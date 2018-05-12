//
//  WWEmojiLabel.swift
//  Unicode_Emoji
//
//  Created by William-Weng on 2018/5/12.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

@IBDesignable class WWEmojiLabel: UILabel {

    @IBInspectable var emojiUnicode: String = "" {
        willSet {
            adjustsFontSizeToFitWidth = true
            text = stringToUTF8(newValue)
        }
    }
}

extension WWEmojiLabel {
    
    /// 英文字串轉成Emoji
    private func stringToUTF8(_ string: String) -> String {
        
        let characterA: (ascii: String, unicode: UInt32, error: String) = ("A", 0x1F1E6, "❓") // (a, 🇦,❓)
        var unicodeString = ""
        
        for scalar in string.unicodeScalars {
            
            guard let asciiA = characterA.ascii.unicodeScalars.first,
                  let unicodeWord = UnicodeScalar(characterA.unicode + scalar.value - asciiA.value)
            else {
                unicodeString += characterA.error
                continue
            }
            
            let wordRange = Int(unicodeWord.value) - Int(characterA.unicode) + 1
            
            switch wordRange {
            case 1...26:
                unicodeString += unicodeWord.description
            default:
                unicodeString += characterA.error
            }
        }
        
        return unicodeString
    }
}

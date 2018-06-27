//
//  ViewController.swift
//  BezierText
//
//  Created by William.Weng on 2018/6/25.
//  Copyright © William.Weng. All rights reserved.
//
/// [Swift - 自動書寫文字的動畫效果（文字轉貝塞爾曲線、實現字跡動畫）](http://www.hangge.com/blog/cache/detail_1898.html)

import UIKit

class ViewController: UIViewController {

    var bezierTextView: WWBezierTextView!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bezierTextView = WWBezierTextView(frame: CGRect(x: 0, y: 160, width: view.bounds.width, height: 50))
        view.addSubview(bezierTextView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func writeText(_ sender: Any) {
        bezierTextView.show(text: textField.text!)
    }
}


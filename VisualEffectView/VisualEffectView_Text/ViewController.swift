//
//  ViewController.swift
//  VisualEffectView_Text
//
//  Created by William-Weng on 2018/9/21.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [Swift - 實現毛玻璃效果（Blur、模糊、虛化背景元素）](http://www.hangge.com/blog/cache/detail_1135.html)
/// [UIVisualEffectView Tutorial: Getting Started](https://www.raywenderlich.com/167-uivisualeffectview-tutorial-getting-started)

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.insertSubview(blurView, at: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


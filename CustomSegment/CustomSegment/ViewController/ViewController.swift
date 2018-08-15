//
//  ViewController.swift
//  CustomSegment
//
//  Created by William-Weng on 2018/8/13.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit
import WWSegmentControl

class ViewController: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var mySegmentControl: WWSegmentControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySegmentControl.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: WWSegmentControlDelegate {
    
    func nowSelectedIndex(_ index: Int, for button: UIButton) {
        print(index)
        myLabel.text = button.titleLabel?.text
    }
}





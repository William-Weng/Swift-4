//
//  Page1_ViewController.swift
//  ContainerView_Demo
//
//  Created by William-Weng on 2018/11/6.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class Page1_ViewController: PageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showMenu(_ sender: UIButton) {
        menuStatus(.show)
    }
    
    @IBAction func hideMenu(_ sender: UIButton) {
        menuStatus(.hide)
    }
}

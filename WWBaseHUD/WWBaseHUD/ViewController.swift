//
//  ViewController.swift
//  WWBaseHUD
//
//  Created by William-Weng on 2018/4/21.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let myHUD = WWBaseHUD.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showHUD(_ sender: UIButton) {
        myHUD.show()
    }
    
    @IBAction func hideHUD(_ sender: UIButton) {
        myHUD.hide()
    }
}


//
//  ViewController.swift
//  wwPrint
//
//  Created by William-Weng on 2018/6/14.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WWPrint.verbose("verbose")
        WWPrint.debug("debug")
        WWPrint.info("info")
        WWPrint.warning("warning")
        WWPrint.error("error")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


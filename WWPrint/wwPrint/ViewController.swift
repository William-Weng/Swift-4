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
        
        wwPrint.verbose("verbose")
        wwPrint.debug("debug")
        wwPrint.info("info")
        wwPrint.warning("warning")
        wwPrint.error("error")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//
//  WWBaseHUDViewController.swift
//  WWBaseHUD
//
//  Created by William-Weng on 2018/4/21.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class WWBaseHUDViewController: UIViewController {
    
    @IBOutlet weak var myIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .coverVertical
        
        myIndicator.startAnimating()
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    deinit { myIndicator.stopAnimating() }
}

//
//  DetailViewController.swift
//  TransitionAnimation
//
//  Created by William-Weng on 2018/07/07.
//  Copyright © 2017年 William-Weng. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    let segue = "unwindSegue"
    
    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        performSegue(withIdentifier: segue, sender: nil)
    }
}

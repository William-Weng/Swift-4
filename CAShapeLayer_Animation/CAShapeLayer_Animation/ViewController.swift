//
//  ViewController.swift
//  CAShapeLayer_Animation
//
//  Created by IIT-翁禹斌(William.Weng) on 2018/4/27.
//  Copyright © 2018年 IIT-翁禹斌(William.Weng). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var shapeLayerView: CAShapeLayerAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func drawAction(_ sender: UIButton) {
        shapeLayerView.drawing(with: 40)
    }
}

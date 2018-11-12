//
//  GameViewController.swift
//  SpaceBattle
//
//  Created by William-Weng on 2018/9/15.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initGameView()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController {
    
    /// 遊戲畫面初始化設定
    private func initGameView() {
        
        guard let view = self.view as? SKView,
              let scene = GameScene(fileNamed: "WinScene")
        else {
            return
        }
        
        scene.scaleMode = .aspectFill
        scene.size = CGSize.init(width: 1536, height: 2048)

        view.presentScene(scene)
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }
}

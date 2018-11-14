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
        return interfaceOrientations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - 小工具
extension GameViewController {
    
    /// 遊戲畫面初始化設定 (設定大小跟啟動畫面)
    private func initGameView() {
        
        guard let view = view as? SKView,
              let startUpScene = GameScene(fileNamed: GameConstant.Scene.startUp.rawValue),
              let maxSize = Optional.some(CGSize.init(width: 1536, height: 2048))
        else {
            return
        }

        startUpScene.scaleMode = .aspectFill
        startUpScene.size = maxSize

        view.showsFPS = true
        view.showsNodeCount = true
        view.ignoresSiblingOrder = true
        
        view.presentScene(startUpScene)
    }
    
    /// 支援旋轉的方向 (設備)
    private func interfaceOrientations() -> UIInterfaceOrientationMask {
        
        let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        
        switch userInterfaceIdiom {
        case .phone:
            return .allButUpsideDown
        default:
            return .all
        }
    }
}

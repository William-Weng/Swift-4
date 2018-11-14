//
//  WinScene.swift
//  SpaceBattle
//
//  Created by Yu-Bin Weng on 2018/11/12.
//  Copyright © 2018 William-Weng. All rights reserved.
//

import SpriteKit

class StartUpScene: SKScene {

    let gameHelper = GameHelper.shared
    
    override func didMove(to view: SKView) {
        initSceneSetting()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playGame(with: touches)
    }
}

extension StartUpScene {
    
    /// 分數設定 (初始化)
    private func initSceneSetting() {
        
        guard let currentScene = childNode(withName: GameConstant.Node.currentScene.rawValue) as? SKLabelNode,
              let bestScene = childNode(withName: GameConstant.Node.bestScene.rawValue) as? SKLabelNode
        else {
            return
        }
        
        currentScene.text = "當前分數：\(gameHelper.getScore(for: .currentScore))"
        bestScene.text = "最高分數：\(gameHelper.getScore(for: .bestScore))"
    }
    
    /// 開始遊戲 (切換畫面)
    private func playGame(with touches: Set<UITouch>) {
        
        guard let touch = touches.first,
              let location = Optional.some(touch.location(in: self)),
              let nodePoint = Optional.some(atPoint(location))
        else {
            return
        }
        
        if (nodePoint.name == GameConstant.Node.playButton.rawValue) {
            gameHelper.transferScene(from: self, to: GameConstant.Scene.game.rawValue)
        }
    }
}

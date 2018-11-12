//
//  WinScene.swift
//  SpaceBattle
//
//  Created by Yu-Bin Weng on 2018/11/12.
//  Copyright © 2018 William-Weng. All rights reserved.
//

import SpriteKit

class WinScene: SKScene {

    let gameHelper = GameHelper.shared
    
    override func didMove(to view: SKView) {
        
        guard let currentScene = childNode(withName: "CurrentScene") as? SKLabelNode,
              let bestScene = childNode(withName: "BestScene") as? SKLabelNode
        else {
            return
        }
        
        currentScene.text = "當前分數：\(gameHelper.getScore(for: .currentScore))"
        bestScene.text = "最高分數：\(gameHelper.getScore(for: .bestScore))"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodePoint = atPoint(location)
        
        if (nodePoint.name == "PlayButton") { gameHelper.transferScene(from: self, to: "GameScene") }
    }
}

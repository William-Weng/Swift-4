//
//  GameConstant.swift
//  SpaceBattle
//
//  Created by William-Weng on 2018/11/14.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class GameConstant: NSObject {
    
    static let gameSpeed: TimeInterval = 100
    
    /* 場景代號 */
    enum Scene: String {
        case startUp = "StartUpScene"
        case game = "GameScene"
    }
    
    /* 音效名稱 */
    enum Sound: String {
        case explosion = "Explosion.mp3"
        case torpedo = "Torpedo.mp3"
    }
    
    /* 音樂名稱 */
    enum Music: String {
        case spaceBattle = "SpaceBattle.mp3"
    }
    
    /* 物體節點 */
    enum Node: String {
        case background = "backgroundNode"
        case player = "PlayerNode"
        case currentScene = "CurrentScene"
        case bestScene = "BestScene"
        case playButton = "PlayButton"
    }
    
    /* 碰撞效果 */
    enum Effect: String {
        case Explosion = "Explosion"
        case ExplosionBlue = "ExplosionBlue"
        case ShootTrailBlue = "ShootTrailBlue"
    }
}

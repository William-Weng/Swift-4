//
//  ViewController.swift
//  TicTacToe
//
//  Created by William-Weng on 2018/11/22.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

enum PieceStatus: String {
    case none = "？"
    case circle = "〇"
    case cross = "✕"
}

class ViewController: UIViewController {

    @IBOutlet var gamePieces: [GameButton]!
    
    var nowPiece: PieceStatus = .circle
    var clickedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAllStatus()
    }
    
    @IBAction func clickedPiece(_ sender: GameButton) {
        
        let piece = nowPiece
        
        sender.status = nowPiece
        sender.isEnabled = false
        
        clickedCount += 1
        
        nowPiece = (piece == .circle) ? .cross : .circle
        testGameWin(with: gamePieces)
    }
}

// MARK: - 主工具
extension ViewController {
    
    /// 初始化狀態
    private func initAllStatus() {
        initButtons()
        initStatus()
    }
    
    /// 測試遊戲誰贏？ (很笨的一個一個算)
    private func testGameWin(with buttons: [GameButton]) {
        
        /* 記錄直行的數值 */
        var statusRowArray: [[Int: PieceStatus]] = [
            [1: .none, 2: .none, 3: .none],
            [1: .none, 2: .none, 3: .none],
            [1: .none, 2: .none, 3: .none]
        ]
        
        /* 記錄橫行的數值 */
        var statusColumnArray: [[Int: PieceStatus]] = [
            [1: .none, 2: .none, 3: .none],
            [1: .none, 2: .none, 3: .none],
            [1: .none, 2: .none, 3: .none]
        ]
        
        for button in buttons {
            
            let row = button.index.row
            let column = button.index.column
            
            statusRowArray[row - 1][column] = button.status
            statusColumnArray[column - 1][row] = button.status
        }
        
        testAllPieceAndClickedCount(rowArray: statusRowArray, columnArray: statusColumnArray)
    }
}

// MARK: - 小工具
extension ViewController {
    
    /// 初始化Buttons
    private func initButtons() {
        
        for button in gamePieces {
            button.status = .none; button.isEnabled = true
        }
    }
    
    /// 初始化變數
    private func initStatus() {
        clickedCount = 0
        nowPiece = .circle
    }
    
    /// 測試所有的可能 (包含沒有勝負)
    private func testAllPieceAndClickedCount(rowArray: [[Int: PieceStatus]], columnArray: [[Int: PieceStatus]]) {
        
        /* 記錄交叉的數值 */
        let crossArray: [[Int: PieceStatus]] = [
            [1: rowArray[0][1]!, 2: rowArray[1][2]!, 3: rowArray[2][3]!],
            [1: rowArray[0][3]!, 2: rowArray[1][2]!, 3: rowArray[2][1]!]
        ]
        
        for statusArray in rowArray {
            let whoWin = testWhoWin(statusArray: statusArray)
            if (whoWin.win) { showAlert(with: whoWin.status.rawValue); return }
        }
        
        for statusArray in columnArray {
            let whoWin = testWhoWin(statusArray: statusArray)
            if (whoWin.win) { showAlert(with: whoWin.status.rawValue); return }
        }
        
        for statusArray in crossArray {
            let whoWin = testWhoWin(statusArray: statusArray)
            if (whoWin.win) { showAlert(with: whoWin.status.rawValue); return }
        }
        
        if (clickedCount == 9) { showAlert(with: PieceStatus.none.rawValue) }
    }
    
    /// 測試的算法 (三格都一樣就贏了)
    private func testWhoWin(statusArray: [Int: PieceStatus]) -> (win: Bool, status: PieceStatus) {
        
        if (statusArray[1] == PieceStatus.none || statusArray[2] == PieceStatus.none || statusArray[3] == PieceStatus.none) {
            return (false, PieceStatus.none)
        }
        
        if (statusArray[1] == statusArray[2] && statusArray[2] == statusArray[3]) {
            return (true, statusArray[1]!)
        }
        
        return (false, PieceStatus.none)
    }
    
    /// 顯示提示視窗
    func showAlert(with message: String) {
        
        let alertController = UIAlertController(title: "提示", message: "\(message)贏", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "確認", style: .default, handler: { _ in
            self.initAllStatus()
        })
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

class GameButton: UIButton {
    
    var status: PieceStatus = .none {
        
        willSet {
            
            index = (tag / 10, tag % 10)
            
            switch newValue {
            case .circle: setImage(#imageLiteral(resourceName: "Circle"), for: .normal)
            case .cross: setImage(#imageLiteral(resourceName: "Cross"), for: .normal)
            case .none: setImage(nil, for: .normal)
            }
        }
    }
    
    var index: (row: Int, column: Int) = (0, 0)
}





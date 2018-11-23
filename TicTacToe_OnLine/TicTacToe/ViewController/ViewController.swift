//
//  ViewController.swift
//  TicTacToe
//
//  Created by William-Weng on 2018/11/22.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [Read data from firebase swift](https://stackoverflow.com/questions/41933105/read-data-from-firebase-swift)

import UIKit
import Firebase
import PKHUD

enum PieceStatus: Int {
    case none = 0
    case circle = 1
    case cross = -1
    
    func title() -> String {
        
        switch self {
        case .circle: return "⭕️"
        case .cross: return "❌"
        case .none: return "❓"
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet var gamePieces: [GameButton]!
    
    var nowPiece: PieceStatus = .circle
    var pieceArray = [String: Int]()
    var isOK = (update: false ,now: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initButtons()
        clearDatabase()
        gatAllValues()
    }
    
    /// 選擇按鍵後的變化
    @IBAction func clickedPiece(_ sender: GameButton) {
        
        let database = FIRDatabase.shared

        database.setValue(nowPiece.rawValue, for: "\(sender.tag)", result: { isOK in
            self.isOK.update = isOK
            
            database.setValue(self.nowPiece.rawValue, for: "now", result: { isOK in
                self.isOK.now = isOK
                
                database.allValues(result: { (array) in
                    guard let array = array as? [String: Int] else { return }
                    DispatchQueue.main.async { self.gameButtonsImage(array) }
                    self.pieceArray = array
                    print("Array = \(array)")
                })
                
                print(self.isOK)
            })
        })

        sender.status = nowPiece
        sender.isEnabled = false
    }
}

// MARK: - 主工具
extension ViewController {
    
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
    
    /// 設定全部按鍵的圖示
    private func gameButtonsImage(_ array: [String: Int]) {
        
        for key in array.keys {
            setGameButton(for: key)
        }
        
        testGameWin(with: gamePieces)
    }
}

// MARK: - 小工具
extension ViewController {
    
    /// 初始化Buttons
    private func initButtons() {
        
        for button in gamePieces {
            button.status = .none; button.isEnabled = true
        }
        
        PKHUD.sharedHUD.hide()
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
        
        if (gameOverStatus()) { showAlert(with: PieceStatus.none.rawValue) }
    }
    
    /// 監聽值的變化
    private func gatAllValues() {
        
        let db = FIRDatabase.shared
        
        db.allValuesForRealTime { (array) in
            
            guard let array = array as? [String: Int],
                  let nowPiece = array["now"],
                  let nowPieceType = PieceStatus.init(rawValue: nowPiece)
            else {
                return
            }
            
            print("RealTime => \(array)")
            
            if (nowPieceType != self.nowPiece) {
                PKHUD.sharedHUD.hide()
                DispatchQueue.main.async { self.gameButtonsImage(array) }
            } else {
                PKHUD.sharedHUD.contentView = PKHUDProgressView()
                PKHUD.sharedHUD.show()
            }
            
            self.pieceArray = array
        }
    }
    
    /// 全部都按完的時候
    private func gameOverStatus() -> Bool {
        for piece in gamePieces { if (piece.status == .none) { return false } }
        return true
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
    func showAlert(with message: Int) {
        
        PKHUD.sharedHUD.hide()
        
        let title = PieceStatus.init(rawValue: message)?.title() ?? PieceStatus.none.title()
        let alertController = UIAlertController(title: "提示", message: "\(title)贏", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "確認", style: .default, handler: { _ in
            self.initButtons()
            self.clearDatabase()
        })
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 清空資料庫
    private func clearDatabase() {
        
        let database = FIRDatabase.shared
        let infos: [(key: String, value: Int)] = [
            ("11", 0), ("12", 0), ("13", 0),
            ("21", 0), ("22", 0), ("23", 0),
            ("31", 0), ("32", 0), ("33", 0),
            ("now", 0)
        ]
        
        for info in infos {
            database.setValue(info.value, for: info.key, result: { isOK in
                print("isOK = \(isOK)")
            })
        }
    }

    /// 設定按鍵圖示與狀態
    private func setGameButton(for key: String) {
        
        guard let gameButton = view.viewWithTag(Int(key) ?? 0) as? GameButton,
              let value = pieceArray[key]
        else {
            return
        }
        
        gameButton.isEnabled = (value == 0) ? true : false
        gameButton.status = PieceStatus.init(rawValue: value) ?? .none
    }
}

class GameButton: UIButton {
    
    /* 利用tag當作(x, y)的值 */
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





//
//  ViewController.swift
//  Lottery
//
//  Created by William-Weng on 2019/1/28.
//  Copyright © 2019年 William-Weng. All rights reserved.
//
/// [如何檢測搖一搖手勢 - Shake](https://swift.gg/2017/07/18/detect-shake-gestures-ios-tutorial-ios10/)

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var userLottery: UIImageView!
    
    let rotationZ = "transform.rotation.z"
    let syntesizer = AVSpeechSynthesizer()
    
    var isLoading = false
    var lotteryArray = ["電視", "冰箱", "電扇", "Switch", "PS4", "Mac Air 2018"]
    var result: [String] = []
    var utterance = AVSpeechUtterance()
    var player: AVAudioPlayer?
    
    lazy var lotteryData: Set<String> = lotteryDataMaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarClear()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake { lottery() }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingController = segue.destination as? SettingController {
            settingController.dataArray = lotteryArray
        }
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        refreshData()
    }
}

/// MARK: - 主功能
extension ViewController {
    
    /// 更新資料
    func refreshData() {
        lotteryData = lotteryDataMaker()
        result = []
    }
    
    /// 搖籤筒 => 抽籤
    private func lottery() {
        
        if isLoading { return }
        
        CATransaction.setCompletionBlock({
            self.player?.stop()
            self.selectLottery()
        })
        
        let animation = CAKeyframeAnimation()
        let shakeAngle = angleToRadian(30)
        let animationKey = rotationZ
        
        animation.keyPath = animationKey
        animation.values = [shakeAngle, -1 * shakeAngle, shakeAngle]
        animation.repeatCount = 10
        animation.duration = 0.2
        
        myImageView.layer.add(animation, forKey: animationKey)
        
        isLoading = true
        userLottery.center = myImageView.center
        playSound()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.commit()
    }
    
    /// 抽籤
    private func selectLottery() {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.1, options: [], animations: {
            self.userLottery.center = self.view.center
        }, completion: { (isFinish) in
            
            guard let title = self.lotteryData.randomElement() else {
                self.showResult(); return
            }
            
            let alert = self.myAlertController(with: title)

            self.present(alert, animated: true, completion: {
                self.result.append(title)
                self.lotteryData.remove(title)
                self.readMessage(title)
            })
        })
    }
    
    /// 顯示結果
    private func showResult() {
        
        var resultString = String()
        
        for (index, value) in self.result.enumerated() {
            resultString += "第\(index + 1)組: \(value) \n"
        }
        
        let alert = self.myAlertController(with: resultString)
        self.present(alert, animated: true, completion: nil)
    }
}

/// MARK: - 小工具
extension ViewController {
    
    /// 180° => π
    private func angleToRadian(_ angle: Float) -> Float {
        return (angle / 180.0) * Float.pi
    }
    
    /// 產生籤筒資料
    private func lotteryDataMaker() -> Set<String> {
        let data: Set<String> = Set(lotteryArray)
        return data
    }
    
    /// 讀取文字
    private func readMessage(_ message: String) {
        utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh_TW")
        utterance.rate = 0.5
        syntesizer.speak(utterance)
    }
    
    /// 提示框
    private func myAlertController(with title: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: "", message: title, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "確定", style: .cancel) { (alert) in
            self.isLoading = false
        }
        
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    /// navigationBar => 透明
    private func navigationBarClear() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    /// 播放聲音
    private func playSound() {
        
        player?.stop()
        
        guard let url = Bundle.main.url(forResource: "shake", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            guard let player = player else { return }
            
            player.numberOfLoops = -1
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}




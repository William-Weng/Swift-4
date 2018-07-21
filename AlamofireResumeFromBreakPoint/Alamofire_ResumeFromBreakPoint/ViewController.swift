//
//  AppDelegate.swift
//  Alamofire_ResumeFromBreakPoint
//
//  Created by William-Weng on 2018/5/28.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [swift3 用Alamofire下載視頻、斷點續傳](https://blog.csdn.net/u012297622/article/details/62089220)

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet var myUIImageViews: [UIImageView]!
    @IBOutlet var myProgresses: [UIProgressView]!
    @IBOutlet var myprogressLabels: [UILabel]!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var imageInfo: [(url: String, isLoaded: Bool)] = [
        ("http://www.theenergytrail.com/wp-content/uploads/2017/03/tax-credits-1.jpeg", false),
        ("http://www.theenergytrail.com/wp-content/uploads/2017/03/st.-patricks-day.jpeg", false),
        ("http://www.theenergytrail.com/wp-content/uploads/2017/03/marchmadness2.jpg", false),
    ]
    
    var cancelledData: Data? // 停止下載時保存已下載部分
    var downloadRequest: DownloadRequest!
    var index = 0
    
    // 指定下載路徑
    let destination: DownloadRequest.DownloadFileDestination = { _, response in
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let temporaryURL = FileManager.default.temporaryDirectory
        let fileURL = temporaryURL.appendingPathComponent(response.suggestedFilename!)
        
        print("documentURL => \(temporaryURL), pathFromLibrary => \(fileURL)")
        
        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _imageInfo in imageInfo {
            ImageCache.default.removeImage(forKey: _imageInfo.url)
        }
        
        for (index, imageView) in myUIImageViews.enumerated() {
            
            let url = URL.init(string: self.imageInfo[index].url)!
            
            imageView.kf.setImage(with: url, placeholder: nil, options: [.onlyFromCache], progressBlock: nil, completionHandler: { (image, error, type, url) in
                
                if image != nil {
                    self.imageInfo[index].isLoaded = true
                    self.myProgresses[index].setProgress(1.00, animated: false)
                    self.myprogressLabels[index].text = "100.00 %"
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func beginDownload(_ sender: UIButton) {
        
        guard index < imageInfo.count else { return }
        
        guard !imageInfo[index].isLoaded else {
            index += 1
            beginDownload(sender); return
        }
        
        if let cancelledData = self.cancelledData {
            // 續傳
            self.downloadRequest = Alamofire.download(resumingWith: cancelledData, to: self.destination)
            self.downloadRequest.downloadProgress(closure: downloadProgress)
            self.downloadRequest.responseData(completionHandler: downloadResponse)
        } else {
            // 開始下載
            self.downloadRequest = Alamofire.download(self.imageInfo[self.index].url, to: self.destination)
            self.downloadRequest.downloadProgress(closure: downloadProgress)
            self.downloadRequest.responseData(completionHandler: downloadResponse)
        }
        
        startButton.isEnabled = false
        stopButton.isEnabled = true
    }
    
    @IBAction func pauseDownload(_ sender: UIButton) {
        self.downloadRequest?.cancel()
        startButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
    @IBAction func delAllImages() {
        
        let fileManager = FileManager.default
        let temporaryURL = FileManager.default.temporaryDirectory
        let allFileArray = fileManager.subpaths(atPath: temporaryURL.path)
        
        for filename in allFileArray! {
            try! fileManager.removeItem(atPath: temporaryURL.path + "/\(filename)")
        }
    }
    
    func downloadProgress(progress: Progress) {
        
        let nowProgress = progress.fractionCompleted
        
        self.myProgresses[index].setProgress(Float(nowProgress), animated: true)
        self.myprogressLabels[index].text = String.init(format: "%6.2f %%",nowProgress * 100)
    }
    
    func downloadResponse(response: DownloadResponse<Data>) {
        
        switch response.result {
        case .success(_):
            // 下載完成
            guard index < imageInfo.count else { return }
            
            cancelledData = nil
            
            DispatchQueue.main.async {
                
                let image = UIImage.init(named: (response.destinationURL?.path)!)
                ImageCache.default.store(image!, forKey: self.imageInfo[self.index].url)
                
                self.myUIImageViews[self.index].kf.setImage(with: URL.init(string: self.imageInfo[self.index].url)!, placeholder: nil, options: [.onlyFromCache], progressBlock: nil, completionHandler: { (image, error, type, url) in
                    print(self.index)
                })
                
                self.index += 1
                self.beginDownload(self.startButton)
            }
            
        case .failure(_):
            self.cancelledData = response.resumeData; break
        }
    }
}

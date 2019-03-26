//
//  ViewController.swift
//  UITableViewPerformBatchUpdates
//
//  Created by William-Weng on 2019/3/26.
//  Copyright © 2019年 William-Weng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    private let NumberOfLines = (infinite: 0, lines: 2)
    private let TestMessages = [
        "Swift 5.0 is the next major release of Swift, and brings ABI stability at long last. That's not all, though: several key new features are already implemented, including raw strings, future enum cases, a Result type, checking for integer multiples and more.",
        "Swift’s Result type is implemented as an enum that has two cases: success and failure. Both are implemented using generics so they can have an associated value of your choosing, but failure must be something that conforms to Swift’s Error type.",
        "The fetching function will accept a URL string as its first parameter, and a completion handler as its second parameter. That completion handler will itself accept a Result, where the success case will store an integer, and the failure case will be some sort of NetworkError. We’re not actually going to connect to a server here, but using a completion handler at least lets us simulate asynchronous code.",
        "Third, rather than using a specific error enum that you’ve created, you can also use the general Error protocol. In fact, the Swift Evolution proposal says “it's expected that most uses of Result will use Swift.Error as the Error type argument.”",
        "SE-0200 added the ability to create raw strings, where backslashes and quote marks are interpreted as those literal symbols rather than escapes characters or string terminators. This makes a number of use cases more easy, but regular expressions in particular will benefit.",
        ]

    private var expandSet = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    /// 折疊Label (修改numberOfLines)
    @objc private func expandCell(_ sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        if expandSet.contains(indexPath.row) {
            expandSet.remove(indexPath.row)
        } else {
            expandSet.insert(indexPath.row)
        }
        
        myTableView.performBatchUpdates({
            myTableView.reloadRows(at: [indexPath], with: .automatic)
        }, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let myCell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.Identifier) as? MyTableViewCell else { fatalError() }
        
        let row = indexPath.row
        
        myCell.myLabel.text = TestMessages[row]
        myCell.myLabel.numberOfLines = expandSet.contains(row) ? NumberOfLines.infinite : NumberOfLines.lines
        
        myCell.myButton.tag = indexPath.row
        myCell.myButton.addTarget(self, action: #selector(expandCell(_:)), for: .touchUpInside)
        
        myCell.selectionStyle = .none
        
        return myCell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - 小工具
extension ViewController {
    
    /// TableView初始設定
    private func initSetting() {
        myTableView.delegate = self
        myTableView.dataSource = self
    }
}

class MyTableViewCell: UITableViewCell {
    
    public static let Identifier = "MyTableViewCell"
    
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myLabel: UILabel!
}

//
//  ViewController.swift
//  OCard_TableView
//
//  Created by William-Weng on 2019/3/13.
//  Copyright © 2019年 William-Weng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myTableView: MyTableView!
    
    private let CellIdentifier = "MyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) else { fatalError() }
        
        switch indexPath.row {
        case 0:  cell.backgroundColor = .clear
        default: cell.backgroundColor = .blue
        }
        
        cell.textLabel?.text = "\(indexPath.row)"
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellHeight: CGFloat = 0
        
        switch indexPath.row {
        case 0:  cellHeight = myView.frame.height - 44.0
        default: cellHeight = 66.0
        }

        return cellHeight
    }
}

// MARK: - 小工具
extension ViewController {
    
    /// 初始化設定
    private func initSetting() {
        myTableView.dataSource = self
        myTableView.delegate = self
    }
}


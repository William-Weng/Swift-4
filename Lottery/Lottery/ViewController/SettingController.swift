//
//  SettingController.swift
//  Lottery
//
//  Created by William-Weng on 2019/1/28.
//  Copyright © 2019年 William-Weng. All rights reserved.
//

import UIKit

class SettingController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    var dataArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetting()
        
        print(dataArray)
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        dataArray.append("----")
        myTableView.reloadData()
    }
    
    @IBAction func updateItem(_ sender: UIBarButtonItem) {
        
        guard let viewControllers = navigationController?.viewControllers else { return }
        
        for _viewController in viewControllers {
            
            if let viewController = _viewController as? ViewController {
                
                viewController.lotteryArray = dataArray
                viewController.refreshData()
                navigationController?.popToViewController(viewController, animated: true)
            }
        }
    }
}

extension SettingController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = dataArray[indexPath.row]
        let alert = myAlertController(with: title)
        
        present(alert, animated: true, completion: nil)
    }
}

extension SettingController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") else { return UITableViewCell() }
        cell.textLabel?.text = "\(dataArray[indexPath.row])"
        
        return cell
    }
}

extension SettingController {
   
    /// TableView基本設定
    private func tableViewSetting() {
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    /// 提示框
    private func myAlertController(with title: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: "", message: "請輸入選項", preferredStyle: .alert)
        
        alertController.addTextField {(textField: UITextField!) -> Void in
            textField.text = title
            textField.placeholder = "請輸入選項"
        }
        
        let cancelAction = UIAlertAction(title: "確定", style: .cancel) { (alert) in

            guard let selectedIndexPath = self.myTableView.indexPathForSelectedRow,
                  let textField = alertController.textFields?.first,
                  let text = textField.text
            else {
                return
            }
            
            self.dataArray[selectedIndexPath.row] = text
            self.myTableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        
        return alertController
    }
}

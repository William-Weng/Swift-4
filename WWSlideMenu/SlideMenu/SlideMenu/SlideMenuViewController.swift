//
//  SlideMenuViewController.swift
//  SlideMenu
//
//  Created by William-Weng on 2018/10/24.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int)
}

class SlideMenuViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet var closeMenuButton : UIButton!
    
    let cellname = "SlideMenuCell"
    
    var myDelegate : SlideMenuDelegate?
    var menuButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.tableFooterView = UIView()
    }
}

extension SlideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let menuCell = tableView.dequeueReusableCell(withIdentifier: cellname) as? SlideMenuCell else { return UITableViewCell() }
        
        menuCell.selectionStyle = .none
        menuCell.layoutMargins = .zero
        menuCell.backgroundColor = .clear
        menuCell.preservesSuperviewLayoutMargins = false
        menuCell.myLabelView.text = "選項\(indexPath.row)"
        
        return menuCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myDelegate?.slideMenuItemSelectedAtIndex(indexPath.row)
        menuButton.tag = 0
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
}




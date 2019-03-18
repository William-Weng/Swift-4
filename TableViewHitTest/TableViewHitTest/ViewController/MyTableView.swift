//
//  MyTableView.swift
//  OCard_TableView
//
//  Created by William-Weng on 2019/3/18.
//  Copyright © 2019年 William-Weng. All rights reserved.
//

import UIKit

class MyTableView: UITableView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        /// 利用hitTest讓Cell按下沒有反應
        guard let selectedIndexPath = indexPathForRow(at: point) else { return super.hitTest(point, with: event) }
        if selectedIndexPath.row == 0 { return nil }
        
        return super.hitTest(point, with: event)
    }
}

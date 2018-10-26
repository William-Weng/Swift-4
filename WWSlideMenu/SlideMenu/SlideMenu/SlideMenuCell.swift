//
//  SlideMenuCell.swift
//  SlideMenu
//
//  Created by William-Weng on 2018/10/24.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class SlideMenuCell: UITableViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

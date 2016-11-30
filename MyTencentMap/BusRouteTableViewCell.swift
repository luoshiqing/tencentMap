//
//  BusRouteTableViewCell.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/8.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class BusRouteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    @IBOutlet weak var formLabel: UILabel!
    
    @IBOutlet weak var tipLabel: UILabel! //标签
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  PoiSearchTableViewCell.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/4.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class PoiSearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

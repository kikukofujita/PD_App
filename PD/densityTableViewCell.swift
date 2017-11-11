//
//  densityTableViewCell.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/25.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit

class densityTableViewCell: UITableViewCell {

    @IBOutlet weak var densityLabel: UILabel!
 //   @IBOutlet weak var densityAdd: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setListData(list: ListD) {
        self.densityLabel.text = list.listDensity
        
    }
    
}

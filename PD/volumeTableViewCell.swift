//
//  volumeTableViewCell.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/25.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit

class volumeTableViewCell: UITableViewCell {

    @IBOutlet weak var volumeLabel: UILabel!
//    @IBOutlet weak var addVolume: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setListDataV(list: ListV) {
        self.volumeLabel.text = String(list.listVolume)
        
    }
    
}

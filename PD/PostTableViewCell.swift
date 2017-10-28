//
//  PostTableViewCell.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/20.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import ESTabBarController

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var densityLabel: UILabel!
    @IBOutlet weak var PVolumeLabel: UILabel!
    @IBOutlet weak var stopPLabel: UILabel!
    @IBOutlet weak var startWLabel: UILabel!
    @IBOutlet weak var PtimeLabel: UILabel!
    @IBOutlet weak var WtimeLabel: UILabel!
    @IBOutlet weak var WVolumeLabel: UILabel!
    @IBOutlet weak var wasteLabel: UILabel!
    @IBOutlet weak var etc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(postData: PostData) {
        self.densityLabel.text = postData.density
        
        let pv = postData.pouringVolume?.description
        self.PVolumeLabel.text = pv ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let stpp:String = formatter.string(from: postData.stopPouring! as Date)
        stopPLabel.text = stpp
        
        let sttw:String = formatter.string(from: postData.startWaste! as Date)
        startWLabel.text = sttw
        
        let bp = postData.weight?.description
        etc.text = "\(String(describing: bp)) + \n + \(String(describing: postData.bloodPressure))"
    }
}

    


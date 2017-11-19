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
    @IBOutlet weak var etc: UITextView!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var fDateText: UILabel!
    @IBOutlet weak var idText: UILabel!
    @IBOutlet weak var differenceText: UILabel!
    @IBOutlet weak var stockPlace: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
/*    func setData(data: Data) {
        print("PostTableViewCell data = \(data)")
        self.densityLabel.text = data.density
        self.weight.text = String(data.weight)
        
        let pv = data.pouringVolume.description
        self.PVolumeLabel.text = pv
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let stpp:String = formatter.string(from: data.stopPouring as Date)
        stopPLabel.text = stpp
        
        let sttw:String = formatter.string(from: data.startWaste as Date)
        startWLabel.text = sttw
        
        self.PtimeLabel.text = data.pouringTime
        self.WtimeLabel.text = data.wasteTime
*/
/*        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy/MM/dd"
        let fd:String = formatter2.string(from: data.date as Date)
        fDateText.text = fd       */
/*        fDateText.text = data.findDate
        
        let bp = data.weight.description
        etc.text = "\(String(describing: bp)) + \n + \(String(describing: data.bloodPressure))"
    }
*/
}

    


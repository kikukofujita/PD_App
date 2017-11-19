//
//  StockTableViewCell.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/11/15.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import RealmSwift

class StockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var densityText: UILabel!

    @IBOutlet weak var homeUse: UILabel!
    @IBOutlet weak var homeAll: UILabel!
    @IBOutlet weak var homeNow: UILabel!
    @IBOutlet weak var homeNext: UILabel!

    @IBOutlet weak var otherUse: UILabel!
    @IBOutlet weak var otherAll: UILabel!
    @IBOutlet weak var otherNow: UILabel!

    @IBOutlet weak var idText: UILabel!
    
    let realm = try! Realm()
    var denArray = try! Realm().objects(ListD.self).sorted(byKeyPath: "id", ascending: false)
    var list = ListD.self
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(listD: ListD) {
        self.homeAll.text = listD.homeAllStock.description
        self.homeUse.text = ""
        self.homeNow.text = "0"
        self.densityText.text = listD.listDensity
        self.homeNext.text = ""
        
   //     self.homeData.text = listD.home
 
/*        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let hNow:String = formatter.string(from: listD.homeDate as Date)
*/        self.homeNext.text = ""
        }
    
}

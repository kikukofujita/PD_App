//
//  PostData.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/19.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class  PostData: NSObject {
    var id: String?
    var email: String?       // user Email
    var uid:String?          // user id
    var realmId: Int?        // realmのid
    
    var date: String?           // 日付　　time
    var startPouring: String?   // 注液スタート  startPtime
    var stopPouring: String?    // 注液ストップ  stopPtime
    var startWaste: String?     // 廃液スタート  startWtime
    var stopWaste: String?      // 廃液ストップ  stopWtime
    var pouringVolume: Int?     // 注液量      pouringV
    var wasteVolume: Int?       // 廃液量      wasteV
    var difference: Int?        // 徐水量（廃液量 - 注液量）
    var density: String?        // 透析液濃度   density
    var liquidWaste: String?    // 廃液の状態   waste
    var totalWaste: Int?        // 総排水量（1日） totalW
    var outletCondition: String?  // 出口部状態   outlet
    var bloodPressure: String?   // 血圧         BP
    var weight: Double?          // 体重         weight
    var uniqueId: String?        // realmとのリレーションキー
    var stockplace: String?     // 保存場所
    
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionay = snapshot.value as! [String: AnyObject]
        
        let em = valueDictionay["email"] as? String
        self.email = em
        
        let ui = valueDictionay["uid"] as? String
        self.uid = ui
        
        let time = valueDictionay["time"] as? String
        self.date = time  //Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        let startPtime = valueDictionay["startPtime"] as? String
        self.startPouring = startPtime   //Date(timeIntervalSinceReferenceDate: TimeInterval(startPtime!)!)

        let stopPtime = valueDictionay["stopPtime"] as? String
        self.stopPouring = stopPtime     //Date(timeIntervalSinceReferenceDate: TimeInterval(stopPtime!)!)
        
        let startWtime = valueDictionay["startWtime"] as? String
        self.startWaste = startWtime       //Date(timeIntervalSinceReferenceDate: TimeInterval(startWtime!)!)
        
        let stopWtime = valueDictionay["stopWtime"] as? String
        self.stopWaste = stopWtime           //Date(timeIntervalSinceReferenceDate: TimeInterval(stopWtime!)!)
        
        let pouringV = valueDictionay["pouringV"] as? String
        let pv = (pouringV == nil ? 0 : Int(pouringV!)!)
        self.pouringVolume = pv
        
        let wasteV = valueDictionay["wasteV"] as? String
        let wv = (wasteV == nil ? 0 : Int(wasteV!)!)
        self.wasteVolume = wv
        
        let dV = valueDictionay["difference"] as? Int
        self.difference = dV
        
        self.density = valueDictionay["density"] as? String
        
        self.liquidWaste = valueDictionay["waste"] as? String
        
/*        let totalW = valueDictionay["totalW"] as? String
        let tw = (totalW == "" ? 0 : Int(totalW!)!)
        self.totalWaste = tw
*/
        self.outletCondition = valueDictionay["outlet"] as? String
        
        self.bloodPressure = valueDictionay["BP"] as? String
        
        let wt = valueDictionay["weight"] as? String
        let wt2 = (wt == nil ? 0.0 : Double(wt!)!)
        self.weight = wt2
        
        self.uniqueId = valueDictionay["uniqueId"] as? String
        

        }
    }
    
    
    

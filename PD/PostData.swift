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
    var date: Date?           // 日付　　time
    var startPouring: Date?   // 注液スタート  startPtime
    var stopPouring: Date?    // 注液ストップ  stopPtime
    var startWaste: Date?     // 廃液スタート  startWtime
    var stopWaste: Date?      // 廃液ストップ  stopWtime
    var pouringVolume: Int?     // 注液量      pouringV
    var wasteVolume: Int?       // 廃液量      wasteV
    var difference: Int?        // 徐水量（廃液量 - 注液量）
    var density: String?        // 透析液濃度   density
    var liquidWaste: String?    // 廃液の状態   waste
    var totalWaste: Int?        // 総排水量（1日） totalW
    var outletCondition: String?  // 出口部状態   outlet
    var bloodPressure: String?   // 血圧         BP
    var weight: Double?          // 体重         weight
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionay = snapshot.value as! [String: AnyObject]
        
        let time = valueDictionay["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        let startPtime = valueDictionay["startPtime"] as? String
        self.startPouring = Date(timeIntervalSinceReferenceDate: TimeInterval(startPtime!)!)

        let stopPtime = valueDictionay["stopPtime"] as? String
        self.stopPouring = Date(timeIntervalSinceReferenceDate: TimeInterval(stopPtime!)!)
        
        let startWtime = valueDictionay["startWtime"] as? String
        self.startWaste = Date(timeIntervalSinceReferenceDate: TimeInterval(startWtime!)!)
        
        let stopWtime = valueDictionay["stopWtime"] as? String
        self.stopWaste = Date(timeIntervalSinceReferenceDate: TimeInterval(stopWtime!)!)
        
        let pouringV = valueDictionay["pouringV"] as? String
        let pv = (pouringV == "" ? 0 : Int(pouringV!)!)
        self.pouringVolume = pv
        
        let wasteV = valueDictionay["wasteV"] as? String
        let wv = (wasteV == "" ? 0 : Int(wasteV!)!)
        self.wasteVolume = wv
        
        self.density = valueDictionay["density"] as? String
        
        self.liquidWaste = valueDictionay["waste"] as? String
        
        let totalW = valueDictionay["totalW"] as? String
        let tw = (totalW == "" ? 0 : Int(totalW!)!)
        self.totalWaste = tw
        
        self.outletCondition = valueDictionay["outlet"] as? String
        
        self.bloodPressure = valueDictionay["BP"] as? String
        
        let wt = valueDictionay["weight"] as? String
        let wt2 = (wt == "" ? 0 : Double(wt!)!)
        self.weight = wt2

        }
    }
    
    
    

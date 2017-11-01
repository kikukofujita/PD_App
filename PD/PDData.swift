//
//  PDData.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/21.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    // Realm用の変数
    // 管理用ID プライマリーキー
    dynamic var id = 0
    
    //  日付
    dynamic var date = Date()           // ●日付　　time
    dynamic var startPouring = Date()   // ●注液スタート  startPtime
    dynamic var stopPouring = Date()    // ●注液ストップ  stopPtime
    dynamic var startWaste = Date()     // ●廃液スタート  startWtime
    dynamic var stopWaste = Date()      // ●廃液ストップ  stopWtime
    dynamic var pouringVolume = 0     // ●注液量      pouringV
    dynamic var wasteVolume = 0       // ●廃液量      wasteV
    dynamic var difference = 0        // ●徐水量（廃液量 - 注液量）
    dynamic var density = ""        // ●透析液濃度   density
    dynamic var liquidWaste = ""    // ●廃液の状態   waste
    dynamic var totalWaste = 0        // 総排水量（1日） totalW
    dynamic var outletCondition = ""  // ●出口部状態   outlet
    dynamic var bloodPressure = ""   // ●血圧         BP
    dynamic var weight = 0.0          //● 体重         weight
    
    // id = プライマリーキー
    override static func primaryKey() -> String? {
        return "id"
    }

}

class List: Object {
    
    // id
    dynamic var id = 0
    
    // 濃度の選択肢
    dynamic var listDensity = ""
    
    // 容量の選択肢
    dynamic var listVolume = 0
    
    // id = primary key
    override static func primaryKey() -> String? {
        return "id"
    }
}

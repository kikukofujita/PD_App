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
    dynamic var date = Date()
    dynamic var findDate = ""           // ●日付　　time
                // 検索用日付
    dynamic var startPouring = Date()   // ●注液スタート  startPtime
    dynamic var startPText = ""
    
    dynamic var stopPouring = Date()    // ●注液ストップ  stopPtime
    dynamic var stopPText = ""
    
    dynamic var startWaste = Date()     // ●廃液スタート  startWtime
    dynamic var startWText = ""
    
    dynamic var stopWaste = Date()      // ●廃液ストップ  stopWtime
    dynamic var stopWText = ""
    dynamic var pouringVolume = 0     // ●注液量      pouringV
    
    dynamic var pouringTime = ""      // 注液時間
    dynamic var wasteTime = ""        // 排液時間
    dynamic var wasteVolume = 0       // ●廃液量      wasteV
    dynamic var difference = 0        // ●徐水量（廃液量 - 注液量）
    dynamic var density = ""        // ●透析液濃度   density
    dynamic var liquidWaste = ""    // ●廃液の状態   waste
    dynamic var totalWaste = 0        // 総排水量（1日） totalW
    dynamic var outletCondition = ""  // ●出口部状態   outlet
    dynamic var bloodPressure = ""   // ●血圧         BP
    dynamic var weight = 0.0          //● 体重         weight
    
    dynamic var stock = 0             // 在庫
    
    dynamic var stockPlace = ""       //　在庫場所
    
    
    // id = プライマリーキー
    override static func primaryKey() -> String? {
        return "id"
    }

}

class ListD: Object {
    
    // id
    dynamic var id = 0
    
    // 濃度の選択肢
    dynamic var listDensity = ""
    
    // home　入庫総数
    dynamic var homeAllStock = 0
    
    // other 入庫総数
    dynamic var otherAllStock = 0
    
    // home　入庫予定日
    dynamic var homeDate = Date()
    
    // home 履歴
    dynamic var home = ""
    
    // other 履歴
    dynamic var other = ""
    
    // id = primary key
    override static func primaryKey() -> String? {
        return "id"
    }
}

class ListV: Object {
    
    // id
    dynamic var id = 0
    
    // 容量の選択肢
    dynamic var listVolume = 0
    
    // id = primary key
    override static func primaryKey() -> String? {
        return "id"
    }
}

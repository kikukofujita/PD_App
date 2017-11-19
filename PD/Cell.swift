//
//  Cell.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/21.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import Foundation
import UIKit

class First : NSObject {
    var cellDensity: String?
    var cellPVolume: Int?
    var cellPtime: String?
    var cellWtime: String?
    var cellStopP: String?
    var cellStartW: String?
    var cellWVolume: Int?
    var cellWaste: Int?
    var cellComment: String?
    var cellStockPlace: String?
    
    init(cellDensity: String, cellPVolume: Int, cellStopP: String, cellStartW: String, cellPtime: String, cellWtime: String, cellWaste: Int, cellComment: String, cellStockPlace: String) {
        self.cellDensity = cellDensity
        self.cellPVolume = cellPVolume
        self.cellStopP = cellStopP
        self.cellStartW = cellStartW
        self.cellPtime = cellPtime
        self.cellWtime = cellWtime
        self.cellWaste = cellWaste
        self.cellComment = cellComment
        self.cellStockPlace = cellStockPlace
    }
    
}

class second : NSObject {
    var cellListDensity: String?
    var cellStockIn: Int?
    var cellStockAll: Int?
    var cellStockDay: Date?
    var cellStockData: String?
    
    init(cellListDensity: String, cellStockIn: Int, cellStockAll: Int, cellStockDay: Date, cellStockData: String) {
        self.cellListDensity = cellListDensity
        self.cellStockIn = cellStockIn
        self.cellStockAll = cellStockAll
        self.cellStockDay = cellStockDay
        self.cellStockData = cellStockData
    }
    
    
}

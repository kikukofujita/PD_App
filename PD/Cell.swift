//
//  Cell.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/21.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import Foundation

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
    
    init(cellDensity: String, cellPVolume: Int, cellStopP: String, cellStartW: String, cellPtime: String, cellWtime: String, cellWaste: Int, cellComment: String) {
        self.cellDensity = cellDensity
        self.cellPVolume = cellPVolume
        self.cellStopP = cellStopP
        self.cellStartW = cellStartW
        self.cellPtime = cellPtime
        self.cellWtime = cellWtime
        self.cellWaste = cellWaste
        self.cellComment = cellComment
    }
    
}

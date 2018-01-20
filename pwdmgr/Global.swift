//
//  Global.swift
//  pwdmgr
//
//  Created by altair21 on 2017/7/26.
//  Copyright © 2017年 altair21. All rights reserved.
//

import Foundation

struct Keys {
    struct UserDefault {
        static let current = "current"
        static let previous = "previous"
    }
}

struct Identifier {
    struct Push {
        static let everyday = "everyday"
        static let everyWeek = "everyWeek"
    }
    
    struct Region {
        static let home = "home"
    }
}

struct Location {   // 经纬度  Galaxy SOHO
    static let latitude = 39.920344
    static let longitude = 116.432945
}

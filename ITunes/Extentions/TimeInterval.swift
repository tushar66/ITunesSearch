//
//  TimeInterval.swift
//  ITunes
//
//  Created by Tushar Mendiratta on 31/01/21.
//  Copyright © 2021 None. All rights reserved.
//

import Foundation

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    
    var minuteSecond: String {
        return String(format:"%d:%02d", minute, second)
    }
    
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

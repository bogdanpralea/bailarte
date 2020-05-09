//
//  Date+CurrenTimeMillis.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 11/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import Foundation

public extension Date {
    
    /// Returns a date initialized with the time interval passed since 1970 measured in millis
    init(millisSince1970: Int64) {
        self.init(timeIntervalSince1970: TimeInterval(millisSince1970 / 1000))
    }
    
    init?(millisSince1970: Int64?) {
        guard let millisSince1970 = millisSince1970, millisSince1970 > 0 else {
            return nil
        }
        self.init(millisSince1970: millisSince1970)
    }
    
    /// Returns the number of millis that have been passed since 1970
    var currentTimeMillis: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

public extension Int64 {
    func toDate() -> Date? {
        return Date(millisSince1970: self)
    }
}

public extension TimeInterval {
    func toMilliseconds() -> Int {
        return Int(self * 1000)
    }
}

//
//  Date+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/5/22.
//

import Foundation
extension Date {
    func getAstroTime()->Double {
        let adapter = AdapterToEphemeris()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
       let year = formatter.string(from: self)
       formatter.dateFormat = "MM"
       let month = formatter.string(from: self)
       formatter.dateFormat = "dd"
       let day = formatter.string(from: self)
        formatter.dateFormat = "hha"
       let hour = formatter.string(from: self)
        formatter.dateFormat = "mm"
        let minute = formatter.string(from: self)
        if let y = Int32(year), let m = Int32(month), let d = Int32(day), let h = Int32(hour.convertToTwentyFourHours()), let min = Int32(minute) {
            return Double(adapter.getSweJulianDay(y, m, d, Double(h + min / 60)))
        }
        return Double(adapter.getSweJulianDay(1970, 1, 1, 0))
    }
    
    
}

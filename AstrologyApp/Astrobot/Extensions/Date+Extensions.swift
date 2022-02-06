//
//  Date+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/5/22.
//

import Foundation
extension Date {
    func getAstroTime()->Double {
        print("getting astro time)")
        let adapter = AdapterToEphemeris()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
       let year = formatter.string(from: self)
       formatter.dateFormat = "MM"
       let month = formatter.string(from: self)
       formatter.dateFormat = "dd"
       let day = formatter.string(from: self)
       let time: Int32 = 0 // double thetime= (double) (ptm->tm_hour+(double)ptm->tm_min/60);
       print(year, month, day) // 2018 12 24
        if let y = Int32(year), let m = Int32(month), let d = Int32(day) {
            return Double(adapter.getSweJulianDay(y, m, d, time))
        }
        return 0 // planets now
    }
}

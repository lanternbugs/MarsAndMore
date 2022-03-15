/*
*  Copyright (C) 2022 Michael R Adams.
*  All rights reserved.
*
* This program can be redistributed and/or modified under
* the terms of the GNU General Public License; either
* version 2 of the License, or (at your option) any later version.
*
*  This code is distributed in the hope that it will
*  be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/

import Foundation
extension Date {
    func getAstroTime()->Double {
        let adapter = AdapterToEphemeris()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        formatter.locale   = Locale(identifier: "en_US_POSIX")
        formatter.calendar = NSCalendar.current
        formatter.timeZone = TimeZone.current
        let localDate = formatter.string(from: self)
        let year = localToUTC(localDate, newFormat: "yyyy")
        let month = localToUTC(localDate, newFormat: "MM")
        let day = localToUTC(localDate, newFormat: "dd")
        let hour = localToUTC(localDate, newFormat: "HH")
        let minute = localToUTC(localDate, newFormat: "mm")
        if let y = Int32(year), let m = Int32(month), let d = Int32(day), let h = Double(hour), let min = Double(minute) {
            return Double(adapter.getSweJulianDay(y, m, d, Double(h + min / 60)))
        }
        return Double(adapter.getSweJulianDay(1970, 1, 1, 0))
    }
    
    func localToUTC(_ date: String, newFormat: String) -> String {
        let dateFormatter = DateFormatter()
        let format = "MM-dd-yyyy HH:mm"
        dateFormatter.dateFormat = format
        dateFormatter.locale   = Locale(identifier: "en_US_POSIX")
        

        if let dt = dateFormatter.date(from: date) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = newFormat
            let newDateString = dateFormatter.string(from: dt)
            return newDateString
        }
        dateFormatter.dateFormat = newFormat
        return dateFormatter.string(from: self)
      }

    
    
}

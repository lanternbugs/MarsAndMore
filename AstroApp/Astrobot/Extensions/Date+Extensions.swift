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

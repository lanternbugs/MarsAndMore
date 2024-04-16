/*
*  Copyright (C) 2022-2024 Michael R Adams.
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
//  Created by Michael Adams on 4/16/24.
//

import Foundation

class TransitTimesViewModel {
    let transitToShow: TransitsToShow
    
    init(transitToShow: TransitsToShow) {
        self.transitToShow = transitToShow
    }
    
    func shouldShowTransit(_ transit: TransitTime) -> Bool {
        if transitToShow == .All {
            return true
        }
        if transitToShow == .Moon {
            if transit.planet == .Moon {
                return true
            }
        }
        if transitToShow == .Planetary {
            if transit.planet != .Moon && transit.planet2 != .Moon {
                return true
            }
        }
        return false
    }
    func getDisplayTime(transit: TransitTime) -> String {
        var dateComponents = DateComponents()
        let year = transit.time.year
        let month = transit.time.month
        let day = transit.time.day
        let time = transit.time.time
        dateComponents.year = Int(year)
        dateComponents.month = Int(month)
        dateComponents.day = Int(day)
        dateComponents.hour = Int(time)
        let minuteFraction = time - Double(Int(time))
        var minute = Int(60.0 * minuteFraction)
        let decimalMinute = 60.0 * minuteFraction
        if decimalMinute - Double(minute) >= 0.5 {
            minute += 1
        }
        dateComponents.minute = minute
        dateComponents.timeZone = TimeZone(abbreviation: "UTC" )

        // Create date from components
        let userCalendar = Calendar(identifier: .gregorian)
        guard let someDateTime = userCalendar.date(from: dateComponents) else { return "no time" }
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = TimeZone.current
        let hourString = formatter.string(from: someDateTime)
        return hourString
    }
}

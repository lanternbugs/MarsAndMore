/*
*  Copyright (C) 2022-2023 Michael R Adams.
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

extension TransitTime: Comparable {
    static func == (lhs: TransitTime, rhs: TransitTime) -> Bool {
        if lhs.time.year == rhs.time.year &&
            lhs.time.month == rhs.time.month &&
            lhs.time.day == rhs.time.day &&
            lhs.time.time == rhs.time.time {
            return true
        }
        return false
    }
    
    static func < (lhs: TransitTime, rhs: TransitTime) -> Bool {
        if lhs.time.year < rhs.time.year {
            return true
        }
        if lhs.time.year < rhs.time.year {
            return true
        } else if lhs.time.year > rhs.time.year {
            return false
        }
        if lhs.time.month < rhs.time.month {
            return true
        } else if lhs.time.month > rhs.time.month {
            return false
        }
        if lhs.time.day < rhs.time.day {
            return true
        } else if lhs.time.day > rhs.time.day {
            return false
        }
        return lhs.time.time < rhs.time.time
    }
    
}

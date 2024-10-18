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
import SwiftUI
extension String {
    func convertToTwentyFourHours()->String
    {
        if self.contains("PM") {
            let hour = self.replacingOccurrences(of: "PM", with: "")
            if let intHour = Int(hour)
            {
                return String(intHour + 12)
            }
        }
        return self.replacingOccurrences(of: "AM", with: "")
    }
    
    func getLatLongAsDouble()->Double {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let degreeSymobol: Character = "°"
        let minuteSymbol: Character = "'"
        let secondSymbol: Character = "\""
        if let degSymbIndex = trimmed.firstIndex(of: degreeSymobol), let minSymbIndex = trimmed.firstIndex(of: minuteSymbol)  {
            let minStartIndex = trimmed.index(degSymbIndex, offsetBy: 1)
            let range = minStartIndex..<minSymbIndex

            let minuteSubstring = trimmed[range]  // play
            if let degree = Double(trimmed.prefix(upTo: degSymbIndex)), let minute = Double(minuteSubstring.trimmingCharacters(in: .whitespacesAndNewlines))
            {
                if let secSymbIndex = trimmed.firstIndex(of: secondSymbol) {
                    let secStartIndex = trimmed.index(minSymbIndex, offsetBy: 1)
                    let range = secStartIndex..<secSymbIndex
                    let secondSubstring = trimmed[range]
                    if let second = Double(secondSubstring.trimmingCharacters(in: .whitespacesAndNewlines)) {
                        if degree < 0 {
                            return degree - minute / 60.0 - second / 3600.0
                        } else {
                            return degree + minute / 60.0 + second / 3600.0
                        }
                    }
                } else {
                    if degree < 0 {
                        return degree - minute / 60.0
                    } else {
                        return degree + minute / 60.0
                    }
                }
                
            }
        } else {
            if let value = Double(trimmed) {
                return value
            }
        }
        return 0
    }
    
    
}

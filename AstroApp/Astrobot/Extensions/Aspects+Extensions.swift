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
extension Aspects {
    func getName()->String
    {
        switch(self) {
        case .Trine:
            return "Trine"
        case .Conjunction:
            return "Conjunction"
        case .Opposition:
            return "Opposition"
        case .Sextile:
            return "Sextile"
        case .Square:
            return "Square"
        case .Semisextile:
            return "Semisextile"
        case .Semisquare:
            return "Semisquare"
        case .Quintile:
            return "Quintile"
        case .Sesquisquare:
            return "Sesquisquare"
        case .Biquintile:
            return "Biquintile"
        case .Quincunx:
            return "Quincunx"
        }
    }
    
    func isMajor() -> Bool {
        switch self {
        case .Conjunction, .Opposition, .Square, .Trine, .Sextile:
            return true
        default:
           return false
        }
    }
    
    func getIndex()->Int {
        var i = 0
        for val in Aspects.allCases {
            if val == self {
                return i
            }
            i += 1
        }
        return 0
    }
    
    func getAstroCharacter() -> (Character, String) {
        return (getAstroDotCharacter(), "AstroDotBasic")
    }
    
    func getAstroDotCharacter() -> Character {
        switch self {
        case .Conjunction:
            return "m"
        case .Opposition:
            return "n"
        case .Square:
            return "o"
        case .Trine:
            return "p"
        case .Sextile:
            return "q"
        case .Semisextile:
            return "r"
        case .Quincunx:
            return "s"
        case .Semisquare:
            return "t"
        case .Sesquisquare:
            return "u"
        case .Biquintile:
            return "w"
        case .Quintile:
            return "v"
        }
    }
}

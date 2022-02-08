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
extension Signs {
    func getName()->String {
        switch(self) {
        case .Aries:
            return "Aries"
        case .Taurus:
            return "Taurus"
        case .Gemini:
            return "Gemini"
        case .Cancer:
            return "Cancer"
        case .Leo:
            return "Leo"
        case .Virgo:
            return "Virgo"
        case .Libra:
            return "Libra"
        case .Scorpio:
            return "Scorpio"
        case .Sagitarius:
            return "Sagitarius"
        case .Capricorn:
            return "Capricorn"
        case .Aquarius:
            return "Aquarius"
        case .Pisces:
            return "Pisces"
        default:
            return "None"
        }
    }
    
    func getNameShort()->String {
        let name = self.getName()
        if name.count > 3 {
            let index = name.index(name.startIndex, offsetBy: 3)
            return String(name.prefix(upTo: index))
        }
        return name
    }
    
    func getSign(number: Int)->Signs {
        if let sign = Signs(rawValue: number) {
            return sign
        } else {
            return .None
        }
    }
}

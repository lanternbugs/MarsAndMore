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
extension BirthData {
    func getAstroTime()->Double {
        
        if let time = self.birthTime {
            return time.getAstroTime()
        }
        let adapter = AdapterToEphemeris()
        let h = 12
        let min = 0
        
        return Double(adapter.getSweJulianDay(self.birthDate.year, self.birthDate.month, self.birthDate.day, Double(h + min / 60)))
    }
}

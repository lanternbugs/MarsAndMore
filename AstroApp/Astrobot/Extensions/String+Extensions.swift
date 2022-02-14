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
}

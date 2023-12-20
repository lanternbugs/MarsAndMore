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
extension PlanetFetchType {
    func getName()->String {
        switch(self) {
        case .Planets:
            return "Planets"
        case .Aspects(let orbs):
            return "Aspects \(orbs)"
        case .Transits(_, let orbs, _, _, _):
            return "Transits \(orbs)"
        case .Houses(let system, _):
            return system.rawValue + " Houses"
        }
    }
}

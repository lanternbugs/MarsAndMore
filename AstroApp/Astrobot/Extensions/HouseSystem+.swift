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
extension HouseSystem {
    func getHouseCode()->String {
        switch self {
        case .Placidus:
            return "P"
        case .Koch:
            return "K"
        case .Porphyrius:
            return "O"
        case .Regiomontanus:
            return "R"
        case .Campanus:
            return "C"
        case .Equal:
            return "E"
        case .Whole:
            return "W"
        }
    }
}

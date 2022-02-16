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
extension Planets {
    func getName()->String {
        switch(self) {
        case .Sun:
            return "Sun"
        case .Moon:
            return "Moon"
        case .Mercury:
            return "Mercury"
        case .Venus:
            return "Venus"
        case .Mars:
            return "Mars"
        case .Jupiter:
            return "Jupiter"
        case .Saturn:
            return "Saturn"
        case .Uranus:
            return "Uranus"
        case .Neptune:
            return "Nepune"
        case .Pluto:
            return "Pluto"
    
        }
    }
    
    func getNatalOrb()->Double
    {
        switch(self) {
        case .Sun, .Moon:
            return 8.0
        case .Mars, .Venus, .Mercury:
            return 6.0
        default:
            return 5.0
        }
    }
    
    func getTransitOrb()->Double
    {
        return 1.0
    }
}

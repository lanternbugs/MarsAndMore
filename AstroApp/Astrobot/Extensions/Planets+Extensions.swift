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
        case .Ascendent:
            return "Asc"
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
        case .Chiron:
            return "Chiron"
        case .Pholus:
            return "Pholus"
        case .Ceres:
            return "Ceres"
        case .Pallas:
            return "Pallas"
        case .Juno:
            return "Juno"
        case .Vesta:
            return "Vesta"
        }
    }
    
    func getNatalOrb()->Double
    {
        switch(self) {
        case .Sun, .Moon:
            return 8.0
        case .Mars, .Venus, .Mercury, .Ascendent:
            return 6.0
        default:
            return 5.0
        }
    }
    
    func getTransitOrb()->Double
    {
        return 1.0
    }
    
    func getIndex()->Int {
        var i = 0
        for val in Planets.allCases {
            if val == self {
                return i
            }
            i += 1
        }
        return 0
    }
    
    func getAstroIndex()->Int
    {
        switch(self) {
        case .Ascendent:
            return -1
        case .Sun:
            return 0
        case .Moon:
            return 1
        case .Mercury:
            return 2
        case .Venus:
            return 3
        case .Mars:
            return 4
        case .Jupiter:
            return 5
        case .Saturn:
            return 6
        case .Uranus:
            return 7
        case .Neptune:
            return 8
        case .Pluto:
            return 9
        case .Chiron:
            return 15
        case .Pholus:
            return 16
        case .Ceres:
            return 17
        case .Pallas:
            return 18
        case.Juno:
            return 19
        case .Vesta:
            return 20
        }
    }
    
    func getPlanetForAstroIndex(val: Int)->Planets?
    {
        switch(val) {
        case -1:
            return .Ascendent
        case 0:
            return .Sun
        case 1:
            return .Moon
        case 2:
            return .Mercury
        case 3:
            return .Venus
        case 4:
            return .Mars
        case 5:
            return .Jupiter
        case 6:
            return .Saturn
        case 7:
            return .Uranus
        case 8:
            return .Neptune
        case 9:
            return .Pluto
        case 15:
            return .Chiron
        case 16:
            return .Pholus
        case 17:
            return .Ceres
        case 18:
            return .Pallas
        case 19:
            return .Juno
        case 20:
            return .Vesta
        default:
            return nil
        }
    }
}

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
        case .MC:
            return "MC"
        case .Ascendant:
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
        case .TrueNode:
            return "True Node"
        case .SouthNode:
            return "South Node"
        }
    }
    
    func getAstroDotCharacter() -> Character {
        switch self {
        case .Sun:
            return "A"
        case .Moon:
            return "B"
        case .Mercury:
            return "C"
        case .Venus:
            return "D"
        case .Mars:
            return "E"
        case .Jupiter:
            return "F"
        case .Saturn:
            return "G"
        case .Uranus:
            return "H"
        case .Neptune:
            return "I"
        case .Pluto:
            return "J"
        case .Chiron:
            return "U"
        case .Ceres:
            return "V"
        case .Pallas:
            return "W"
        case .Juno:
            return "X"
        case .Vesta:
            return "Y"
        case .TrueNode:
            return "L"
        case .SouthNode:
            return "M"
        case .Ascendant:
            return "P"
        case .MC:
            return "Q"
        default:
            return "Y" // no pholus
        }
    }
    
    static func getPlanetsByOrbitalPeriod() -> [Planets] {
        [.Ascendant, .MC, .Moon, .Sun, .Mercury, .Venus, .Mars, .Vesta, .Juno, .Ceres, .Pallas, .Jupiter, .TrueNode, .SouthNode, .Saturn, .Chiron, .Uranus, .Pholus, .Neptune, .Pluto]
    }
    
    func getNatalOrb(type: OrbType, with aspect: Aspects)->Double
    {
        // no longer using differnt orb for sextile aspect
        switch aspect {
        case .Square, .Trine, .Opposition, .Conjunction, .Sextile:
            switch type {
            case .NarrowOrbs:
                return getNarrowNatalOrbs()
            case .MediumOrbs:
                return getMediumNatalOrbs()
            case .WideOrbs:
                return getWideNatalOrbs()
            }
        default:
            switch type {
            case .NarrowOrbs:
                return 0.75
            case .MediumOrbs:
                return 1.5
            case .WideOrbs:
                return 2.25
            }
        }
    }
    
    func getNarrowNatalOrbs()->Double {
        switch(self) {
        case .Sun, .Moon:
            return 4.0
        case .Mars, .Venus, .Mercury, .Ascendant:
            return 3.0
        default:
            return 2.0
        }
    }
    
    func getMediumNatalOrbs()->Double {
        switch(self) {
        case .Sun, .Moon:
            return 8.0
        case .Mars, .Venus, .Mercury, .Ascendant:
            return 6.0
        default:
            return 5.0
        }
    }
    
    func getWideNatalOrbs()->Double {
        switch(self) {
        case .Sun, .Moon:
            return 10.0
        case .Mars, .Venus, .Mercury, .Ascendant:
            return 8.0
        default:
            return 6.0
        }
    }
    /*
    func getNarrowSextileNatalOrb()->Double {
        switch(self) {
        case .Sun, .Moon:
            return 3.0
        case .Mars, .Venus, .Mercury, .Ascendant:
            return 2.0
        default:
            return 1.0
        }
    }
    
    func getMediumSextileNatalOrb()->Double {
        switch(self) {
        case .Sun, .Moon:
            return 5.0
        case .Mars, .Venus, .Mercury, .Ascendant:
            return 4.0
        default:
            return 3.0
        }
    }
    
    func getWideSextileNatalOrb()->Double {
        switch(self) {
        case .Sun, .Moon:
            return 6.0
        case .Mars, .Venus, .Mercury, .Ascendant:
            return 5.0
        default:
            return 5.0
        }
    }
     */
    
    func getTransitOrb(type: OrbType, with aspect: Aspects) -> Double
    {
        if aspect.isMajor() {
            var moonBonus: Double = 0
            if self == .Moon {
                moonBonus = 1.5
            }
            switch type {
            case .NarrowOrbs:
                return 1.0 + moonBonus
            case .MediumOrbs:
                return 2.0 + moonBonus
            case .WideOrbs:
                return 3.0 + moonBonus
            }
        } else {
            switch type {
            case .NarrowOrbs:
                return 0.5
            case .MediumOrbs:
                return 1.0
            case .WideOrbs:
                return 1.5
            }
        }
        
    }
    
    func getSynastryOrb(type: OrbType, with aspect: Aspects) -> Double
    {
        if aspect.isMajor() {
            
            switch type {
            case .NarrowOrbs:
                return 3.0
            case .MediumOrbs:
                return 6.0
            case .WideOrbs:
                return 10.0
            }
        } else {
            switch type {
            case .NarrowOrbs:
                return 0.5
            case .MediumOrbs:
                return 1.0
            case .WideOrbs:
                return 1.5
            }
        }
        
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
        case .MC:
            return -2
        case .Ascendant:
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
        case .SouthNode:
            return 10
        case .TrueNode:
            return 11
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
    
    static func getPlanetForAstroIndex(val: Int32)->Planets?
    {
        switch(val) {
        case -2:
            return .MC
        case -1:
            return .Ascendant
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
        case 10:
            return .SouthNode
        case 11:
            return .TrueNode
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

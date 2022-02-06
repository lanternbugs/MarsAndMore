//
//  Planets+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/5/22.
//

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
}

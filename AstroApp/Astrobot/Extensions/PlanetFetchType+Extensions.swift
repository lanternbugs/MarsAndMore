//
//  PlanetFetchType+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 3/2/22.
//

import Foundation
extension PlanetFetchType {
    func getName()->String {
        switch(self) {
        case .Planets:
            return "Planets"
        case .Aspects:
            return "Aspects"
        case .Transits:
            return "Transits"
        }
    }
}

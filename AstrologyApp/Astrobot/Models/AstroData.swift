//
//  AstroPlanet.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

import Foundation
import IOSurface
enum Planets: Int, CaseIterable {
    case Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto
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
enum Signs: Int {
    case Aries, Taurus, Gemini, Cancer, Leo, Virgo, Libra, Scorpio, Sagitarius, Capricorn,
    Aquarius, Pisces, None
}

enum PlanetFetchType {
    case planets, aspects, transits
}

struct PlanetCell: AstroRowCell {
    let type: PlanetFetchType
    let planet: Planets
    let sign: Signs
    let degree: String
    
    
}
struct PlanetRow {
    var planets = Array<AstroRowCell>()
}

struct DisplayPlanetRow {
    let planets: [AstroRowCell]
    let id: Int
    
}


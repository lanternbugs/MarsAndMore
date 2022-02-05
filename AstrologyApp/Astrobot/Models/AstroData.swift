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
    
    func getName()->String {
        switch(self) {
        case .Aries:
            return "Aries"
        case .Taurus:
            return "Taurus"
        case .Gemini:
            return "Gemini"
        case .Cancer:
            return "Cancer"
        case .Leo:
            return "Leo"
        case .Virgo:
            return "Virgo"
        case .Libra:
            return "Libra"
        case .Scorpio:
            return "Scorpio"
        case .Sagitarius:
            return "Sagitarius"
        case .Capricorn:
            return "Capricorn"
        case .Aquarius:
            return "Aquarius"
        case .Pisces:
            return "Pisces"
        default:
            return "None"
        }
    }
    
    func getNameShort()->String {
        let name = self.getName()
        if name.count > 3 {
            let index = name.index(name.startIndex, offsetBy: 3)
            return String(name.prefix(upTo: index))
        }
        return name
    }
    
    func getSign(number: Int)->Signs {
        if let sign = Signs(rawValue: number) {
            return sign
        } else {
            return .None
        }
    }
}
enum PlanetFetchType {
    case planets, aspects, transits
}

protocol AstroRowCell {
    var type: PlanetFetchType {
        get
    }
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


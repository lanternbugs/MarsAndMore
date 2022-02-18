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
import IOSurface
enum Planets: Int, CaseIterable {
    case Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto
}
enum Signs: Int {
    case Aries, Taurus, Gemini, Cancer, Leo, Virgo, Libra, Scorpio, Sagitarius, Capricorn,
    Aquarius, Pisces, None
}

enum Aspects: Double, CaseIterable {
    case Trine = 120, Conjunction = 0, Sextile = 60, Square = 90, Opposition = 180
}

enum PlanetFetchType {
    case Planets, Aspects, Transits
}

struct TransitingPlanet {
    let planet: Planets
    let degree: Double
}

struct PlanetCell: AstroRowCell {
    let type: PlanetFetchType
    let planet: Planets
    let sign: Signs
    let degree: String
    let retrograde: Bool
    
    
}

struct TransitCell: AstroRowCell {
    let type: PlanetFetchType
    let planet: Planets
    let planet2: Planets
    let degree: String
    let aspect: Aspects
}

struct PlanetRow {
    var planets = Array<AstroRowCell>()
}

struct DisplayPlanetRow {
    var planets: [AstroRowCell]
    let id: Int
    
}


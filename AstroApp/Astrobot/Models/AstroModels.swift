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
    case Ascendent = -1, MC = -2, Sun = 0, Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto, Chiron, Pholus, Ceres, Pallas, Juno, Vesta, TrueNode, SouthNode
}
enum Signs: Int, CaseIterable {
    case Aries, Taurus, Gemini, Cancer, Leo, Virgo, Libra, Scorpio, Sagitarius, Capricorn,
    Aquarius, Pisces, None
}

enum Houses: Int, CaseIterable {
    case H1 = 1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12
}

enum HouseSystem: String, CaseIterable {
    case Placidus, Koch, Porphyrius, Regiomontanus, Campanus, Equal, Whole
}

enum SiderealSystem: Int, CaseIterable {
    case Lahiri = 1, FaganBradley = 0, Raman = 3
}

enum Aspects: Double, CaseIterable {
    case Trine = 120, Conjunction = 0, Sextile = 60, Square = 90, Opposition = 180,
    Semisextile = 30, Semiquintile = 36, Semisquare = 45, Quintile = 72, Sesquisquare = 135,
         Biquintile = 144, Quincunx = 150
}

enum Movement: String {
    case Applying, Stationary, Seperating, None
}

enum PlanetFetchType {
    case Planets(chartModel: ChartViewModel), Aspects(orbs: String), Transits(date: String, orbs: String, transitData: TransitTimeData, chartName: String, chartModel: ChartViewModel), Houses(system: HouseSystem, chartModel: ChartViewModel)
}

struct TransitingPlanet {
    let planet: Planets
    let degree: Double
    let laterDegree: Double
}

struct HouseCell: AstroRowCell {
    let degree: String
    let sign: Signs
    let house: Houses
    let numericDegree: Double
}

struct PlanetCell: AstroRowCell {
    let planet: Planets
    let degree: String
    let sign: Signs
    let retrograde: Bool
    let numericDegree: Double
    
    
}

struct TransitCell: AstroRowCell {
    let planet: Planets
    let planet2: Planets
    let degree: String
    let aspect: Aspects
    let movement: Movement
}

struct TransitTime {
    let planet: Planets
    let planet2: Planets
    let aspect: Aspects
    let time: TransitTimeObject
    let start_time: Double
    let end_time: Double
    let sign: Signs?
}

enum TransitsToShow {
    case Moon, Planetary, All
}

struct TransitTimeData {
    var calculationSettings: CalculationSettings = CalculationSettings()
    var time: Double = 0
    var transitTime: Date = Date()
    var location: LocationData?
}

struct CalculationSettings {
    var tropical: Bool = true
    var siderealSystem: SiderealSystem = .Lahiri
    var houseSystem: String = "P"
}

struct PlanetRow {
    var planets = Array<AstroRowCell>()
}

struct DisplayPlanetRow {
    var planets: [AstroRowCell]
    let id: Int
    let type: PlanetFetchType
    let name: String
    let calculationSettings: CalculationSettings
    
}

enum OrbType: String, CaseIterable { case NarrowOrbs = "Narrow Orbs", MediumOrbs = "Medium Orbs", WideOrbs = "Wide Orbs" }


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
    case Ascendant = -3, MC = -2, Vertex = -1, Sun = 0, Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto, Chiron, Pholus, Ceres, Pallas, Juno, Vesta, Eris, TrueNode, SouthNode, Lilith
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
    Semisextile = 30, Semisquare = 45, Quintile = 72, Sesquisquare = 135,
         Biquintile = 144, Quincunx = 150
}

enum Movement: String {
    case Applying, Stationary, Seperating, None
}

enum PlanetFetchType {
    case Planets(viewModel: ChartViewModel), Aspects(orbs: String), Transits(date: String, orbs: String, transitData: TransitTimeData, chartName: String, viewModel: ChartViewModel), Houses(system: HouseSystem, viewModel: ChartViewModel)
}

struct TransitingPlanet {
    let planet: Planets
    let degree: Double
    let laterDegree: Double
}
enum HouseCellType:String {
    case House, MC, ASC = "Asc"
}
struct HouseCell: AstroRowCell, Hashable {
    let degree: String
    let sign: Signs
    let house: Houses
    let numericDegree: Double
    let type: HouseCellType
    let id = UUID()
}

struct PlanetCell: AstroRowCell {
    let planet: Planets
    let degree: String
    let sign: Signs
    let retrograde: Bool
    let numericDegree: Double
    let id = UUID()
}

struct TransitCell: AstroRowCell {
    let planet: Planets
    let planet2: Planets
    let degree: String
    let aspect: Aspects
    let movement: Movement
    let id = UUID()
}

struct TransitTime {
    let planet: Planets
    let planet2: Planets
    let aspect: Aspects
    let time: TransitTimeObject
    let start_time: Double
    let end_time: Double
    let sign: Signs?
    let house: Houses?
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

struct PlanetRow: Identifiable {
    var planets = Array<AstroRowCell>()
    let id = UUID()
}

struct DisplayPlanetRow {
    var planets: [AstroRowCell]
    let id: Int
    let type: PlanetFetchType
    let name: String
    let calculationSettings: CalculationSettings
    
}

enum OrbType: String, CaseIterable { case NarrowOrbs = "Narrow Orbs", MediumOrbs = "Medium Orbs", WideOrbs = "Wide Orbs" }

let nakshatras = ["Ashwini", "Bharani", "Krittika", "Rohini", "Mrigashira", "Ardra", "Punarvasu", "Pushya", "Ashlesha", "Magha", "Purva Phalguni", "Uttara Phalguni", "Hasta", "Chitra", "Swati", "Vishakha", "Anuradha", "Jyeshtha", "Moola", "Purva Ashadha", "Uttara Ashadha", "Shravana", "Dhanishta", "Shatabhisha", "Purva Bhadrapada", "Uttara Bhadrapada", "Revati"]

enum StepTimes: String, CaseIterable { case oneMinute = "1 Minute", tenMinutes = "10 Minutes", oneHour = "1 Hour", oneDay = "1 Day", oneWeek = "1 Week", oneMonth = "1 Month", sixMonths = "6 Months", oneYear = "1 Year"
    
    func getShortName() -> String {
        switch(self) {
        case .oneMinute:
            return "Min"
        case .tenMinutes:
            return "10 Min"
        case .oneHour:
            return "Hour"
        case .oneDay:
            return "Day"
        case .oneWeek:
            return "Week"
        case .oneMonth:
            return "Month"
        case .sixMonths:
            return "6 Month"
        case .oneYear:
            return "Year"
        }
    }
}


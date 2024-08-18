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
extension AstrobotBaseInterface {
    func getPlanets(time: Double, location: LocationData?, calculationSettings: CalculationSettings)->PlanetRow
    {
        var row = PlanetRow()
        let adapter = AdapterToEphemeris()
        let interval: Double = 0.025
        for type in Planets.allCases
        {
            if type == .Ascendant {
                guard let location = location else {
                    continue
                }
                row.planets.append(calculateASC(time: time, location: location, calculationSettings: calculationSettings))

            } else if type == .MC {
                guard let location = location else {
                    continue
                }
                row.planets.append(calculateMC(time: time, location: location, calculationSettings: calculationSettings))

            } else {
                let lookupType = type != .SouthNode ? type : .TrueNode
                var val = adapter.getPlanetDegree(time, Int32(lookupType.getAstroIndex()), calculationSettings.tropical, Int32(calculationSettings.siderealSystem.rawValue))
                var pastVal = adapter.getPlanetDegree(time - interval, Int32(lookupType.getAstroIndex()), calculationSettings.tropical, Int32(calculationSettings.siderealSystem.rawValue))
                if type == .SouthNode && val >= 180 {
                    val -= 180
                } else if type == .SouthNode {
                    val = 360 - (180 - val)
                }
                if type == .SouthNode && pastVal >= 180 {
                    pastVal -= 180
                } else if type == .SouthNode {
                    pastVal = 360 - (180 - pastVal)
                }
                let retro = checkRetrograde(val: val, past: pastVal)
                row.planets.append(getPlanetData(type, degree: Double(val), retrograde: retro))
            }
        }
        return row
    }
    
    func getPlanetData(_ type: Planets, degree: Double, retrograde: Bool) ->PlanetCell
    {
        
        return  PlanetCell(planet: type, degree: degree.getAstroDegree(), sign: degree.getAstroSign(), retrograde: retrograde, numericDegree: degree)
    }
    
    func checkRetrograde(val: Double, past: Double)->Bool
    {
        let duration  = val - past
        if Int(past) == 0 && Int(val) == 359 {
            return true // this much it wrapped, aries to pisces
        }
        else if duration < 0 {
            if Int(past) == 359 && Int(val) == 0 {
                return false
            }
            return true
        }
        return false
    }
    
    func calculateASC(time: Double, location: LocationData, calculationSettings: CalculationSettings)->PlanetCell
    {
        let degree = getAscendantDegree(time: time, from: location, calculationSettings: calculationSettings)
        return  PlanetCell(planet: .Ascendant, degree: degree.getAstroDegree(), sign: degree.getAstroSign(), retrograde: false, numericDegree: degree)
    }
    
    func getAscendantDegree(time: Double, from location: LocationData, calculationSettings: CalculationSettings)->Double {
        let adapter = AdapterToEphemeris()
        return adapter.getAscendant(time, location.latitude.getLatLongAsDouble(),  location.longitude.getLatLongAsDouble(), calculationSettings.houseSystem.utf8CString[0], calculationSettings.tropical, Int32(calculationSettings.siderealSystem.rawValue))
    }
    
    func calculateMC(time: Double, location: LocationData, calculationSettings: CalculationSettings)->PlanetCell
    {
        let degree = getMCDegree(time: time, from: location, calculationSettings: calculationSettings)
        return  PlanetCell(planet: .MC, degree: degree.getAstroDegree(), sign: degree.getAstroSign(), retrograde: false, numericDegree: degree)
    }
    
    func getMCDegree(time: Double, from location: LocationData, calculationSettings: CalculationSettings)->Double {
        let adapter = AdapterToEphemeris()
        return adapter.getMC(time, location.latitude.getLatLongAsDouble(),  location.longitude.getLatLongAsDouble(), calculationSettings.houseSystem.utf8CString[0], calculationSettings.tropical, Int32(calculationSettings.siderealSystem.rawValue))
    }
}

extension AstrobotInterface {
    
    func getAspects(time: Double, with time2: Double?, and location: LocationData?, location2: LocationData? = nil, type: OrbType = OrbType.MediumOrbs, calculationSettings: CalculationSettings)->PlanetRow
    {
        let fetchType: PlanetFetchType = time2 == nil ? .Aspects(orbs: type.getShortName()) : .Transits(date: "none", orbs: "none", transitData: TransitTimeData(), chartName: "none", chartModel: ChartViewModel(chartName: "none", chartType: .Transit, manager: BirthDataManager()))
        var transitPlanets: [TransitingPlanet]?
        let natalPlanets = getTransitingPlanets(for: time, and: location, calculationSettings: CalculationSettings( houseSystem: calculationSettings.houseSystem))
        if let time2 = time2 {
            transitPlanets = getTransitingPlanets(for: time2, and: location2, calculationSettings: CalculationSettings(houseSystem: calculationSettings.houseSystem))
        } else {
            transitPlanets = natalPlanets
        }
        guard let transitPlanets = transitPlanets else {
            return PlanetRow()
        }

        let planetRow: [[TransitCell]?] = transitPlanets.map {
            guard let startPlanet = Planets(rawValue: $0.planet.rawValue + 1) else {
                return []
            }
            var transits = [TransitCell]()
            for planet2 in natalPlanets {
                if planet2.planet.rawValue < startPlanet.rawValue && time2 == nil {
                    continue
                }
                else if let aspect = getAspect(planet1: $0, planet2: planet2, with: time2, location2: location2, withOrbType: type) {
                    let movement: Movement = $0.degree.getApplying(with: $0.laterDegree, otherDegree: planet2.degree, for: aspect, type: fetchType)
                    transits.append(TransitCell(planet: $0.planet, planet2: planet2.planet, degree: $0.degree.getTransitDegree(with: planet2.degree, for: aspect), aspect: aspect, movement: movement))
                }
            }
            
            return transits
        }

        var transitsRow =  PlanetRow()
        for val in planetRow {
            if let val = val {
                for val2 in val {
                    transitsRow.planets.append(val2)
                }
            }
        }
        
        return transitsRow
    }
    
    func getTransitingPlanets(for time: Double, and location: LocationData?, type withOrbType: OrbType = OrbType.MediumOrbs, calculationSettings: CalculationSettings)->[TransitingPlanet] {
        let adapter = AdapterToEphemeris()
        var transitPlanets = [TransitingPlanet]()
        for type in Planets.allCases
        {
            if type == .Ascendant {
                guard let location = location else {
                    continue
                }
                let degree = getAscendantDegree(time: time, from: location, calculationSettings: calculationSettings)
                transitPlanets.append(TransitingPlanet(planet: type, degree: degree, laterDegree: degree))

            }
            else if type == .MC {
                guard let location = location else {
                    continue
                }
                let degree = getMCDegree(time: time, from: location, calculationSettings: calculationSettings)
                transitPlanets.append(TransitingPlanet(planet: type, degree: degree, laterDegree: degree))

            }
            
            else {
                let interval: Double = 0.05
                let lookupType = type != .SouthNode ? type : .TrueNode
                var val = adapter.getPlanetDegree(time, Int32(lookupType.getAstroIndex()), calculationSettings.tropical, Int32(calculationSettings.siderealSystem.rawValue))
                var val2 = adapter.getPlanetDegree(time + interval, Int32(lookupType.getAstroIndex()), calculationSettings.tropical, Int32(calculationSettings.siderealSystem.rawValue))
                
                if type == .SouthNode && val >= 180 {
                    val -= 180
                } else if type == .SouthNode {
                    val = 360 - (180 - val)
                }
                if type == .SouthNode && val2 >= 180 {
                    val2 -= 180
                } else if type == .SouthNode {
                    val2 = 360 - (180 - val2)
                }
                transitPlanets.append(TransitingPlanet(planet: type, degree: Double(val), laterDegree: Double(val2)))
            }
            
        }
        return transitPlanets
    }
    
    func getAspect(planet1: TransitingPlanet, planet2: TransitingPlanet, with time2: Double?, location2: LocationData?, withOrbType type: OrbType = OrbType.MediumOrbs)->Aspects? {
        
        var degree = abs(planet1.degree - planet2.degree)
        if degree > 180 {
            degree = 360 - degree
        }
        for aspect in Aspects.allCases {
            var orb =  planet1.planet.getNatalOrb(type: type, with: aspect)
            if time2 != nil {
                if location2 != nil {
                    orb = planet1.planet.getSynastryOrb(type: type, with: aspect)
                } else {
                    orb = planet1.planet.getTransitOrb(type: type, with: aspect)
                }
                
            }
            if abs(degree - aspect.rawValue) <  orb {
                return aspect
            }
        }
        return nil
    }
    
    func getHouses(time: Double, location: LocationData, system: String, calculationSettings: CalculationSettings)->PlanetRow
    {
        let adapter = AdapterToEphemeris()
        var row = PlanetRow()
        let ascDegree = getAscendantDegree(time: time, from: location, calculationSettings: calculationSettings)
        let mcDegree = getMCDegree(time: time, from: location, calculationSettings: calculationSettings)
        for house in Houses.allCases {
            let val =  adapter.getHouse(time, location.latitude.getLatLongAsDouble(),  location.longitude.getLatLongAsDouble(), Int32(house.rawValue),
                                        system.utf8CString[0], calculationSettings.tropical, Int32(calculationSettings.siderealSystem.rawValue))
            row.planets.append(HouseCell(degree: val.getAstroDegree(),sign: val.getAstroSign(),  house: house, numericDegree: val, type: .House))
        }
        
        if let houses = row.planets as? [HouseCell] {
            if houses[0].numericDegree != ascDegree {
                row.planets.append(HouseCell(degree: ascDegree.getAstroDegree(),sign: ascDegree.getAstroSign(),  house: .H1, numericDegree: ascDegree, type: .ASC))
            }
            if houses[9].numericDegree != mcDegree {
                row.planets.append(HouseCell(degree: mcDegree.getAstroDegree(),sign: mcDegree.getAstroSign(),  house: .H10, numericDegree: mcDegree, type: .MC))
            }
        }
            
            
        
        return row
    }
    
    func getTransitTimes(start_time: Double, end_time: Double, manager: BirthDataManager) -> [TransitTime] {
        let moonTransits =  TransitFinder().getMoonTransitsOfDay(start_time: start_time, end_time: end_time, manager: manager)
        let planetTransits = TransitFinder().getPlanetaryTransitsOfDay(start_time: start_time, end_time: end_time, manager: manager)
        return moonTransits + planetTransits
        
    }
    
    func getNatalTransitTimes(start_time: Double, end_time: Double, manager: BirthDataManager, transitTimeData: TransitTimeData) -> [TransitTime] {
            TransitFinder().getNatalTransitsOfDay(start_time: start_time, end_time: end_time, manager: manager, transitTimeData: transitTimeData)
    }
}

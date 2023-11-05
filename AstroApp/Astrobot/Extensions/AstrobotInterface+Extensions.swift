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
    func getPlanets(time: Double, location: LocationData?, tropical: Bool)->PlanetRow
    {
        var row = PlanetRow()
        let adapter = AdapterToEphemeris()
        let interval: Double = 0.1
        for type in Planets.allCases
        {
            if type == .Ascendent {
                guard let location = location else {
                    continue
                }
                row.planets.append(calculateASC(time: time, location: location, tropical: tropical))

            } else {
                let val = adapter.getPlanetDegree(time, Int32(type.getAstroIndex()), tropical)
                let pastVal = adapter.getPlanetDegree(time - interval, Int32(type.rawValue), tropical)
                let retro = checkRetrograde(val: val, past: pastVal)
                row.planets.append(getPlanetData(type, degree: Double(val), retrograde: retro))
            }
        }
        return row
    }
    
    func getPlanetData(_ type: Planets, degree: Double, retrograde: Bool) ->PlanetCell
    {
        
        return  PlanetCell(planet: type, degree: degree.getAstroDegree(), sign: degree.getAstroSign(), retrograde: retrograde)
    }
    
    func checkRetrograde(val: Double, past: Double)->Bool
    {
        let duration  = val - past
        if duration > 180 {
            return true // this much it wrapped, aries to pisces
        }
        else if duration < 0 {
            return true
        }
        return false
    }
    
    func calculateASC(time: Double, location: LocationData, tropical: Bool)->PlanetCell
    {
        let degree = getAscendentDegree(time: time, from: location, tropical: tropical)
        return  PlanetCell(planet: .Ascendent, degree: degree.getAstroDegree(), sign: degree.getAstroSign(), retrograde: false)
    }
    
    func getAscendentDegree(time: Double, from location: LocationData, tropical: Bool)->Double {
        let adapter = AdapterToEphemeris()
        return adapter.getAscendent(time, location.latitude.getLatLongAsDouble(),  location.longitude.getLatLongAsDouble(), tropical)
    }
}

extension AstrobotInterface {
    
    func getAspects(time: Double, with time2: Double?, and location: LocationData?, type: OrbType = OrbType.MediumOrbs, tropical: Bool)->PlanetRow
    {
        let fetchType: PlanetFetchType = time2 == nil ? .Aspects(orbs: type.getShortName()) : .Transits(date: "none")
        var transitPlanets: [TransitingPlanet]?
        let natalPlanets = getTransitingPlanets(for: time, and: location, tropical: tropical)
        if let time2 = time2 {
            transitPlanets = getTransitingPlanets(for: time2, and: nil, tropical: tropical)
        } else {
            transitPlanets = natalPlanets
        }
        guard let transitPlanets = transitPlanets else {
            return PlanetRow()
        }

        let planetRow: [[TransitCell]?] = transitPlanets.map {
            guard let startPlanet = Planets(rawValue: $0.planet.rawValue + 1) else {
                return nil
            }
            var transits = [TransitCell]()
            for planet2 in natalPlanets {
                if planet2.planet.rawValue < startPlanet.rawValue && time2 == nil {
                    continue
                }
                else if let aspect = getAspect(planet1: $0, planet2: planet2, with: time2, withOrbType: type) {
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
    
    func getTransitingPlanets(for time: Double, and location: LocationData?, type withOrbType: OrbType = OrbType.MediumOrbs, tropical: Bool)->[TransitingPlanet] {
        let adapter = AdapterToEphemeris()
        var transitPlanets = [TransitingPlanet]()
        for type in Planets.allCases
        {
            if type == .Ascendent {
                guard let location = location else {
                    continue
                }
                let degree = getAscendentDegree(time: time, from: location, tropical: tropical)
                transitPlanets.append(TransitingPlanet(planet: type, degree: degree, laterDegree: degree))

            } else {
                let interval: Double = 0.05
                let val = adapter.getPlanetDegree(time, Int32(type.getAstroIndex()), tropical)
                let val2 = adapter.getPlanetDegree(time + interval, Int32(type.getAstroIndex()), tropical)
                transitPlanets.append(TransitingPlanet(planet: type, degree: Double(val), laterDegree: val2))
            }
            
        }
        return transitPlanets
    }
    
    func getAspect(planet1: TransitingPlanet, planet2: TransitingPlanet, with time2: Double?, withOrbType type: OrbType = OrbType.MediumOrbs)->Aspects? {
        
        var degree = abs(planet1.degree - planet2.degree)
        if degree > 180 {
            degree = 360 - degree
        }
        for aspect in Aspects.allCases {
            let orb = time2 == nil ? planet1.planet.getNatalOrb(type: type, with: aspect) : planet1.planet.getTransitOrb()
            if abs(degree - aspect.rawValue) <  orb {
                return aspect
            }
        }
        return nil
    }
    
    func getHouses(time: Double, location: LocationData, system: String, tropical: Bool)->PlanetRow
    {
        let adapter = AdapterToEphemeris()
        var row = PlanetRow()
        for house in Houses.allCases {
            let val =  adapter.getHouse(time, location.latitude.getLatLongAsDouble(),  location.longitude.getLatLongAsDouble(), Int32(house.rawValue),
                                        system.utf8CString[0], tropical)
            row.planets.append(HouseCell(degree: val.getAstroDegree(),sign: val.getAstroSign(),  house: house))
        }
        
        return row
    }
}

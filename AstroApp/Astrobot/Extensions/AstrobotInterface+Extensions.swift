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
    func getPlanets(time: Double, location: LocationData?)->PlanetRow
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
                row.planets.append(calculateASC(time: time, location: location))

            } else {
                let val = adapter.getPlanetDegree(time, Int32(type.getAstroIndex()))
                let pastVal = adapter.getPlanetDegree(time - interval, Int32(type.rawValue))
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
    
    func calculateASC(time: Double, location: LocationData)->PlanetCell
    {
        let degree = getAscendentDegree(time: time, from: location)
        return  PlanetCell(planet: .Ascendent, degree: degree.getAstroDegree(), sign: degree.getAstroSign(), retrograde: false)
    }
    
    func getAscendentDegree(time: Double, from location: LocationData)->Double {
        let adapter = AdapterToEphemeris()
        return adapter.getAscendent(time, location.latitude.getLatLongAsDouble(),  location.longitude.getLatLongAsDouble())
    }
}

extension AstrobotInterface {
    
    func getAspects(time: Double, with time2: Double?, and location: LocationData?)->PlanetRow
    {
        let fetchType: PlanetFetchType = time2 == nil ? .Aspects : .Transits(date: "none")
        var transitPlanets: [TransitingPlanet]?
        let natalPlanets = getTransitingPlanets(for: time, and: location)
        if let time2 = time2 {
            transitPlanets = getTransitingPlanets(for: time2, and: nil)
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
                else if let aspect = getAspect(planet1: $0, planet2: planet2, with: time2) {
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
    
    func getTransitingPlanets(for time: Double, and location: LocationData?)->[TransitingPlanet] {
        let adapter = AdapterToEphemeris()
        var transitPlanets = [TransitingPlanet]()
        for type in Planets.allCases
        {
            if type == .Ascendent {
                guard let location = location else {
                    continue
                }
                let degree = getAscendentDegree(time: time, from: location)
                transitPlanets.append(TransitingPlanet(planet: type, degree: degree, laterDegree: degree))

            } else {
                let interval: Double = 0.05
                let val = adapter.getPlanetDegree(time, Int32(type.getAstroIndex()))
                let val2 = adapter.getPlanetDegree(time + interval, Int32(type.getAstroIndex()))
                transitPlanets.append(TransitingPlanet(planet: type, degree: Double(val), laterDegree: val2))
            }
            
        }
        return transitPlanets
    }
    
    func getAspect(planet1: TransitingPlanet, planet2: TransitingPlanet, with time2: Double?)->Aspects? {
        
        var degree = abs(planet1.degree - planet2.degree)
        if degree > 180 {
            degree = 360 - degree
        }
        for aspect in Aspects.allCases {
            let orb = time2 == nil ? planet1.planet.getNatalOrb() : planet1.planet.getTransitOrb()
            if abs(degree - aspect.rawValue) <  orb {
                return aspect
            }
        }
        return nil
    }
}

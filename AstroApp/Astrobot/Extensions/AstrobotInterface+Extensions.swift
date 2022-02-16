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
    func getPlanets(time: Double)->PlanetRow
    {
        var row = PlanetRow()
        let adapter = AdapterToEphemeris()
        for type in Planets.allCases
        {
            let val = adapter.getPlanetDegree(time, Int32(type.rawValue))
            row.planets.append(getPlanetData(type, degree: Double(val)))
        }
        return row
    }
    
    func getPlanetData(_ type: Planets, degree: Double) ->PlanetCell
    {
        
        return  PlanetCell(type: PlanetFetchType.Planets, planet: type, sign: degree.getAstroSign(), degree: degree.getAstroDegree())
    }
}

extension AstrobotInterface {
    
    func getAspects(time: Double, type: PlanetFetchType)->PlanetRow
    {
        let adapter = AdapterToEphemeris()
        var transitPlanets = [TransitingPlanet]()
        for type in Planets.allCases
        {
            let val = adapter.getPlanetDegree(time, Int32(type.rawValue))
            transitPlanets.append(TransitingPlanet(planet: type, degree: Double(val)))
        }
        let planetRow: [[TransitCell]?] = transitPlanets.map {
            guard let startPlanet = Planets(rawValue: $0.planet.rawValue + 1) else {
                return nil
            }
            var transits = [TransitCell]()
            for planet2 in transitPlanets {
                if planet2.planet.rawValue < startPlanet.rawValue {
                    continue
                }
                else if let aspect = getAspect(planet1: $0, planet2: planet2, type: type) {
                    transits.append(TransitCell(type: type, planet: $0.planet, planet2: planet2.planet, degree: $0.degree.getTransitDegree(with: planet2.degree, for: aspect), aspect: aspect))
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
    
    func getAspect(planet1: TransitingPlanet, planet2: TransitingPlanet, type: PlanetFetchType)->Aspects? {
        
        var degree = abs(planet1.degree - planet2.degree)
        if degree > 180 {
            degree = 360 - degree
        }
        for aspect in Aspects.allCases {
            let orb = type == .Aspects ? planet1.planet.getNatalOrb() : planet1.planet.getTransitOrb()
            if abs(degree - aspect.rawValue) <  orb {
                return aspect
            }
        }
        return nil
    }
}

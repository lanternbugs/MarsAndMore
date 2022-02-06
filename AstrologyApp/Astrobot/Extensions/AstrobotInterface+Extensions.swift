//
//  AstrobotInterface+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

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
        
        return  PlanetCell(type: PlanetFetchType.planets, planet: type, sign: degree.getAstroSign(), degree: degree.getAstroDegree())
    }
}

extension AstrobotInterface {
    func getTransits()->PlanetRow
    {
        return PlanetRow()
    }
    func getAspects()->PlanetRow
    {
        return PlanetRow()
    }
}

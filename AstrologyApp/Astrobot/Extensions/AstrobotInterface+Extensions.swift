//
//  AstrobotInterface+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

import Foundation
extension AstrobotInterface {
    func getPlanets()->PlanetRow
    {
        var row = PlanetRow()
        let adapter = AdapterToEphemeris()
        for type in Planets.allCases
        {
            let val = adapter.getPlanetDegree(Int32(type.rawValue))
            row.planets.append(getPlanetData(type, degree: Double(val)))
        }
        return row
    }
    
    func getTransits()->PlanetRow
    {
        return PlanetRow()
    }
    func getAspects()->PlanetRow
    {
        return PlanetRow()
    }
    
    func getPlanetData(_ type: Planets, degree: Double) ->PlanetCell
    {
        
        return  PlanetCell(type: PlanetFetchType.planets, planet: type, sign: degree.getAstroSign(), degree: degree.getAstroDegree())
    }
    
    
    
}

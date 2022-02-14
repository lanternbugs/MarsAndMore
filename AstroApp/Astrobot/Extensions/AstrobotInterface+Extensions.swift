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

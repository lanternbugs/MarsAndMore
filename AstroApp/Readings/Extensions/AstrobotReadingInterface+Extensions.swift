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

extension AstrobotReadingInterface {
    func getPlanet(type: Planets, time: Double, calculationSettings: CalculationSettings)->RoomState
    {
        let data = getPlanets(time: time, location: nil, calculationSettings: calculationSettings)
        if let planets  =  data.planets as? [PlanetCell]
        {
            let planet = planets.filter {
                switch($0.planet) {
                case type:
                    return true
                default:
                    return false;
                }
            }
            if planet.count == 0 {
                return RoomState.Entry
            }
            return RoomState.Reading(planet: planet[0].planet, sign: planet[0].sign)
        }
        
        return RoomState.Entry
    }
}

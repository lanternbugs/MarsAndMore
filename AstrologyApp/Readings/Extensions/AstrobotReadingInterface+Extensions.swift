//
//  AstrobotReadingInterface+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/5/22.
//

import Foundation

extension AstrobotReadingInterface {
    func getPlanet(type: Planets, time: Double)->RoomState
    {
        let data = getPlanets(time: time)
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

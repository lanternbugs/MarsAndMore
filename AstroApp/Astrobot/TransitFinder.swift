//
//  TransitFinder.swift
//  MarsAndMore
//
//  Created by Michael Adams on 11/19/23.
//

import Foundation
struct TransitFinder {
    let tolerance = 0.01
    let timeTolerance = 0.001
    func getMoonTransitsOfDay(start_time: Double, end_time: Double) -> [TransitTime] {
        print("\(start_time) and end time \(end_time)")
        let adapter = AdapterToEphemeris()
        var transitTimes = [TransitTime]()
        for planet in Planets.allCases {
            if planet == .Moon || planet == .MC || planet == .Ascendent {
                continue
            }
            for aspect in Aspects.allCases {
                if aspect.isMajor() {
                    let time = findAspect(.Moon, with: planet, aspect: aspect, low: start_time, high: end_time)
                    if time > 0 {
                        let transitTime = TransitTime(planet: .Moon, planet2: planet, aspect: aspect, time: adapter.convertSweDate(time), start_time: start_time, end_time: end_time)
                        transitTimes.append(transitTime)
                    }
                }
            }
        }
        return transitTimes
    }
    
    func getPlanetaryTransitsOfDay(start_time: Double, end_time: Double) -> [TransitTime] {
        print("\(start_time) and end time \(end_time)")
        let lastPlanet = Planets.Chiron.rawValue
        let adapter = AdapterToEphemeris()
        var transitTimes = [TransitTime]()
        for planet in Planets.allCases {
            if planet == .Moon || planet == .MC || planet == .Ascendent || planet.rawValue > lastPlanet {
                continue
            }
            for transitingPlanet  in Planets.allCases {
                if transitingPlanet == .Moon || transitingPlanet == .MC || transitingPlanet == .Ascendent || transitingPlanet.rawValue > lastPlanet {
                    continue
                }
                if transitingPlanet.rawValue <= planet.rawValue {
                    continue;
                }
                for aspect in Aspects.allCases {
                    if aspect.isMajor() {
                        let time = findAspect(planet, with: transitingPlanet, aspect: aspect, low: start_time, high: end_time)
                        if time > 0 {
                            let transitTime = TransitTime(planet: planet, planet2: transitingPlanet, aspect: aspect, time: adapter.convertSweDate(time), start_time: start_time, end_time: end_time)
                            transitTimes.append(transitTime)
                        }
                    }
                }
            }
            
        }
        return transitTimes
    }
    
    func findAspect(_ planet1: Planets, with planet2: Planets, aspect: Aspects, low: Double, high: Double) -> Double {
        let adapter = AdapterToEphemeris()
        let mid = (low + high) / 2
        if high - low < timeTolerance {
            return -1
        }
        
        let planetDegree = adapter.getPlanetDegree(mid, Int32(planet1.getAstroIndex()), true, 0)
        let planet2Degree = adapter.getPlanetDegree(mid, Int32(planet2.getAstroIndex()), true, 0)
        let orb = planetDegree - planet2Degree
        if abs(aspect.rawValue - abs(orb)) < tolerance {
            return mid
        } else if aspect.rawValue - orb < 0 {
            return findAspect(planet1, with: planet2, aspect: aspect, low: low, high: mid)
        } else {
            return findAspect(planet1, with: planet2, aspect: aspect, low: mid, high: high)
        }
        return -1
    }
}

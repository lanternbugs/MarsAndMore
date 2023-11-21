//
//  TransitFinder.swift
//  MarsAndMore
//
//  Created by Michael Adams on 11/19/23.
//

import Foundation
struct TransitFinder {
    let tolerance = 0.0001
    let timeDifferential: Double = 1.0/1000000.0
    
    func getMoonTransitsOfDay(start_time: Double, end_time: Double, manager: BirthDataManager) -> [TransitTime] {
        let adapter = AdapterToEphemeris()
        var transitTimes = [TransitTime]()
        for planet in Planets.allCases {
            if planet == .Moon || planet == .MC || planet == .Ascendent || !manager.bodiesToShow.contains(planet) {
                continue
            }
            for aspect in Aspects.allCases {
                if aspect.isMajor() || manager.showMinorAspects {
                    if canMakeAspect(.Moon, with: planet, aspect: aspect, low: start_time, high: end_time) {
                        let time = findAspect(.Moon, with: planet, aspect: aspect, low: start_time, high: end_time)
                        if time > 0 {
                            if let transitTimeObject = adapter.convertSweDate(time) {
                                let transitTime = TransitTime(planet: Planets.Moon, planet2: planet, aspect: aspect, time: transitTimeObject, start_time: start_time, end_time: end_time)
                                transitTimes.append(transitTime)
                            }
                        }
                    }
                }
            }
        }
        return transitTimes
    }
    
    func getPlanetaryTransitsOfDay(start_time: Double, end_time: Double, manager: BirthDataManager) -> [TransitTime] {
        let adapter = AdapterToEphemeris()
        var transitTimes = [TransitTime]()
        for planet in Planets.allCases {
            if planet == .Moon || planet == .MC || planet == .Ascendent || !manager.bodiesToShow.contains(planet) {
                continue
            }
            for transitingPlanet  in Planets.allCases {
                if transitingPlanet == .Moon || transitingPlanet == .MC || transitingPlanet == .Ascendent || !manager.bodiesToShow.contains(transitingPlanet) {
                    continue
                }
                if transitingPlanet.rawValue <= planet.rawValue {
                    continue;
                }
                for aspect in Aspects.allCases {
                    if aspect.isMajor() || manager.showMinorAspects {
                        if canMakeAspect(planet, with: transitingPlanet, aspect: aspect, low: start_time, high: end_time) {
                            let time = findAspect(planet, with: transitingPlanet, aspect: aspect, low: start_time, high: end_time)
                            if time > 0 {
                                let transitTime = TransitTime(planet: planet, planet2: transitingPlanet, aspect: aspect, time: adapter.convertSweDate(time), start_time: start_time, end_time: end_time)
                                transitTimes.append(transitTime)
                            }
                        }
                    }
                }
            }
            
        }
        return transitTimes
    }
    func canMakeAspect(_ planet1: Planets, with planet2: Planets, aspect: Aspects, low: Double, high: Double) -> Bool {
        ///TODO:  make this work consitently with a planet that changes motion on that day
        let adapter = AdapterToEphemeris()
        let planetDegree = adapter.getPlanetDegree(low, Int32(planet1.getAstroIndex()), true, 0)
        let planet2Degree = adapter.getPlanetDegree(low, Int32(planet2.getAstroIndex()), true, 0)
        var beginDistance = abs(planetDegree - planet2Degree)
        if beginDistance > 180 && aspect != .Opposition {
            beginDistance = 360 - beginDistance
        }
        let endPlanetDegree = adapter.getPlanetDegree(high, Int32(planet1.getAstroIndex()), true, 0)
        let endPlanet2Degree = adapter.getPlanetDegree(high, Int32(planet2.getAstroIndex()), true, 0)
        var endDistance = abs(endPlanetDegree - endPlanet2Degree)
        if endDistance > 180 && aspect != .Opposition {
            endDistance = 360 - endDistance
        }
        if aspect.rawValue == 0 {
            if planetDegree < planet2Degree && endPlanetDegree > endPlanet2Degree {
                return true
            }
            if planetDegree > planet2Degree && endPlanetDegree < endPlanet2Degree {
                return true
            }
            return false
        }
        if aspect.rawValue > beginDistance && aspect.rawValue < endDistance {
            return true
        }
        if aspect.rawValue > endDistance && aspect.rawValue < beginDistance {
            return true
        }
        return false
    }
    func findAspect(_ planet1: Planets, with planet2: Planets, aspect: Aspects, low: Double, high: Double) -> Double {
        let adapter = AdapterToEphemeris()
        if (low + timeDifferential) > high {
            return -1
        }
        let mid: Double = (low + high) / 2.0
       
        let planetDegree = adapter.getPlanetDegree(mid, Int32(planet1.getAstroIndex()), true, 0)
        let planetLaterDegree = adapter.getPlanetDegree(mid + 0.025, Int32(planet1.getAstroIndex()), true, 0)
        let direct = planetLaterDegree > planetDegree ? true : false
        let planet2Degree = adapter.getPlanetDegree(mid, Int32(planet2.getAstroIndex()), true, 0)
        var orb = planetDegree - planet2Degree
        if orb < 0 {
            orb = -orb
        }
        if orb > 180 { //15 sag 255 16 aries 16 orb is 239. should be 121  360 - 239 = 121
            orb = 360 - orb
        }
        var diff = orb - Double(aspect.rawValue)
        if diff < 0 {
            diff = -diff
        }
        
        if  diff  < tolerance {
            return mid
        }
        var aspectIsFoward = false
        if orb > aspect.rawValue && planetDegree < planet2Degree {
            aspectIsFoward = true
        }
        if  abs(planetDegree - planet2Degree) < 180 && planetDegree > planet2Degree && aspect == .Opposition {
            aspectIsFoward = true
        } else if  abs(planetDegree - planet2Degree) > 180 && planetDegree < planet2Degree && aspect == .Opposition {
            aspectIsFoward = true
        }
        else if orb > aspect.rawValue && planetDegree > planet2Degree && (planetDegree + aspect.rawValue) > 360 && (planetDegree - planet2Degree) > 180 && aspect != .Opposition {
            aspectIsFoward = true
        } else if orb < aspect.rawValue && planetDegree > planet2Degree && ((planetDegree + aspect.rawValue) <= 360 || (planetDegree - planet2Degree) <= 180) && aspect != .Opposition {
            aspectIsFoward = true
        }
        if !direct {
            aspectIsFoward = !aspectIsFoward
        }
        
        if aspectIsFoward {
            return findAspect(planet1, with: planet2, aspect: aspect, low: mid, high: high)
        }
        else  {
            return findAspect(planet1, with: planet2, aspect: aspect, low: low, high: mid)
        }
        
    }
}

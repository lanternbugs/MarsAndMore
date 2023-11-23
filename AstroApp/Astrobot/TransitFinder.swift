/*
*  Copyright (C) 2022-2023 Michael R Adams.
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
            if planetDegree > planet2Degree && endPlanetDegree > endPlanet2Degree && endPlanetDegree < planetDegree {
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
        var aspectIsFoward  = isAspectFoward(planetDegree, planet2Degree, aspect)
        
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
    
    
    
    func getNatalTransitsOfDay(start_time: Double, end_time: Double, manager: BirthDataManager, transitTimeData: TransitTimeData) -> [TransitTime] {
        let adapter = AdapterToEphemeris()
        var transitTimes = [TransitTime]()
        let natalDictionary = getNatalDictionary(transitTimeData)
        for planet in Planets.allCases {
            if planet == .MC || planet == .Ascendent || !manager.bodiesToShow.contains(planet) {
                continue
            }
            for natalPlanet  in Planets.allCases {
                if !manager.bodiesToShow.contains(natalPlanet) {
                    continue
                }
                
                guard let natalDegree = natalDictionary[natalPlanet] else {
                    continue
                }
                for aspect in Aspects.allCases {
                    if aspect.isMajor() || manager.showMinorAspects {
                        if canMakeNatalAspect(planet, with: natalDegree, aspect: aspect, low: start_time, high: end_time) {
                            let time = findNatalAspect(planet, with: natalDegree, aspect: aspect, low: start_time, high: end_time)
                            if time > 0 {
                                let transitTime = TransitTime(planet: planet, planet2: natalPlanet, aspect: aspect, time: adapter.convertSweDate(time), start_time: start_time, end_time: end_time)
                                transitTimes.append(transitTime)
                            }
                        }
                    }
                }
            }
            
        }
        return transitTimes
    }
    
    func getNatalDictionary(_ transitTimeData: TransitTimeData) -> [Planets: Double] {
        let adapter = AdapterToEphemeris()
        var natalDictionary = [Planets: Double]()
        for planet in Planets.allCases {
            if planet != .MC && planet != .Ascendent {
                natalDictionary[planet] = adapter.getPlanetDegree(transitTimeData.time, Int32(planet.getAstroIndex()), true, 0)
            } else {
                guard let location =  transitTimeData.location else {
                        continue
                }
                if planet == .Ascendent {
                    natalDictionary[planet] = adapter.getAscendent(transitTimeData.time, location.latitude.getLatLongAsDouble(), location.longitude.getLatLongAsDouble(), transitTimeData.calculationSettings.houseSystem.utf8CString[0], true, 0)
                } else if planet == .MC {
                    natalDictionary[planet] = adapter.getMC(transitTimeData.time, location.latitude.getLatLongAsDouble(), location.longitude.getLatLongAsDouble(), transitTimeData.calculationSettings.houseSystem.utf8CString[0], true, 0)
                }
            }
        }
        return natalDictionary
    }
    
    func canMakeNatalAspect(_ planet1: Planets, with natalDegree: Double, aspect: Aspects, low: Double, high: Double) -> Bool {
        let adapter = AdapterToEphemeris()
        let planetDegree = adapter.getPlanetDegree(low, Int32(planet1.getAstroIndex()), true, 0)
        let planet2Degree = natalDegree
        var beginDistance = abs(planetDegree - planet2Degree)
        if beginDistance > 180 && aspect != .Opposition {
            beginDistance = 360 - beginDistance
        }
        let endPlanetDegree = adapter.getPlanetDegree(high, Int32(planet1.getAstroIndex()), true, 0)
        let endPlanet2Degree = natalDegree
        var endDistance = abs(endPlanetDegree - endPlanet2Degree)
        if endDistance > 180 && aspect != .Opposition {
            endDistance = 360 - endDistance
        }
        if aspect.rawValue == 0 {
            if (planetDegree < planet2Degree) && (endPlanetDegree > endPlanet2Degree) {
                return true
            }
            if planetDegree > planet2Degree && endPlanetDegree > endPlanet2Degree && endPlanetDegree < planetDegree {
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
    func findNatalAspect(_ planet1: Planets, with natalDegree: Double, aspect: Aspects, low: Double, high: Double) -> Double {
        let adapter = AdapterToEphemeris()
        if (low + timeDifferential) > high {
            return -1
        }
        let mid: Double = (low + high) / 2.0
       
        let planetDegree = adapter.getPlanetDegree(mid, Int32(planet1.getAstroIndex()), true, 0)
        var direct = true
        if planet1 != .Sun && planet1 != .Moon {
            let planetLaterDegree = adapter.getPlanetDegree(mid + 0.025, Int32(planet1.getAstroIndex()), true, 0)
            direct = planetLaterDegree > planetDegree ? true : false
        }
        
        let planet2Degree = natalDegree
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
        var aspectIsFoward = isAspectFoward(planetDegree, planet2Degree, aspect)
        
        if !direct {
            aspectIsFoward = !aspectIsFoward
        }
        
        if aspectIsFoward {
            return findNatalAspect(planet1, with: natalDegree, aspect: aspect, low: mid, high: high)
        }
        else  {
            return findNatalAspect(planet1, with: natalDegree, aspect: aspect, low: low, high: mid)
        }
        
    }
    
    func isAspectFoward(_ planetDegree: Double, _ planet2Degree: Double, _ aspect: Aspects) -> Bool {
        if aspect == .Conjunction {
            if (planetDegree < planet2Degree) && ((planet2Degree - planetDegree) < 180) {
                return true
            } else if (planetDegree > planet2Degree) && ((360 - planetDegree + planet2Degree) <= 180) {
                return true
            }
        } else if aspect == .Opposition {
            if planetDegree < 180 {
                if (planetDegree + aspect.rawValue) < planet2Degree {
                    return true
                } 
            } else if (planetDegree - planet2Degree) < aspect.rawValue {
                return true
            }
        } else {
            if planetDegree < planet2Degree {
                if (planetDegree + aspect.rawValue) < planet2Degree && (planet2Degree - planetDegree) < 180  {
                    return true
                }
                if (360 - planet2Degree + planetDegree) < aspect.rawValue && (360 - planet2Degree + planetDegree) < 180  {
                    return true
                }
            } else { // failes for moon in pisces sextile  my taurus moon
                if ((planetDegree - planet2Degree) < aspect.rawValue) && ((planetDegree - planet2Degree) <= 180) {
                    return true
                }
                if ((360 - (planetDegree - planet2Degree)) > aspect.rawValue) && ((planetDegree - planet2Degree) > 180) {
                    return true
                }
            }
        }
        
        return false
    }
}

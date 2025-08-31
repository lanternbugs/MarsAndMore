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
    static var adapterCalls = 0
    
    func shouldShowAspect(_ aspect: Aspects, manager: BirthDataManager) -> Bool {
        if aspect.isMajor() {
            return true
        }
        if !manager.showMinorAspects || !manager.showMinorAspectTransitTimes {
            return false
        }
        if manager.aspectsToShow.contains(aspect) {
            return true
        }
        
        return false
    }
    
    func getMoonTransitsOfDay(start_time: Double, end_time: Double, manager: BirthDataManager) -> [TransitTime] {
        let adapter = AdapterToEphemeris()
        var transitTimes = [TransitTime]()
        // Moon Sign Change
        var planetDegree: (Double, Double) = (0, 0)
        planetDegree.0 = adapter.getPlanetDegree(start_time, Int32(Planets.Moon.getAstroIndex()), true, 0)
        planetDegree.1 = adapter.getPlanetDegree(end_time, Int32(Planets.Moon.getAstroIndex()), true, 0)
        let moonSignChangeDegree = getSignChangeDegree(.Moon, low: start_time)
        if canMakeNatalAspect(planetDegree, with: moonSignChangeDegree, aspect: .Conjunction, low: start_time, high: end_time) {
            let time = findNatalAspect(.Moon, with: moonSignChangeDegree, aspect: .Conjunction, low: start_time, high: end_time)
            if time > 0 {
                let transitTime = TransitTime(planet: .Moon, planet2: .Moon, aspect: .Conjunction, time: adapter.convertSweDate(time), start_time: start_time, end_time: end_time, sign: moonSignChangeDegree.getAstroSign(), house: nil)
                transitTimes.append(transitTime)
            }
            
        }
        // Transits
        for planet in Planets.allCases {
            if planet == .Moon || planet == .MC || planet == .Ascendant || planet == .Vertex || !manager.bodiesToShow.contains(planet) {
                continue
            }
            var planetDegree: (Double, Double) = (0,0)
            var planet2Degree: (Double, Double) = (0,0)
            planetDegree.0  = adapter.getPlanetDegree(start_time, Int32(planet.getAstroIndex()), true, 0)
            planet2Degree.0 = adapter.getPlanetDegree(start_time, Int32(Planets.Moon.getAstroIndex()), true, 0)
            
            planetDegree.1 = adapter.getPlanetDegree(end_time, Int32(planet.getAstroIndex()), true, 0)
            planet2Degree.1 = adapter.getPlanetDegree(end_time, Int32(Planets.Moon.getAstroIndex()), true, 0)
            for aspect in Aspects.allCases {
                if shouldShowAspect(aspect, manager: manager) {
                    if canMakeAspect(planet2Degree, with: planetDegree, aspect: aspect, low: start_time, high: end_time) {
                        let time = findAspect(.Moon, with: planet, aspect: aspect, low: start_time, high: end_time)
                        if time > 0 {
                            if let transitTimeObject = adapter.convertSweDate(time) {
                                let transitTime = TransitTime(planet: Planets.Moon, planet2: planet, aspect: aspect, time: transitTimeObject, start_time: start_time, end_time: end_time, sign: nil, house: nil)
                                transitTimes.append(transitTime)
                            }
                        } else {
                            //print("missed aspect with \(planet.getName()) and \(aspect.getName()) and \(Planets.Moon.getName())")
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
        
        // sign changes
        for planet in Planets.allCases {
            if planet == .Moon || planet == .MC || planet == .Ascendant || planet == .Vertex || !manager.bodiesToShow.contains(planet) {
                continue
            }
            var planetDegree: (Double, Double) = (0, 0)
            planetDegree.0 = adapter.getPlanetDegree(start_time, Int32(planet.getAstroIndex()), true, 0)
            planetDegree.1 = adapter.getPlanetDegree(end_time, Int32(planet.getAstroIndex()), true, 0)
            TransitFinder.adapterCalls += 2
            let signChangeDegree = getSignChangeDegree(planet, low: start_time)
            if canMakeNatalAspect(planetDegree, with: signChangeDegree, aspect: .Conjunction, low: start_time, high: end_time) {
                let time = findNatalAspect(planet, with: signChangeDegree, aspect: .Conjunction, low: start_time, high: end_time)
                if time > 0 {
                    let transitTime = TransitTime(planet: planet, planet2: planet, aspect: .Conjunction, time: adapter.convertSweDate(time), start_time: start_time, end_time: end_time, sign: getNewSign(start: planetDegree.0, end: planetDegree.1, changeDegree: signChangeDegree), house: nil)
                    transitTimes.append(transitTime)
                }
                
            }
        }
        // transits
     for planet in Planets.getPlanetsByOrbitalPeriod() {
         if planet == .Moon || planet == .MC || planet == .Ascendant || planet == .Vertex || !manager.bodiesToShow.contains(planet) {
             continue
         }
         for transitingPlanet  in Planets.getPlanetsByOrbitalPeriod() {
             if transitingPlanet == .Moon || transitingPlanet == .MC || transitingPlanet == .Ascendant || transitingPlanet == .Vertex || !manager.bodiesToShow.contains(transitingPlanet) {
                    continue
                }
                if transitingPlanet.getOrbitalSpot() <= planet.getOrbitalSpot() {
                    continue;
                }
                var planetDegree: (Double, Double) = (0,0)
                var planet2Degree: (Double, Double) = (0,0)
                planetDegree.0  = adapter.getPlanetDegree(start_time, Int32(planet.getAstroIndex()), true, 0)
                planet2Degree.0 = adapter.getPlanetDegree(start_time, Int32(transitingPlanet.getAstroIndex()), true, 0)
                
                planetDegree.1 = adapter.getPlanetDegree(end_time, Int32(planet.getAstroIndex()), true, 0)
                planet2Degree.1 = adapter.getPlanetDegree(end_time, Int32(transitingPlanet.getAstroIndex()), true, 0)
                TransitFinder.adapterCalls += 2
                for aspect in Aspects.allCases {
                    if shouldShowAspect(aspect, manager: manager) {
                        if canMakeAspect(planetDegree, with: planet2Degree, aspect: aspect, low: start_time, high: end_time) {
                            
                            let time = findAspect(planet, with: transitingPlanet, aspect: aspect, low: start_time, high: end_time)
                            if time > 0 {
                                let transitTime = TransitTime(planet: planet, planet2: transitingPlanet, aspect: aspect, time: adapter.convertSweDate(time), start_time: start_time, end_time: end_time, sign: nil, house: nil)
                                transitTimes.append(transitTime)
                            } else {
                                // a second check if the normally faster planet is now moving slower
                                let time = findAspect(transitingPlanet, with: planet, aspect: aspect, low: start_time, high: end_time)
                                if time > 0 {
                                    let transitTime = TransitTime(planet: planet, planet2: transitingPlanet, aspect: aspect, time: adapter.convertSweDate(time), start_time: start_time, end_time: end_time, sign: nil, house: nil)
                                    transitTimes.append(transitTime)
                                } else {
                                    //print("missed aspect with \(planet.getName()) and \(aspect.getName()) and \(transitingPlanet.getName())")
                                }
                            }
                        } else if canMakeAspect(planet2Degree, with: planetDegree, aspect: aspect, low: start_time, high: end_time)  {
                            let time = findAspect(transitingPlanet, with: planet, aspect: aspect, low: start_time, high: end_time)
                            if time > 0 {
                                let transitTime = TransitTime(planet: planet, planet2: transitingPlanet, aspect: aspect, time: adapter.convertSweDate(time), start_time: start_time, end_time: end_time, sign: nil, house: nil)
                                transitTimes.append(transitTime)
                            }
                        }
                    }
                }
            }
            
        }
     //print(TransitFinder.adapterCalls)
     TransitFinder.adapterCalls = 0
        return transitTimes
    }
    
    func getNewSign(start: Double, end: Double, changeDegree: Double) -> Signs {
     
        if end > start || end < 5.0 {
            return end.getAstroSign()
        }
        if changeDegree.getAstroSign() == .Aries {
            return .Pisces
        }
        return (changeDegree - 30.0).getAstroSign()
    }
    
    func canMakeConjunction(_ planetDegree: Double, endPlanetDegree: Double, planet2Degree: Double, endPlanet2Degree: Double) -> Bool {
        if planetDegree > 180 && planet2Degree < 180 {
            if endPlanetDegree > endPlanet2Degree && endPlanetDegree < 180 {
                return true
            }
        } else {
            if planetDegree > 180 && planet2Degree > 180 && endPlanetDegree < 180 && endPlanet2Degree > 180 {
                return true
            }
            if planetDegree < planet2Degree && endPlanetDegree > endPlanet2Degree {
                return true
            }
            if planetDegree > endPlanetDegree && endPlanetDegree > 2.0 {
                if planetDegree > planet2Degree && endPlanetDegree < endPlanet2Degree {
                    return true
                }
            }
        }
        return false
    }
    func canMakeAspect(_ planet1: (Double, Double), with planet2: (Double, Double), aspect: Aspects, low: Double, high: Double) -> Bool {
        ///TODO:  make this work consitently with a planet that changes motion on that day
        let planetDegree = planet1.0  // adapter.getPlanetDegree(low, Int32(planet1.getAstroIndex()), true, 0)
        let planet2Degree = planet2.0
        var beginDistance = abs(planetDegree - planet2Degree)
        if beginDistance > 180 && aspect != .Opposition {
            beginDistance = 360 - beginDistance
        }
        let endPlanetDegree = planet1.1 //adapter.getPlanetDegree(high, Int32(planet1.getAstroIndex()), true, 0)
        let endPlanet2Degree = planet2.1
        var endDistance = abs(endPlanetDegree - endPlanet2Degree)
        if endDistance > 180 && aspect != .Opposition {
            endDistance = 360 - endDistance
        }
        
        if (planetDegree.getAstroSign() == .Pisces && endPlanetDegree.getAstroSign() == .Aries) ||
            (planetDegree.getAstroSign() == .Aries && endPlanetDegree.getAstroSign() == .Pisces)  {
            if aspect == .Opposition {
                if aspect.rawValue < (360 - endDistance) && aspect.rawValue > beginDistance {
                    return true
                }
            }
        }
        
        if aspect == .Conjunction {
            return canMakeConjunction(planetDegree, endPlanetDegree: endPlanetDegree, planet2Degree: planet2Degree, endPlanet2Degree: endPlanet2Degree)
            
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
        var direct = true
        if planet1 != .Sun && planet1 != .Moon {
            direct = planetLaterDegree > planetDegree ? true : false
            if Int(planetLaterDegree) == 359 && Int(planetDegree) == 0 {
                direct = false
            }
            if planetDegree > 359.5 && Int(planetLaterDegree) == 0 {
              direct = true
            }
        }
        
        let planet2Degree = adapter.getPlanetDegree(mid, Int32(planet2.getAstroIndex()), true, 0)
        var orb = planetDegree - planet2Degree
        TransitFinder.adapterCalls += 3
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
        let houseArray = getHouseArray(transitTimeData)
        for planet in Planets.getPlanetsByOrbitalPeriod() {
            if planet == .MC || planet == .Ascendant || planet == .Vertex || !manager.bodiesToShow.contains(planet) {
                continue
            }
            
            var planetDegree: (Double, Double) = (0, 0)
            planetDegree.0 = adapter.getPlanetDegree(start_time, Int32(planet.getAstroIndex()), true, 0)
            planetDegree.1 = adapter.getPlanetDegree(end_time, Int32(planet.getAstroIndex()), true, 0)
            TransitFinder.adapterCalls += 2
            // uncomment out to work on transits to houses code
            if transitTimeData.location != nil {
                let houseChangeDegree = getHouseChangeDegree(planet, low: start_time, houseArray: houseArray)
                if canMakeNatalAspect(planetDegree, with: houseChangeDegree.0, aspect: .Conjunction, low: start_time, high: end_time) {
                    let time = findNatalAspect(planet, with: houseChangeDegree.0, aspect: .Conjunction, low: start_time, high: end_time)
                    if time > 0 {
                        let transitTime = TransitTime(planet: planet, planet2: planet, aspect: .Conjunction, time: adapter.convertSweDate(time), start_time: start_time, end_time: end_time, sign: nil, house: getHouseNumber(houseChangeDegree, houseArray))
                        transitTimes.append(transitTime)
                    }
                }
            }
            
            for natalPlanet  in Planets.allCases {
                if !manager.bodiesToShow.contains(natalPlanet) {
                    continue
                }
                
                guard let natalDegree = natalDictionary[natalPlanet] else {
                    continue
                }
                
                
                
                
                for aspect in Aspects.allCases {
                    if shouldShowAspect(aspect, manager: manager) {
                        if canMakeNatalAspect(planetDegree, with: natalDegree, aspect: aspect, low: start_time, high: end_time) {
                            let time = findNatalAspect(planet, with: natalDegree, aspect: aspect, low: start_time, high: end_time)
                            if time > 0 {
                                let transitTime = TransitTime(planet: planet, planet2: natalPlanet, aspect: aspect, time: adapter.convertSweDate(time), start_time: start_time, end_time: end_time, sign: nil, house: nil)
                                transitTimes.append(transitTime)
                            } else {
                               // print("missed aspect with \(planet.getName()) and \(aspect.getName()) and \(natalPlanet.getName())")
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
            if planet != .MC && planet != .Ascendant && planet != .Vertex {
                natalDictionary[planet] = adapter.getPlanetDegree(transitTimeData.time, Int32(planet.getAstroIndex()), true, 0)
                TransitFinder.adapterCalls += 1
            } else {
                guard let location =  transitTimeData.location else {
                        continue
                }
                if planet == .Ascendant {
                    natalDictionary[planet] = adapter.getAscendant(transitTimeData.time, location.latitude.getLatLongAsDouble(), location.longitude.getLatLongAsDouble(), transitTimeData.calculationSettings.houseSystem.utf8CString[0], true, 0)
                } else if planet == .MC {
                    natalDictionary[planet] = adapter.getMC(transitTimeData.time, location.latitude.getLatLongAsDouble(), location.longitude.getLatLongAsDouble(), transitTimeData.calculationSettings.houseSystem.utf8CString[0], true, 0)
                } else if planet == .Vertex {
                    natalDictionary[planet] = adapter.getVertex(transitTimeData.time, location.latitude.getLatLongAsDouble(), location.longitude.getLatLongAsDouble(), transitTimeData.calculationSettings.houseSystem.utf8CString[0], true, 0)
                }
            }
        }
        return natalDictionary
    }
    
    func getHouseNumber(_  houseData: (Double, Bool), _ houseArray: [(HouseCell, Double)]) -> Houses {
        let house = Houses(rawValue: 1)!
        for val in houseArray {
            if val.0.numericDegree == houseData.0 {
                if !houseData.1 {
                    return val.0.house
                } else {
                    var num = val.0.house.rawValue
                    num -= 1
                    if num < 1 {
                        num = 12
                    }
                    if num > 0 && num < 13 {
                        return Houses(rawValue: num)!
                    }  
                }
                
            }
        }
        return house
    }
    
    func getHouseArray(_ transitTimeData: TransitTimeData) -> [(HouseCell, Double)] {
        let adapter = AdapterToEphemeris()
        var houseArray = [(HouseCell, Double)]()
        if transitTimeData.location == nil {
            return houseArray
        }
        
        for house in Houses.allCases {
            let val =  adapter.getHouse(transitTimeData.time, transitTimeData.location?.latitude.getLatLongAsDouble() ?? 0,  transitTimeData.location?.longitude.getLatLongAsDouble() ?? 0, Int32(house.rawValue),
                                        transitTimeData.calculationSettings.houseSystem.utf8CString[0], transitTimeData.calculationSettings.tropical, Int32(transitTimeData.calculationSettings.siderealSystem.rawValue))
            houseArray.append((HouseCell(degree: val.getAstroDegree(),sign: val.getAstroSign(),  house: house, numericDegree: val, type: .House),  val))
        }
        return houseArray
    }
    
    
    func getHouse(_ degree: Double, houseArray: [(HouseCell, Double)], retro: Bool) -> Double {
        for i in 0...11 {
            let lowerDegree = houseArray[i].0.numericDegree
            var upperDegree = 0.0
            if i == 11 // top is H0
            {
                upperDegree = houseArray[0].0.numericDegree
            
            } else {
                upperDegree = houseArray[i + 1].0.numericDegree
            }
            if degree > lowerDegree && degree < upperDegree {
                if retro {
                    return lowerDegree
                } else {
                    return upperDegree
                }
            } else if degree > lowerDegree && upperDegree < lowerDegree {
                if retro {
                    return lowerDegree
                } else {
                    return upperDegree
                }
            } else if degree < lowerDegree && degree < upperDegree && upperDegree < lowerDegree {
                if retro {
                    return lowerDegree
                } else {
                    return upperDegree
                }
            }
        }
        
        return 0.0
    }
    
    
    func getHouseChangeDegree(_ planet: Planets, low: Double, houseArray: [(HouseCell, Double)]) -> (Double, Bool) {
        let adapter = AdapterToEphemeris()
        let planetDegree = adapter.getPlanetDegree(low, Int32(planet.getAstroIndex()), true, 0)
        let planetDegree2 = adapter.getPlanetDegree(low + 0.1, Int32(planet.getAstroIndex()), true, 0)
        var retro = planetDegree2 < planetDegree ? true : false
        if planetDegree < 5.0 && planetDegree2 > 355.0 {
            retro = true
        }
        if planetDegree2 < 5.0 && planetDegree > 355.0 {
            retro = false
        }
        if planet == .Sun || planet == .Moon {
            retro = false
        }
        let changeDegree = getHouse(planetDegree, houseArray: houseArray, retro: retro)
        
        return (changeDegree, retro)
    }
    
    func getSignChangeDegree(_ planet: Planets, low: Double) -> Double {
        let adapter = AdapterToEphemeris()
        let planetDegree = adapter.getPlanetDegree(low, Int32(planet.getAstroIndex()), true, 0)
        let intDegree = Int(planetDegree)
        var changeDegree = planetDegree + (30.0 - Double(intDegree % 30) -  (planetDegree - Double(intDegree)))
        let planetDegree2 = adapter.getPlanetDegree(low + 0.1, Int32(planet.getAstroIndex()), true, 0)
        if planet != .Sun && planet != .Moon {
            if planetDegree2 < planetDegree && !(Int(planetDegree2) == 0 && Int(planetDegree) == 359) {
                changeDegree = Double(Int(planetDegree) - Int(planetDegree) % 30)
                if Int(planetDegree2) == 0 && Int(planetDegree) == 0 {
                    changeDegree = 0
                }
            }
            if Int(planetDegree2) == 359 && Int(planetDegree) == 0 {
                changeDegree = 0
            }
        }
        
        if changeDegree == 360 {
            return 0
        } else {
            return changeDegree
        }
    }
    
    func canMakeNatalAspect(_ planet1: (Double, Double), with natalDegree: Double, aspect: Aspects, low: Double, high: Double) -> Bool {
        let planetDegree = planet1.0
        let planet2Degree = natalDegree
        var beginDistance = abs(planetDegree - planet2Degree)
        if beginDistance > 180 && aspect != .Opposition {
            beginDistance = 360 - beginDistance
        }
            
        let endPlanetDegree = planet1.1
        let endPlanet2Degree = natalDegree
        var endDistance = abs(endPlanetDegree - endPlanet2Degree)
        if aspect == .Conjunction {
            if Int(beginDistance) == 0 && Int(endDistance) == 359 && natalDegree == 0 {
                return true
            }
            if aspect == .Conjunction {
                return canMakeConjunction(planetDegree, endPlanetDegree: endPlanetDegree, planet2Degree: planet2Degree, endPlanet2Degree: endPlanet2Degree)
            }
        }
        
        if (planetDegree.getAstroSign() == .Pisces && endPlanetDegree.getAstroSign() == .Aries) ||
            (planetDegree.getAstroSign() == .Aries && endPlanetDegree.getAstroSign() == .Pisces)  {
            if aspect == .Opposition {
                if aspect.rawValue < (360 - endDistance) && aspect.rawValue > beginDistance {
                    return true
                }
            }
        }
        
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
            if Int(planetLaterDegree) == 359 && Int(planetDegree) == 0 {
                direct = false
            }
            if planetDegree > 359.5 && Int(planetLaterDegree) == 0 {
              direct = true
            }
        }
        TransitFinder.adapterCalls += 2
        
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

/*
*  Copyright (C) 2022-2024 Michael R Adams.
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
//  Created by Michael Adams on 4/15/24.
//

import Foundation
import SwiftUI
class WheelChartDataViewModel {
    let planetData: [PlanetCell]
    let houseData: [HouseCell]
    let aspectsData: [TransitCell]
    let chartTitle: String
    let chart: Charts
    let houseSystem: HouseSystem
#if os(macOS)
    let symbolFontSize = 20.0
#else
    let symbolFontSize = 22.0
#endif
    
    init(planets: [PlanetCell], aspects: [TransitCell], houses: [HouseCell], chart: Charts, title: String, houseSystem: HouseSystem) {
        planetData = planets
        aspectsData = aspects
        houseData = houses
        chartTitle = title
        self.chart = chart
        self.houseSystem = houseSystem
        
    }
    func getPlanetSymbolRow(_ data: PlanetCell) -> some View {
        var row =  Text("\(data.planet.getAstroCharacter().0)").font(Font.custom(data.planet.getAstroCharacter().1, size: symbolFontSize)) + Text(" ") + Text("\(data.sign.getAstroCharacter().0)").font(Font.custom(data.sign.getAstroCharacter().1, size: symbolFontSize)) + Text(" \(data.degree)")
        if data.retrograde {
            row = row + Text(" R")
        }
        row = row + Text("\(getInHouseInfo(data))")
        return HStack { row }
    }
    func getPlanetRow(_ data: PlanetCell) -> String {
        var text =  data.planet.getName().uppercased() + " " + data.sign.getName() + " " + data.degree
        if data.planet == .Vertex {
            text = data.planet.getName() + " " + data.sign.getName() + " " + data.degree
        }
        if data.retrograde {
            text = text + " " + "R"
        }
        return text + getInHouseInfo(data)
    }
    
    func getInHouseInfo(_ data: PlanetCell) -> String {
        if houseData.isEmpty || houseData.count < 12 {
            return ""
        }
        if data.planet == .Ascendant || data.planet == .MC {
            return ""
        }
        for i in 1...12 {
            var nextHouseDegree = houseData[i - 1].numericDegree
            var previousHouseDegree = 1.0
            if i == 1 {
                previousHouseDegree = houseData[11].numericDegree
            } else {
                previousHouseDegree = houseData[i - 2].numericDegree
            }
            var planetDegree = data.numericDegree
            if nextHouseDegree < previousHouseDegree {
                nextHouseDegree += 360.0
                if planetDegree < 180.0 {
                    planetDegree += 360.0
                }
            }
            if isInHouse(planetDegree: planetDegree, nextDegree: nextHouseDegree, prevDegree: previousHouseDegree) {
                if isOnHouseCusp(planetDegree: planetDegree, nextDegree: nextHouseDegree, house: i) {
                    if i == 1 {
                        return " in H12/1"
                    }
                    return " in H" + String(i - 1) + "/" + String(i)
                } else {
                    if i == 1 {
                        return " in H12"
                    }
                    return " in H" + String(i - 1)
                }
            }
        }
        return ""
    }
    
    func isInHouse(planetDegree: Double, nextDegree: Double, prevDegree: Double) -> Bool {
        if planetDegree < nextDegree && planetDegree >= prevDegree {
            return true
        }
        return false
    }
    
    func isOnHouseCusp(planetDegree: Double, nextDegree: Double, house: Int) -> Bool {
        
        if houseSystem == HouseSystem.Whole || houseSystem == HouseSystem.Equal {
            return false
        }
        if house == 1 || house == 10 || house == 7 || house == 4 {
            if planetDegree > nextDegree - 2.0 {
                return true
            } else {
                return false
            }
        }
        if planetDegree > nextDegree - 1.0 {
            return true
        }
        return false
    }
    
    func getAspectsData() -> [TransitCell] {
        if chart == .Natal {
            return aspectsData.sorted(by: {
                if  $0.planet.rawValue < $1.planet.rawValue {
                    if $0.planet.rawValue < $1.planet2.rawValue {
                        return true
                    } else {
                        if $0.planet2.rawValue < $1.planet2.rawValue {
                            return true
                        }
                        return false
                    }
                } else {
                    if $0.planet2.rawValue < $1.planet.rawValue {
                        if $0.planet2.rawValue < $1.planet2.rawValue {
                            return true
                        }
                        return false
                    } else {
                        if $1.planet.rawValue < $0.planet.rawValue {
                            return false
                        }
                        return false
                    }
                }
                        
                        
            })
        }
        if chart == .Synastry {
            return aspectsData.sorted(by: {
                if $0.planet2 == .MC && $1.planet2 == .Ascendant  {
                    return false
                }
                if $0.planet2 == .Ascendant && $1.planet2 == .MC  {
                    return true
                }
                return $0.planet2.rawValue < $1.planet2.rawValue })
        }
        return aspectsData.sorted(by: {
            return $0.planet.rawValue < $1.planet.rawValue })
    }
    
    func getAspectSymbolRow(_ data: TransitCell) -> some View {
        if chart == .Transit {
            var tempo =   Text("\(data.planet.getAstroCharacter().0)").font(Font.custom(data.planet.getAstroCharacter().1, size: symbolFontSize)) + Text(" ") + Text("\(data.aspect.getAstroCharacter().0)").font(Font.custom(data.aspect.getAstroCharacter().1, size: symbolFontSize)) + Text(" ") + Text("\(data.planet2.getAstroCharacter().0)").font(Font.custom(data.planet2.getAstroCharacter().1, size: symbolFontSize)) + Text(" \(data.degree)")
            if data.movement == .Applying {
                tempo = Text("*") + tempo
            }
            return HStack { tempo }
        }
        if chart == .Natal {
            if data.planet.rawValue < data.planet2.rawValue {
                return HStack { Text("\(data.planet.getAstroCharacter().0)").font(Font.custom(data.planet.getAstroCharacter().1, size: symbolFontSize)) + Text(" ") + Text("\(data.aspect.getAstroCharacter().0)").font(Font.custom(data.aspect.getAstroCharacter().1, size: symbolFontSize)) + Text(" ") + Text("\(data.planet2.getAstroCharacter().0)").font(Font.custom(data.planet2.getAstroCharacter().1, size: symbolFontSize)) + Text(" \(data.degree)") }
            } else {
                return HStack { Text("\(data.planet2.getAstroCharacter().0)").font(Font.custom(data.planet2.getAstroCharacter().1, size: symbolFontSize)) + Text(" ") + Text("\(data.aspect.getAstroCharacter().0)").font(Font.custom(data.aspect.getAstroCharacter().1, size: symbolFontSize)) + Text(" ") + Text("\(data.planet.getAstroCharacter().0)").font(Font.custom(data.planet.getAstroCharacter().1, size: symbolFontSize)) + Text(" \(data.degree)") }
            }
        }
        return HStack { Text("\(data.planet2.getAstroCharacter().0)").font(Font.custom(data.planet2.getAstroCharacter().1, size: symbolFontSize)) + Text(" ") + Text("\(data.aspect.getAstroCharacter().0)").font(Font.custom(data.aspect.getAstroCharacter().1, size: symbolFontSize)) + Text(" ") + Text("\(data.planet.getAstroCharacter().0)").font(Font.custom(data.planet.getAstroCharacter().1, size: symbolFontSize)) + Text(" \(data.degree)") }
    }
    
    func getAspectRow(_ data: TransitCell) -> String {
        if chart == .Transit {
            var tempo =   data.planet.getName() + " " + data.aspect.getName() + " " + data.planet2.getName() + " " + data.degree
            if data.movement == .Applying {
                tempo = "*" + tempo
            }
            return tempo
        }
        if chart == .Natal {
            if data.planet.rawValue < data.planet2.rawValue {
                return data.planet.getName() + " " + data.aspect.getName() + " " + data.planet2.getName() + " " + data.degree
            } else {
                return data.planet2.getName() + " " + data.aspect.getName() + " " + data.planet.getName() + " " + data.degree
            }
        }
        return data.planet2.getName() + " " + data.aspect.getName() + " " + data.planet.getName() + " " + data.degree
    }
    
    func showAspect(data: TransitCell, manager: BirthDataManager, major: Bool) -> Bool {
        if data.aspect.isMajor() == major && major {
            if manager.bodiesToShow.contains(data.planet) && manager.bodiesToShow.contains(data.planet2) {
                return true
            }
        }
        else if data.aspect.isMajor() == major && !major {
            if manager.showMinorAspects && manager.aspectsToShow.contains(data.aspect) {
                if manager.bodiesToShow.contains(data.planet) && manager.bodiesToShow.contains(data.planet2) {
                    return true
                }
            }
        }
            
        return false
    }
    
    func getHouseSymbolRow(_ data: HouseCell) -> some View {
        if let asc = planetData.first(where: { $0.planet == .Ascendant }) {
            if asc.numericDegree != houseData[0].numericDegree {
                return HStack { Text("\(data.house.getHouseNumericName(type: data.type))  ") + Text("\(data.degree) ") + Text("\(data.sign.getAstroCharacter().0)").font(Font.custom(data.sign.getAstroCharacter().1, size: symbolFontSize)) }
                
            }
        }
        if let asc = planetData.first(where: { $0.planet == .MC }) {
            if asc.numericDegree != houseData[9].numericDegree {
                if data.house.getHouseShortName() == houseData[0].house.getHouseShortName() {
                    return HStack { Text("\(data.house.getHouseShortName()) ") + Text("\(data.degree) ") + Text("\(data.sign.getAstroCharacter().0)").font(Font.custom(data.sign.getAstroCharacter().1, size: symbolFontSize)) }
                }
                return HStack { Text("\(data.house.getHouseNumericName(type: data.type))  ") + Text("\(data.degree) ") + Text("\(data.sign.getAstroCharacter().0)").font(Font.custom(data.sign.getAstroCharacter().1, size: symbolFontSize)) }
                
            }
        }
        if data.house.getHouseShortName().count == 3 {
            return HStack { Text("\(data.house.getHouseShortName()) ") + Text("\(data.degree) ") + Text("\(data.sign.getAstroCharacter().0)").font(Font.custom(data.sign.getAstroCharacter().1, size: symbolFontSize)) }
        } else {
            return HStack { Text("\(data.house.getHouseShortName())  ") + Text("\(data.degree) ") + Text("\(data.sign.getAstroCharacter().0)").font(Font.custom(data.sign.getAstroCharacter().1, size: symbolFontSize)) }
        }
        
    }
    
    func getHouseRow(_ data: HouseCell) -> String {
        if let asc = planetData.first(where: { $0.planet == .Ascendant }) {
            if asc.numericDegree != houseData[0].numericDegree {
                return data.house.getHouseNumericName(type: data.type) + "  " + data.degree + " " + data.sign.getName()
                
            }
        }
        if let asc = planetData.first(where: { $0.planet == .MC }) {
            if asc.numericDegree != houseData[9].numericDegree {
                if data.house.getHouseShortName() == houseData[0].house.getHouseShortName() {
                    return data.house.getHouseShortName() + " " + data.degree + " " + data.sign.getName()
                }
                return data.house.getHouseNumericName(type: data.type) + "  " + data.degree + " " + data.sign.getName()
                
            }
        }
        if data.house.getHouseShortName().count == 3 {
            return data.house.getHouseShortName() + " " + data.degree + " " + data.sign.getName()
        } else {
            return data.house.getHouseShortName() + "  " + data.degree + " " + data.sign.getName()
        }
        
    }
    
    func showPlanet(data: PlanetCell, manager: BirthDataManager) -> Bool {
        if manager.bodiesToShow.contains(data.planet) {
            if data.planet != .MC && data.planet != .Vertex {
                return true
            }
        }
        return false
    }
}

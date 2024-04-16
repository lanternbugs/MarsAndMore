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
class WheelChartDataViewModel {
    let planetData: [PlanetCell]
    let houseData: [HouseCell]
    let aspectsData: [TransitCell]
    let chartTitle: String
    let chart: Charts
    
    init(planets: [PlanetCell], aspects: [TransitCell], houses: [HouseCell], chart: Charts, title: String) {
        planetData = planets
        aspectsData = aspects
        houseData = houses
        chartTitle = title
        self.chart = chart
        
    }
    
    func getPlanetRow(_ data: PlanetCell) -> String {
        var text =  data.planet.getName().uppercased() + " " + data.sign.getName() + " " + data.degree
        if data.retrograde {
            text = text + " " + "R"
        }
        return text
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
                if $0.planet2 == .MC && $1.planet2 == .Ascendent  {
                    return false
                }
                if $0.planet2 == .Ascendent && $1.planet2 == .MC  {
                    return true
                }
                return $0.planet2.rawValue < $1.planet2.rawValue })
        }
        return aspectsData.sorted(by: {
            return $0.planet.rawValue < $1.planet.rawValue })
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
    
    func showAspect(data: TransitCell, manager: BirthDataManager) -> Bool {
        if data.aspect.isMajor() && manager.bodiesToShow.contains(data.planet) && manager.bodiesToShow.contains(data.planet2) {
            return true
        }
        return false
    }
    
    func getHouseRow(_ data: HouseCell) -> String {
        if let asc = planetData.first(where: { $0.planet == .Ascendent }) {
            if asc.numericDegree != houseData[0].numericDegree {
                return data.house.getHouseNumericName() + "  " + data.degree + " " + data.sign.getName()
                
            }
        }
        if let asc = planetData.first(where: { $0.planet == .MC }) {
            if asc.numericDegree != houseData[9].numericDegree {
                if data.house.getHouseShortName() == houseData[0].house.getHouseShortName() {
                    return data.house.getHouseShortName() + " " + data.degree + " " + data.sign.getName()
                }
                return data.house.getHouseNumericName() + "  " + data.degree + " " + data.sign.getName()
                
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
            if data.planet != .MC && data.planet != .Ascendent {
                return true
            }
        }
        return false
    }
}

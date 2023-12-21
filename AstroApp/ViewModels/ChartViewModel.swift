/*
*  Copyright (C) 2022-23 Michael R Adams.
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
//  Created by Michael Adams on 11/30/23.
//

import Foundation
#if os(iOS)
import UIKit
private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
#endif


class ChartViewModel {
    let chartName: String
    var manager: BirthDataManager?
    var houseData = [HouseCell]()
    var planetData = [PlanetCell]()
    var secondaryPlanetData = [PlanetCell]()
    var aspectsData = [TransitCell]()
    var houseDictionary = [Int: (Int, Signs)]()
    var planetsDictionary = [Int: [PlanetCell]]()
    var secondaryPlanetsDictionary = [Int: [PlanetCell]]()
    var planetToDegreeMap = [Planets: Int]()
    var secondaryPlanetToDegreeMap = [Planets: Int]()
    var width: Double = 2
    var height: Double = 2
    let chart: Charts
    
    init(chartName: String, chartType: Charts) {
        self.chartName = chartName
        self.chart = chartType
    }
    func populateData() {
        if !planetsDictionary.isEmpty {
            return
        }
        // we dont currently have a font image for Pholus
        planetData = planetData.filter( { $0.planet != .Pholus })
        aspectsData = aspectsData.filter( { $0.planet != .Pholus && $0.planet2 != .Pholus })
        if houseData.count > 0 {
            for i in 0...houseData.count - 1 {
                var a = i
                if a == 0 {
                    a = 12
                }
                houseDictionary[Int(houseData[a - 1].numericDegree)] = (a, houseData[a - 1].sign)
            }
        }
        if planetData.count > 0 {
            for i in 0...planetData.count - 1 {
                
                if planetsDictionary[Int(planetData[i].numericDegree)] == nil {
                    var planetArray = [PlanetCell]()
                    planetArray.append(planetData[i])
                    planetsDictionary[Int(planetData[i].numericDegree)] = planetArray
                    
                } else {
                    planetsDictionary[Int(planetData[i].numericDegree)]?.append(planetData[i])
                }
                planetToDegreeMap[planetData[i].planet] = Int(planetData[i].numericDegree)
            }
            
            if secondaryPlanetData.count > 0 {
                for i in 0...secondaryPlanetData.count - 1 {
                    
                    if secondaryPlanetsDictionary[Int(secondaryPlanetData[i].numericDegree)] == nil {
                        var planetArray = [PlanetCell]()
                        planetArray.append(secondaryPlanetData[i])
                        secondaryPlanetsDictionary[Int(secondaryPlanetData[i].numericDegree)] = planetArray
                        
                    } else {
                        secondaryPlanetsDictionary[Int(secondaryPlanetData[i].numericDegree)]?.append(secondaryPlanetData[i])
                    }
                    secondaryPlanetToDegreeMap[secondaryPlanetData[i].planet] = Int(secondaryPlanetData[i].numericDegree)
                }
            }
        }
    }
    var radius: Double {
        var value = width < height ? width / 2.0 - 34.0 : height / 2.0 - 34.0
        if chart == .Natal {
            if houseData.isEmpty {
                value += 30
            }
    #if os(iOS)
            let idiom : UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
            if !houseData.isEmpty  && idiom != .pad {
                value += 7
            }
    #endif
        } else {
            value += 33
#if os(iOS)
        let idiom : UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
            if idiom != .pad {
                value -= 12
            }
#endif
        }

        return value
    }
    
    var interiorRadius: Double {
#if os(iOS)
        (radius - getArcStrokeWidth() + innerRadius) / 2 * 1.11
#else
        (radius - getArcStrokeWidth() + innerRadius) / 2 * 1.06
#endif
        
        
    }
    var innerRadius: Double {
#if os(iOS)
        let idiom : UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        if idiom == .pad {
            return radius  * 0.40
        }
        return radius * 0.29
#else
        return radius * 0.40
#endif
        
    }
    
    var center: (x: Double, y: Double) {
        (width / 2.0, width / 2 -  ((width - height) / 2.0))
    }
    
    func setWidth(_ w: Double) {
        width = w
    }
    
    func setHeight(_ h: Double) {
        height = h
    }
    
    func getChartStartDegree() -> Double {
        if houseData.count > 0 {
            let houseDegree = houseData[0].numericDegree
            return 180.0 - houseDegree
        }
        return 180.0
    }
    
    func justifyCoordinate(inputCoordinate: (Int, Int), radians: Double, size: Double) -> (Int, Int) {
        var coordinate = inputCoordinate
        let xJustification = Int(cos(radians) * size / 2)

        if xJustification < 0 {
            coordinate.0 += xJustification
        } else {
            coordinate.0 -= xJustification
        }

        let yJustification = Int(sin(radians) * size / 2) // sin positive subtract sin negative add

        if yJustification < 0 {
            coordinate.1 += yJustification
        } else {
            coordinate.1 -= yJustification
        }

        
        
        
        return coordinate
    }
    func justifyTextCoordinatePlus(inputCoordinate: (Int, Int), radians: Double, size: Double, multiplier: Int) -> (Int, Int) {
        var coordinate = inputCoordinate
        var xJustification = Int(cos(radians) * size / 2)

        if xJustification < 0 {
#if os(iOS)
            coordinate.0 += Int(Double(xJustification) * 1.5)
#else
            coordinate.0 += xJustification  * multiplier
#endif
            
        } else {
           
#if os(iOS)
            coordinate.0 -= xJustification
#else
            // coordinate.0 += xJustification
#endif
        }

        let yJustification = Int(sin(radians) * size / 2) // sin positive subtract sin negative add

        if yJustification < 0 {
            coordinate.1 += yJustification
        } else {
            coordinate.1 -= yJustification
        }

        
        
        
        return coordinate
    }
    func getXYFromPolar(_ radius: Double, _ degree: Double) -> (Int, Int) {
        let radians = degree * ( .pi / 180.0 )
        var coordinate = ((Int(center.x + radius * cos(radians))), Int(center.y + radius * sin(radians)))
#if os(iOS)
        coordinate.1 = Int(height) - coordinate.1
#endif
        return coordinate
    }
    
    func getArcStrokeWidth() -> Double {
#if os(iOS)
        if idiom != .pad {
            return 10
        }
        return 25
        
#else
        return 30
#endif
    }
}

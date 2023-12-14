//
//  NatalChartViewModel.swift
//  MarsAndMore
//
//  Created by Michael Adams on 11/30/23.
//

import Foundation

struct NatalChartViewModel {
    let chartName: String
    var houseData = [HouseCell]()
    var planetData = [PlanetCell]()
    var aspectsData = [TransitCell]()
    var houseDictionary = [Int: (Int, Signs)]()
    var planetsDictionary = [Int: [PlanetCell]]()
    var planetToDegreeMap = [Planets: Int]()
    var width: Double = 2
    var height: Double = 2
    mutating func populateData() {
        if houseData.count > 0 {
            for i in 0...houseData.count - 1 {
                houseDictionary[Int(houseData[i].numericDegree)] = (i + 1, houseData[i].sign)
            }
        }
        if planetData.count > 0 {
            for i in 0...planetData.count - 1 {
                if planetData[i].planet == .MC || planetData[i].planet == .Ascendent {
                    continue
                }
                if planetData[i].planet.rawValue > Planets.Pluto.rawValue {
                    continue
                }
                if planetsDictionary[Int(planetData[i].numericDegree)] == nil {
                    var planetArray = [PlanetCell]()
                    planetArray.append(planetData[i])
                    planetsDictionary[Int(planetData[i].numericDegree)] = planetArray
                    
                } else {
                    planetsDictionary[Int(planetData[i].numericDegree)]?.append(planetData[i])
                }
                planetToDegreeMap[planetData[i].planet] = Int(planetData[i].numericDegree)
            }
        }
    }
    var radius: Double {
        width < height ? width / 2.0 - 34.0 : height / 2.0 - 34.0
    }
    
    var innerRadius: Double {
        radius * 0.40
    }
    
    var center: (x: Double, y: Double) {
        (width / 2.0, width / 2 -  ((width - height) / 2.0))
    }
    
    mutating func setWidth(_ w: Double) {
        width = w
    }
    
    mutating func setHeight(_ h: Double) {
        height = h
    }
    
    func getChartStartDegree() -> Double {
        if houseData.count > 0 {
            let houseDegree = houseData[0].numericDegree
            if houseDegree > 180 {
                return abs(180 - houseDegree)
            } else {
                return houseDegree + 180.0
            }
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
        return 20
#else
        return 30
#endif
    }
}

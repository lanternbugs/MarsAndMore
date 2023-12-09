//
//  NatalChartViewModel.swift
//  MarsAndMore
//
//  Created by Michael Adams on 11/30/23.
//

import Foundation

struct NatalChartViewModel {
    let chart = "Natal Chart Stub Text"
    var houseData = [HouseCell]()
    var planetData = [PlanetCell]()
    var width: Double = 2
    var height: Double = 2
    
    var radius: Double {
        width < height ? width / 2.0 : height / 2.0
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

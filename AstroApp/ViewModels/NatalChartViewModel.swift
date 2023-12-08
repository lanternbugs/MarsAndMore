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
            var degree = 180 -  houseData[11].numericDegree
            if degree < 0 {
                degree = 180 + degree
            }
            return degree
        }
        return 180.0
    }
    
    func getXYFromPolar(_ radius: Double, _ degree: Double) -> (Int, Int) {
        let radians = degree * ( .pi / 180.0 )
        return ((Int(center.x + radius * cos(radians))), Int(center.y + radius * sin(radians)))
    }
    
    func getArcStrokeWidth() -> Double {
#if os(iOS)
        return 20
#else
        return 30
#endif
    }
}

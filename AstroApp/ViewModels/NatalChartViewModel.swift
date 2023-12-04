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
    
    func getChartStartDegree() -> Double {
        if houseData.count > 0 {
            var degree = 180 -  houseData[0].numericDegree
            if degree < 0 {
                degree = 180 + degree
            }
            return degree
        }
        return 180.0
    }
}

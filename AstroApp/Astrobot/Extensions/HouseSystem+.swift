//
//  HouseSystem+.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/4/22.
//

import Foundation
extension HouseSystem {
    func getHouseCode()->String {
        switch self {
        case .Placidus:
            return "P"
        case .Koch:
            return "K"
        case .Porphyrius:
            return "O"
        case .Regiomontanus:
            return "R"
        case .Campanus:
            return "C"
        case .Equal:
            return "E"
        case .Whole:
            return "W"
        }
    }
}

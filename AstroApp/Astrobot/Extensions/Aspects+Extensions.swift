//
//  Aspects+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/16/22.
//

import Foundation
extension Aspects {
    func getName()->String
    {
        switch(self) {
        case .Trine:
            return "Trine"
        case .Conjunction:
            return "Conjunction"
        case .Opposition:
            return "Opposition"
        case .Sextile:
            return "Sextile"
        case .Square:
            return "Square"
        }
    }
}

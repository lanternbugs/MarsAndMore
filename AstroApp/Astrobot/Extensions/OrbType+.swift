//
//  OrbType+.swift
//  MarsAndMore
//
//  Created by Michael Adams on 9/12/22.
//

import Foundation
extension OrbType {
    func getShortName()->String
    {
        switch self
        {
        case .NarrowOrbs:
            return "Narrow"
        case .MediumOrbs:
            return "Medium"
        case .WideOrbs:
            return "Wide"
        }
    }
}

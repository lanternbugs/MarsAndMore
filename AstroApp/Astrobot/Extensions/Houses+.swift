//
//  Houses+.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/1/22.
//

import Foundation
extension Houses
{
    func getHouseShortName()->String
    {
        switch self {
        case .H1:
            return "Asc"
        case .H10:
            return "MC"
        default:
            return "H" + String(self.rawValue)
        }
    }
}

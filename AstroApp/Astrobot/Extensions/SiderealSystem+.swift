//
//  SiderealSystem+.swift
//  MarsAndMore
//
//  Created by Michael Adams on 11/8/23.
//

import Foundation
extension SiderealSystem {
    func getName() -> String {
        switch self {
        case .Lahiri:
            return "Lahiri"
        case .FaganBradley:
            return "Fagan-Bradley"
        case .Raman:
            return "Raman"
        }
    }
}

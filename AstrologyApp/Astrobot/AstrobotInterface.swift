//
//  AstrobotProtocol.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

import Foundation
protocol AstrobotBaseInterface {
    func getPlanets(time: Double)->PlanetRow
}

protocol AstrobotInterface: AstrobotBaseInterface {
    func getTransits()->PlanetRow
    func getAspects()->PlanetRow
}

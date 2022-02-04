//
//  AstrobotProtocol.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

import Foundation
protocol AstrobotInterface {
    func getPlanets(id: Int)->PlanetRow
    var  data: [PlanetRow] {
        get
        set
    }
}

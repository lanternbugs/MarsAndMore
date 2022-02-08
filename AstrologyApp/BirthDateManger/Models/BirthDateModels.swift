//
//  BirthDateModels.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/7/22.
//

import Foundation
struct City: Codable {
    var city: String
    var country: String
    var latitude: String
    var longitude: String
}

struct CityInfo: Codable {
    var cities: [City]
}

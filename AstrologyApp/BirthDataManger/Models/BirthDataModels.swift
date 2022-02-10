/*
*  Copyright (C) 2022 Michael R Adams.
*  All rights reserved.
*
* This program can be redistributed and/or modified under
* the terms of the GNU General Public License; either
* version 2 of the License, or (at your option) any later version.
*
*  This code is distributed in the hope that it will
*  be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/

import Foundation
enum BuildType: Error {
    case birthData(data: BirthData)
    case buildError(error: String)
}
struct City: Codable {
    var city: String
    var country: String
    var latitude: String
    var longitude: String
    var id: Int
}

struct CityInfo: Codable {
    var cities: [City]
}
struct BirthDate {
    let birthdate: Date
    let exactTime: Bool
}
struct BirthData {
    let name: String
    let birthdate: BirthDate
    let city: CityInfo?
}

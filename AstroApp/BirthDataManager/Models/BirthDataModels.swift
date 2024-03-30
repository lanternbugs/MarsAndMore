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
enum BuildErrors: Error {
    case NoName(mess: String)
    case DuplicateName(mess: String)
    case MissingDependency(mess: String)
}

struct City: Codable {
    var name: String
    var country: String
    var latitude: String
    var longitude: String
    var id: Int
    enum CodingKeys: String, CodingKey {
        case name = "city", country, latitude, longitude, id
    }
}

struct CityInfo: Codable {
    var cities: [City]
}
struct CalendarDate {
    let birthDate: Date
    let exactTime: Bool
}
struct BirthDate: Hashable {
    let year: Int32
    let month: Int32
    let day: Int32
}
struct LocationData: Hashable {
    let latitude: String
    let longitude: String
}
struct BirthData: Hashable {
    static func == (lhs: BirthData, rhs: BirthData) -> Bool {
        return lhs.id == rhs.id
    }
    let name: String
    let birthDate: BirthDate
    let birthTime: Date?
    let location: LocationData?
    var id: Int
    
}

protocol ManagerBuilderInterface: AnyObject {
    func checkIfNameExist(_ name: String)->Bool
    func getNextId()->Int
    func getIdForName(_ name: String) throws ->Int
}

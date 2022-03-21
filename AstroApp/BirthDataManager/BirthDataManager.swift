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
import CoreData
class BirthDataManager: ObservableObject, ManagerBuilderInterface {
    @Published var birthDates = [BirthData]()
    @Published var cityInfo: CityInfo?
    @Published var selectedName: Int?
    @Published var userNameSelection: String = ""
    @Published var userDateSelection: Date = Date(timeIntervalSince1970: 0)
    @Published var userExactTimeSelection: Bool = false
    @Published var userLocationData: LocationData?
    var bodiesToShow = Set<Planets>()
    var defaultBodiesToShow = Set<Planets>()
    let builder = BirthDataBuilder()
    var managedContext: NSManagedObjectContext?
    init() {
        self.initializeDefaultBodiesToShow()
        builder.managerInterface = self
        DispatchQueue.global().async { [weak self] in
            let decoder = JSONDecoder()
            let cities = self?.readFileToString("cities")
            guard let cities = cities else {
                return
            }
            if let data = cities.data(using: .utf8) {
                do {
                    let cityData = try decoder.decode(CityInfo.self, from: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.cityInfo = cityData
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func initializeDefaultBodiesToShow() {
        for body in Planets.allCases {
            if body.rawValue <= Planets.Chiron.rawValue {
                defaultBodiesToShow.insert(body)
            }
            
        }
    }
    
    func readFileToString(_ file: String)->String
    {
        if let filepath = Bundle.main.path(forResource: file, ofType: "json") {
            do {
                return  try String(contentsOfFile: filepath, encoding: .utf8)
            } catch {
                print(error)
            }
        }
        return "none"
    }
    
    
}
//Mark: builder helper functions
extension BirthDataManager {
    
    func resetSpecificUserData() {
        userNameSelection = ""
        userExactTimeSelection = false
        userLocationData = nil
        builder.removeLocation()
    }
    func checkIfNameExist(_ name: String) -> Bool {
        let data = birthDates.first {
            $0.name == name
        }
        if let _ = data {
            return true
        }
        return false
    }
    
    func getNextId() -> Int {
        return birthDates.count
    }
    
    func getIdForName(_ name: String) throws ->Int
    {
        let genericError = "error, the name is in use.";
        for val in birthDates {
            if val.name == name {
                return val.id
            }
        }
        throw BuildErrors.MissingDependency(mess: genericError)
    }
    
    func getCurrentName()->String
    {
        if let index = selectedName {
            return birthDates[index].name
        }
        return "Now"
    }
}

class BirthDataBuilder {
    public private(set) var cityData: City?
    public private(set) var locationData: LocationData?
    public private(set) var name: String?
    public private(set) var date: CalendarDate?
    weak var managerInterface: ManagerBuilderInterface?
    
    func reset()->Void {
        cityData = nil
        locationData = nil
        name = nil
        date = nil
    }
    func addNameDate(_ name: String,  birthdate: CalendarDate)
    {
        self.name = name
        self.date = birthdate
    }
    
    func addCity(_ city: City)
    {
       self.cityData = city
        self.locationData = nil
    }
    
    func addLocation(_ location: LocationData) {
        self.locationData = location
        self.cityData = nil
    }
    
    func removeLocation() {
        self.locationData = nil
        self.cityData = nil
    }
    
    func build(mode: RoomState) throws ->BirthData
    {
        let genericError = "error, cannot validate now.";
        var index: Int?
        guard let manager = managerInterface else {
            throw BuildErrors.MissingDependency(mess: genericError)
        }
        guard let name = name, !name.isEmpty else {
            throw BuildErrors.NoName(mess: "You must enter a name")
        }
        switch(mode) {
        case .EditName:
                    index = try manager.getIdForName(name)
        default:
            guard !manager.checkIfNameExist(name) else {
                throw BuildErrors.DuplicateName(mess: "Name is in use. It must be deleted first before reusing.")
            }
            index = manager.getNextId()
        }
        
        guard let date = date else {
            throw BuildErrors.MissingDependency(mess: genericError)
        }
        let formatter = DateFormatter()
        formatter.locale   = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date.birthDate)
       formatter.dateFormat = "MM"
        let month = formatter.string(from: date.birthDate)
       formatter.dateFormat = "dd"
        let day = formatter.string(from: date.birthDate)
        guard let y = Int32(year), let m = Int32(month), let d = Int32(day) else {
            throw BuildErrors.MissingDependency(mess: genericError)
        }
        guard let id = index else {
            throw BuildErrors.MissingDependency(mess: genericError)
        }
        if date.exactTime {
            if let cityData = cityData {
                let location = LocationData(latitude: cityData.latitude, longitude: cityData.longitude)
                reset()
                return BirthData(name: name, birthDate: BirthDate(year: y, month: m, day: d), birthTime: date.birthDate, location: location, id: id)
            } else {
                if let location = locationData {
                    reset()
                    return BirthData(name: name, birthDate: BirthDate(year: y, month: m, day: d), birthTime: date.birthDate, location: location, id: id)
                } else {
                    reset()
                    return BirthData(name: name, birthDate: BirthDate(year: y, month: m, day: d), birthTime: date.birthDate, location: nil, id: id)
                }
                
            }
        }
        reset()
        return BirthData(name: name, birthDate: BirthDate(year: y, month: m, day: d), birthTime: nil, location: nil, id: id)
    }
    
}

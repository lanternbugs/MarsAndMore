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
class BirthDataManager: ObservableObject, ManagerBuilderInterface {
    @Published var birthDates = [BirthData]()
    @Published var cityInfo: CityInfo?
    let builder = BirthDataBuilder()
    
    init() {
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
}

class BirthDataBuilder {
    public private(set) var cityData: City?
    public private(set) var name: String?
    public private(set) var date: CalendarDate?
    weak var managerInterface: ManagerBuilderInterface?
    
    func reset()->Void {
        cityData = nil
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
    }
    
    func build() throws ->BirthData
    {
        let genericError = "error, cannot validate now.";
        guard let name = name, !name.isEmpty else {
            throw BuildErrors.NoName(mess: "You must enter a name")
        }
        guard let manager = managerInterface else {
            throw BuildErrors.MissingDependency(mess: genericError)
        }
        guard !manager.checkIfNameExist(name) else {
            throw BuildErrors.DuplicateName(mess: "Name is in use. It must be deleted first before reusing.")
        }
        guard let date = date else {
            throw BuildErrors.MissingDependency(mess: genericError)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date.birthDate)
       formatter.dateFormat = "MM"
        let month = formatter.string(from: date.birthDate)
       formatter.dateFormat = "dd"
        let day = formatter.string(from: date.birthDate)
        guard let y = Int(year), let m = Int(month), let d = Int(day) else {
            throw BuildErrors.MissingDependency(mess: genericError)
        }
        let id = manager.getNextId()
        if date.exactTime {
            if let cityData = cityData {
                let location = LocationData(latitude: cityData.latitude, longitude: cityData.longitude)
                reset()
                return BirthData(name: name, birthDate: BirthDate(year: y, month: m, day: d), birthTime: date.birthDate, location: location, id: id)
            } else {
                reset()
                return BirthData(name: name, birthDate: BirthDate(year: y, month: m, day: d), birthTime: date.birthDate, location: nil, id: id)
            }
        }
        reset()
        return BirthData(name: name, birthDate: BirthDate(year: y, month: m, day: d), birthTime: nil, location: nil, id: id)
    }
    
}
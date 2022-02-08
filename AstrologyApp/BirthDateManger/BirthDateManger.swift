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
class BirthDateManager: ObservableObject {
    @Published var cityInfo: CityInfo?
    init() {
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
}

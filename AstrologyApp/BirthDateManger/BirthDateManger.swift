//
//  BirthDateManger.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/7/22.
//

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

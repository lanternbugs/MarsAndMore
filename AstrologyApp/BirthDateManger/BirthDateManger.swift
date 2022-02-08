//
//  BirthDateManger.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/7/22.
//

import Foundation
class BirthDateManager: ObservableObject {
    var cityInfo: CityInfo?
    init() {
        DispatchQueue.global().async { [weak self] in
            let decoder = JSONDecoder()
            let cities = self?.readFileToString("cities")
            guard let cities = cities else {
                return
            }
            if let data = cities.data(using: .utf8) {
                do {
                    try self?.cityInfo = decoder.decode(CityInfo.self, from: data)
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

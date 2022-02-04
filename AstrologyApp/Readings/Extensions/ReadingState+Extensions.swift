//
//  ReadingState+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/3/22.
//

import Foundation
extension ReadingState: AstroReading {
    func getReading()-> [ReadingEntry] {
        switch(self) {
        case .Reading(let planet, let sign):
            let file = fileForPlanet(planet: planet, andSign: sign)
            return readingForFile(file)
        default:
            let errorCase = ReadingEntry(text: "Sorry no reading is avaialble for this type", id: 0)
            return [errorCase]
        }
        // unwrap assoicated values and return a reading Reading(planet: Planets, sign: Signs)
       // or return a one paragraph aray with an error message in paragraph
        
    }
    
    func fileForPlanet(planet: Planets, andSign sign: Signs) ->String
    {
        return planet.getName().lowercased() + "-" + sign.getName().lowercased()
    }
    
    func readingForFile(_ file: String)->[ReadingEntry]
    {
        if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath, encoding: .utf8)
                let lines = contents.split(whereSeparator: \.isNewline)
                var reading = [ReadingEntry]()
                for val in lines {
                    reading.append(ReadingEntry(text: String(val), id: reading.count))
                }
                return reading
            } catch {
                return [ReadingEntry(text: "Sorry there was an error reading file", id: 0)]
            }
        }
        
        return [ ReadingEntry(text: "Sorry no reading was found", id: 0)]
    }
}

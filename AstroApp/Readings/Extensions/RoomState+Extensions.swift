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
extension RoomState: AstroReading {
    func getName()->String {
        switch(self) {
        case.Entry:
            return "Entry"
        case .Chart:
            return "Chart Room"
        case .Planets:
            return "Planets Room"
        case .Cities:
            return "Cities"
        case .UpdateCity:
            return "Update City"
        case .PlanetsCity:
            return "Select City"
        case .Names:
            return "Add Name"
        case .EditName:
            return "Edit Name Entry"
        case .Reading:
            return "Reading"
        case .ChartSettings:
            return "Chart Settings"
        case .Resources:
            return "Resources"
        case .Space:
            return "Space"
        case .Picture:
            return "Picture"
        case .Art:
            return "Art"
        case .Library:
            return "Library"
        case .Mundane:
            return "Mundane"
        case .TransitsView:
            return "Transits View"
        case .NatalView:
            return "Natal Chart"
        case .About:
            return "About App"
        case .Mars:
            return "Mars Room"
        case .SynastryChooser:
            return "Partner Chooser"
        case .Ephemeris:
            return "Ephemeris"
        }
    }
    func getReading()-> [ReadingEntry] {
        switch(self) {
        case .Reading(let planet, let sign):
            let file = fileForPlanet(planet: planet, andSign: sign)
            return readingForFile(file)
        case .About:
               return readingForFile("aboutmarsandmore")
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

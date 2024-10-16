/*
*  Copyright (C) 2022-24 Michael R Adams.
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
//  Created by Michael Adams on 8/3/24.
//

import Foundation
import SwiftUI
class EphemerisViewModel: AstrobotInterface, ObservableObject {
    @Published var planetGrid = [PlanetCell]()
    let model: EphemerisModel
    var date: Date { model.date }
    var numbersOfDays: Int { model.numbersOfDays }
    var symbolFontSize: Double { model.symbolFontSize }
    var showEphemerisSymbols: Bool { model.showEphemerisSymbols }
    var showEphemerisKey: Bool { model.showEphemerisKey }
    var showModernEphemeris: Bool { model.showModernEphemeris }
    init(date: Date, calculationSettings: CalculationSettings) {
        let calendar = Calendar.current
        self.model = EphemerisModel(date: calendar.startOfDay(for: date), calculationSettings: calculationSettings)
        setDateToStartOfMonth()
        calculateMonthsPlanetData()
    }

    func toggleEphemerisSymbols() {
        model.showEphemerisSymbols.toggle()
    }
    
    func toggleEphemerisKey() {
        model.showEphemerisKey.toggle()
    }
    
    func toggleModernEphemeris() {
        model.showModernEphemeris.toggle()
    }
    
    func calculateMonthsPlanetData() {
        var planetCells = [PlanetRow]()
        let dates = getDatesForDaysOfMonth()
        for date in dates {
            planetCells.append(getPlanets(time: date.getAstroTime(), location: nil, calculationSettings: model.calculationSettings))
        }
        
       populatePlanetGrid(planetCells: planetCells)
    }
    
    func populatePlanetGrid(planetCells: [PlanetRow]) {
        planetGrid.removeAll()
        var basePlanetGrid = [PlanetCell]()
        for cell in planetCells {
            if let displayPlanets = cell.planets as? [PlanetCell] {
                let filteredPlanets = getFilteredPlanets(displayPlanets)
                for planet in filteredPlanets {
                    basePlanetGrid.append(planet)
                }
            }
        }
        let rows = model.numbersOfDays
        let columns = Int(basePlanetGrid.count / rows)
        for x in 0..<columns {
            for y in 0..<rows {
                planetGrid.append(basePlanetGrid[y * columns + x])
            }
        }
    }
    func getFilteredPlanets(_ displayPlanets: [PlanetCell]) -> [PlanetCell] {
        displayPlanets.filter { $0.planet != .SouthNode && ($0.planet.rawValue < Planets.Uranus.rawValue || model.showModernEphemeris || $0.planet.rawValue == Planets.TrueNode.rawValue) }
    }
    
    func getPlanetString(cell: PlanetCell) -> String {
        var string = " " + cell.planet.getName() + " " + cell.degree + " " + cell.sign.getName()
        if cell.retrograde {
            string = string + " R"
        }
        return string
    }
    
    func getDatesForDaysOfMonth() -> [Date] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let month = formatter.string(from: date)
        var currentMonth = month
        var currentDate = date
        var dates = [Date]()
        repeat {
            dates.append(currentDate)
            currentDate = getNextDay(currentDate)
            currentMonth = formatter.string(from: currentDate)
        } while(currentMonth == month)
        model.numbersOfDays = dates.count
        return dates
    }
    
    func setDateToStartOfMonth() {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        model.date = Calendar.current.date(from: components)!
    }
    
    func getNextDay(_ currentDate: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    func previousMonth() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .month, value: -1, to: date)
        if let newDate = newDate {
            model.date = newDate
        }
        calculateMonthsPlanetData()
    }
    
    func nextMonth() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .month, value: 1, to: date)
        if let newDate = newDate {
            model.date = newDate
        }
        calculateMonthsPlanetData()
    }
}


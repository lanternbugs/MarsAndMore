//
//  EphemerisViewModel.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/3/24.
//

import Foundation
class EphemerisViewModel: AstrobotInterface, ObservableObject {
    var date: Date
    @Published var planetCells = [PlanetRow]()
    let calculationSettings: CalculationSettings
    
    init(date: Date, calculationSettings: CalculationSettings) {
        let calendar = Calendar.current
        self.calculationSettings = calculationSettings
        self.date = calendar.startOfDay(for: date)
        setDateToStartOfMonth()
        calculateMonthsPlanetData()
    }
    
    func calculateMonthsPlanetData() {
        planetCells.removeAll()
        let dates = getDatesForDaysOfMonth()
        for date in dates {
            planetCells.append(getPlanets(time: date.getAstroTime(), location: nil, calculationSettings: calculationSettings))
        }
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
        
        return dates
    }
    
    func setDateToStartOfMonth() {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        date = Calendar.current.date(from: components)!
    }
    
    func getNextDay(_ currentDate: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    func previousMonth() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .month, value: -1, to: date)
        if let newDate = newDate {
            date = newDate
        }
        calculateMonthsPlanetData()
    }
    
    func nextMonth() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .month, value: 1, to: date)
        if let newDate = newDate {
            date = newDate
        }
        calculateMonthsPlanetData()
    }
    
    func getPlanetsArray(planets: PlanetRow) -> [PlanetCell] {
        if let displayPlanets = planets.planets as? [PlanetCell] {
            let filteredPlanets = displayPlanets.filter { $0.planet != .Pholus && $0.planet != .SouthNode && $0.planet.rawValue < Planets.Uranus.rawValue }
            return filteredPlanets
        }
        return [PlanetCell]()
    }
    
    func getPlanetRow(planets: PlanetRow) -> String {
        var planetsString = ""
        if let displayPlanets = planets.planets as? [PlanetCell] {
            let filteredPlanets = displayPlanets.filter { $0.planet != .Pholus && $0.planet != .SouthNode && $0.planet.rawValue < Planets.Uranus.rawValue }
            for cell in filteredPlanets {
                planetsString += " " + cell.planet.getName() + " " + cell.degree + " " + cell.sign.getName()
            }
        }
        return planetsString
    }
    
    func getPlanetString(cell: PlanetCell) -> String {
        " " + cell.planet.getName() + " " + cell.degree + " " + cell.sign.getName()
    }
}

extension Date {
    func getMonthYearDisplayDate() -> String {
        let formatter = DateFormatter()
#if os(macOS)
        formatter.dateFormat = "MMMM YYYY"
#elseif os(iOS)
    if idiom == .pad {
        formatter.dateFormat = "MMMM YYYY"
        
    } else {
        formatter.dateFormat = "MM-YYYY"
    }
#endif
        let monthYear = formatter.string(from: self)
        return monthYear
    }
}

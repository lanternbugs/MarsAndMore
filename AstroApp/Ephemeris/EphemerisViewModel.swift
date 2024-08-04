//
//  EphemerisViewModel.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/3/24.
//

import Foundation
class EphemerisViewModel: AstrobotInterface {
    var date: Date
    var planetCells = [PlanetRow]()
    
    init(date: Date) {
        let calendar = Calendar.current
        self.date = calendar.startOfDay(for: date)
        setDateToStartOfMonth()
        calculateMonthsPlanetData()
    }
    
    func calculateMonthsPlanetData() {
        let dates = getDatesForDaysOfMonth()
        for date in dates {
            planetCells.append(getPlanets(time: date.getAstroTime(), location: nil, calculationSettings: CalculationSettings()))
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
    }
    
    func nextMonth() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .month, value: 1, to: date)
        if let newDate = newDate {
            date = newDate
        }
    }
}

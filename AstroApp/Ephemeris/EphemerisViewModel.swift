//
//  EphemerisViewModel.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/3/24.
//

import Foundation
class EphemerisViewModel {
    var date: Date
    init(date: Date) {
        let calendar = Calendar.current
        self.date = calendar.startOfDay(for: date)
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

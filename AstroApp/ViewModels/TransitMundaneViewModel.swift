/*
*  Copyright (C) 2022-2024 Michael R Adams.
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
//  Created by Michael Adams on 4/16/24.
//

import Foundation
import SwiftUI

class TransitMundaneViewModel: ObservableObject, AstrobotInterface {
    @Published var transits: [TransitTime] = [TransitTime]()
    @Published var skyTransits: [TransitTime]
    @Published var date: Date
    @AppStorage("showTransitTimeSymbols") var showTransitTimeSymbols: Bool = false
    @Published var showTransitSymbolKey: Bool = false
    let transitData: TransitTimeData?
    let manager: BirthDataManager
    
    init(transits: [TransitTime], skyTransits: [TransitTime], transitData: TransitTimeData?, date: Date, manager: BirthDataManager) {
        self.transits = transits
        self.skyTransits = skyTransits
        self.transitData = transitData
        self.date = date
        self.manager = manager
    }
    
    func previousDay() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: -1, to: date)
        if let newDate = newDate {
            skyTransits = getTransitTimes(start_time: newDate.getAstroTime(), end_time: date.getAstroTime(), manager: manager)
            if let transitData = transitData {
                transits = getNatalTransitTimes(start_time: newDate.getAstroTime(), end_time: date.getAstroTime(), manager: manager, transitTimeData: transitData)
            }
            date = newDate
        }
    }
    
    func nextDay() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: 1, to: date)
        if let newDate = newDate {
            let endDate = calendar.date(byAdding: .day, value: 1, to: newDate)
            if let endDate = endDate {
                skyTransits = getTransitTimes(start_time: newDate.getAstroTime(), end_time: endDate.getAstroTime(), manager: manager)
                if let transitData = transitData {
                    transits = getNatalTransitTimes(start_time: newDate.getAstroTime(), end_time: endDate.getAstroTime(), manager: manager, transitTimeData: transitData)
                }
                date = newDate
            }
        }
    }
}

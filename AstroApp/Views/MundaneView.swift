//
//  MundaneView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 11/19/23.
//

import SwiftUI

struct MundaneView: View, AstrobotInterface {
    @State var transits: [TransitTime]
    @State var date: Date
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Mundane").font(.title)
                Spacer()
            }
            HStack {
                Button(action: previousDay) {
                    Text("<<").font(.title)
                }
                Spacer()
                Text("\(getDateString())").font(.title2)
                Spacer()
                Button(action: nextDay) {
                    Text(">>").font(.title)
                }
            }
            
            ScrollView {
                VStack {
                    HStack {
                        Text("Planetary Transits").font(.title)
                        Spacer()
                    }
                    ForEach(transits.sorted(by: { $0.time.time < $1.time.time}), id: \.time) {
                        transit in
                        if isPlanetaryTransit(transit) {
                            let displayTime = getDisplayTime(transit: transit)
                            HStack {
                                Text("\(transit.planet.getName()) \(transit.aspect.getName()) \(transit.planet2.getName()) \(displayTime)")
                                Spacer()
                            }
                        }
                        
                    }
                    Text(" ")
                    HStack {
                        Text("Moon Transits").font(.title)
                        Spacer()
                    }
                    VStack {
                        ForEach(transits.sorted(by: { $0.time.time < $1.time.time}), id: \.time) {
                            transit in
                            if isMoonTransit(transit) {
                                let displayTime = getDisplayTime(transit: transit)
                                HStack {
                                    Text("\(transit.planet.getName()) \(transit.aspect.getName()) \(transit.planet2.getName()) \(displayTime)")
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
    }
}

extension MundaneView {
    func isPlanetaryTransit(_ transit: TransitTime) -> Bool {
        transit.planet != .Moon && transit.planet2 != .Moon
    }
    func isMoonTransit(_ transit: TransitTime) -> Bool {
        transit.planet == .Moon
    }

    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M-d-yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func previousDay() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: -1, to: date)
        if let newDate = newDate {
            transits = getTransitTimes(start_time: newDate.getAstroTime(), end_time: date.getAstroTime())
            date = newDate
        }
    }
    
    func nextDay() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: 1, to: date)
        if let newDate = newDate {
            let endDate = calendar.date(byAdding: .day, value: 1, to: newDate)
            if let endDate = endDate {
                transits = getTransitTimes(start_time: newDate.getAstroTime(), end_time: endDate.getAstroTime())
                date = newDate
            }
        }
        
        
    }
    
    func getDisplayTime(transit: TransitTime) -> String {
        var dateComponents = DateComponents()
        let year = transit.time.year
        let month = transit.time.month
        let day = transit.time.day
        let time = transit.time.time
        dateComponents.year = Int(year)
        dateComponents.month = Int(month)
        dateComponents.day = Int(day)
        dateComponents.hour = Int(time)
        let minuteFraction = time - Double(Int(time))
        dateComponents.minute = Int(60.0 * minuteFraction)
        dateComponents.timeZone = TimeZone(abbreviation: "UTC" )

        // Create date from components
        let userCalendar = Calendar(identifier: .gregorian)
        guard let someDateTime = userCalendar.date(from: dateComponents) else { return "no time" }
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = TimeZone.current
        let hourString = formatter.string(from: someDateTime)
        return hourString
    }
}


#Preview {
    MundaneView(transits: [], date: Date())
}

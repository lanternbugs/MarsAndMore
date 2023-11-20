//
//  MundaneView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 11/19/23.
//

import SwiftUI

struct MundaneView: View {
    let transits: [TransitTime]
    var body: some View {
        VStack {
            HStack {
                Text("Moon Transits").font(.title)
                Spacer()
            }
            ScrollView {
                VStack {
                    ForEach(transits, id: \.time) {
                        transit in
                        let displayTime = getDisplayTime(transit: transit)
                        Text("\(transit.planet.getName()) \(transit.aspect.getName()) \(transit.planet2.getName()) \(displayTime)")
                    }
                }
            }        
        }
        
    }
}

extension MundaneView {
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
        let date = Date()
        let minuteFraction = time - Double(Int(time))
        dateComponents.minute = Int(60.0 * minuteFraction)
        dateComponents.timeZone = TimeZone(abbreviation: "UTC" )

        // Create date from components
        let userCalendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian
        guard let someDateTime = userCalendar.date(from: dateComponents) else { return "no time" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd hh:mm a"
        formatter.timeZone = TimeZone.current
        // TimeZone.current.identifier
        let hourString = formatter.string(from: someDateTime)
        return hourString
    }
}


#Preview {
    MundaneView(transits: [])
}

//
//  TransitTimesView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 11/21/23.
//

import SwiftUI
enum TransitsToShow {
    case Moon, Planetary, All
}
struct TransitTimesView: View {
    @Binding var transits: [TransitTime]
    let transitToShow: TransitsToShow
    var body: some View {
        VStack {
            ForEach(transits.sorted(), id: \.time) {
                transit in
                if shouldShowTransit(transit) {
                    let displayTime = getDisplayTime(transit: transit)
                    HStack {
#if os(macOS)

            if #available(macOS 12.0, *) {
                Text("\(transit.planet.getName()) \(transit.aspect.getName()) \(transit.planet2.getName()) \(displayTime)").textSelection(.enabled)

            } else {
                Text("\(transit.planet.getName()) \(transit.aspect.getName()) \(transit.planet2.getName()) \(displayTime)")
            }

#else

            if #available(iOS 15.0, *) {
                Text("\(transit.planet.getName()) \(transit.aspect.getName()) \(transit.planet2.getName()) \(displayTime)").textSelection(.enabled)
            } else {
                Text("\(transit.planet.getName()) \(transit.aspect.getName()) \(transit.planet2.getName()) \(displayTime)")
            }

#endif
                        Spacer()
                    }
                }
            }
        }
    }
}
extension TransitTimesView {
    
    func shouldShowTransit(_ transit: TransitTime) -> Bool {
        if transitToShow == .All {
            return true
        }
        if transitToShow == .Moon {
            if transit.planet == .Moon {
                return true
            }
        }
        if transitToShow == .Planetary {
            if transit.planet != .Moon && transit.planet2 != .Moon {
                return true
            }
        }
        return false
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
        var minute = Int(60.0 * minuteFraction)
        let decimalMinute = 60.0 * minuteFraction
        if decimalMinute - Double(minute) >= 0.5 {
            minute += 1
        }
        dateComponents.minute = minute
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

struct TransitTimesView_Previews: PreviewProvider {
    @State static var row: [TransitTime] = []
    static var previews: some View {
        TransitTimesView(transits: $row, transitToShow: .All)
    }
}
/*
 #Preview {
     TransitTimesView()
 }
 */
 

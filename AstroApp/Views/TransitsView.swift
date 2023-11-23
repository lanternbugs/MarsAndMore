//
//  TransitsView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 11/21/23.
//

import SwiftUI

struct TransitsView: View, AstrobotInterface {
    @State var transits: [TransitTime]
    @State var skyTransits: [TransitTime]
    @State var date: Date
    let chartName: String
    let transitData: TransitTimeData
    @EnvironmentObject private var manager: BirthDataManager
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button(action: previousDay) {
                        Text("<<").font(.title)
                    }
                    Spacer()
                    Text("\(date.getLongDateTitleString())").font(.title2)
                    Spacer()
                    Button(action: nextDay) {
                        Text(">>").font(.title)
                    }
                }
                HStack {
                    Text("Transits for \(chartName)").font(.title)
                    Spacer()
                }
                TransitTimesView(transits: $transits, transitToShow: .All)
                Text(" ")
                HStack {
                    Text("Planetary Transits").font(.title)
                    Spacer()
                }
                TransitTimesView(transits: $skyTransits, transitToShow: .Planetary)
                Text(" ")
                HStack {
                    Text("Moon Transits").font(.title)
                    Spacer()
                }
                TransitTimesView(transits: $skyTransits, transitToShow: .Moon)
            }
        }
    }
}
extension TransitsView {
    func previousDay() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: -1, to: date)
        if let newDate = newDate {
            skyTransits = getTransitTimes(start_time: newDate.getAstroTime(), end_time: date.getAstroTime(), manager: manager)
            transits = getNatalTransitTimes(start_time: newDate.getAstroTime(), end_time: date.getAstroTime(), manager: manager, transitTimeData: transitData)
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
                transits = getNatalTransitTimes(start_time: newDate.getAstroTime(), end_time: endDate.getAstroTime(), manager: manager, transitTimeData: transitData)
                date = newDate
            }
        }
    }
}
#Preview {
    TransitsView(transits: [], skyTransits: [], date: Date(), chartName: "none", transitData: TransitTimeData())
}

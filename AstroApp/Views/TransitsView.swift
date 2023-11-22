//
//  TransitsView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 11/21/23.
//

import SwiftUI

struct TransitsView: View {
    @State var transits: [TransitTime]
    @State var skyTransits: [TransitTime]
    @State var date: Date
    @EnvironmentObject private var manager: BirthDataManager
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Text("\(date.getLongDateTitleString())").font(.title2)
                    Spacer()
                }
                HStack {
                    Text("Transits").font(.title)
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

#Preview {
    TransitsView(transits: [], skyTransits: [], date: Date())
}

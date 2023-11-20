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
        return "\(transit.time)"
        /*
        var date = Date(timeIntervalSince1970: transit.time)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh a" // "a" prints "pm" or "am"
        let hourString = formatter.string(from: date)
        return "\(transit.time)"
         */
        
    }
}

#Preview {
    MundaneView(transits: [])
}

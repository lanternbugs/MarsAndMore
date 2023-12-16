/*
*  Copyright (C) 2022-23 Michael R Adams.
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
//  Created by Michael Adams on 11/19/23.
//

import SwiftUI

struct MundaneView: View, AstrobotInterface {
    @State var transits: [TransitTime]
    @State var date: Date
    @EnvironmentObject private var manager: BirthDataManager
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
                Text("\(date.getLongDateTitleString())").font(.title2)
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
                    TransitTimesView(transits: $transits, transitToShow: .Planetary)
                    Text(" ")
                    HStack {
                        Text("Moon Transits").font(.title)
                        Spacer()
                    }
                    TransitTimesView(transits: $transits, transitToShow: .Moon)
                }
            }
            
        }
        
    }
}

extension MundaneView {
    func previousDay() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: -1, to: date)
        if let newDate = newDate {
            transits = getTransitTimes(start_time: newDate.getAstroTime(), end_time: date.getAstroTime(), manager: manager)
            date = newDate
        }
    }
    
    func nextDay() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: 1, to: date)
        if let newDate = newDate {
            let endDate = calendar.date(byAdding: .day, value: 1, to: newDate)
            if let endDate = endDate {
                transits = getTransitTimes(start_time: newDate.getAstroTime(), end_time: endDate.getAstroTime(), manager: manager)
                date = newDate
            }
        }
    }
}


#Preview {
    MundaneView(transits: [], date: Date())
}

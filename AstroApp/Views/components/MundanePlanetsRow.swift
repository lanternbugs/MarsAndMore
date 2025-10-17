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

struct MundanePlanetsRow: View, AstrobotInterface {
    @Environment(\.roomState) private var roomState
    @EnvironmentObject private var savedDate: PlanetsDate
    @EnvironmentObject private var manager: BirthDataManager
    var body: some View {
        HStack(alignment: .top) {
            if let location = manager.planetsLocationData {
                Button(action: {
                    manager.planetsLocationData = nil
                    manager.savedCityCoordinates = ""
                }) {
                    Text("Remove City")
                }.padding(.leading)
                Text(" \(location.latitude) \(location.longitude)")
            } else {
                Button(action: {
                        roomState.wrappedValue = .PlanetsCity
                }) {
                    Text("+City")
                }.padding(.leading)
                
            }
            Spacer()
            Button(action: mundane) {
                Text("Mundane")
            }
            Spacer()
#if os(macOS)
            Button(action: { roomState.wrappedValue = .Ephemeris(date: savedDate.planetsDateChoice, calculationSettings: manager.calculationSettings) }) {
                Text("Ephemeris").font(Font.headline)
            }
            Spacer()
            Button(action: { roomState.wrappedValue = .SynastryChooser }) {
                Text("Partner").font(Font.headline)
            }.padding(.trailing)
            
            
#elseif os(iOS)  
            if idiom == .pad {
                Button(action: { roomState.wrappedValue = .Ephemeris(date: savedDate.planetsDateChoice, calculationSettings: manager.calculationSettings) }) {
                    Text("Ephemeris").font(Font.headline).padding(.trailing)
                }
                Spacer()
                Button(action: { roomState.wrappedValue = .SynastryChooser }) {
                    Text("Partner").font(Font.headline).padding(.trailing)
                }
            } else {
                Button(action: { roomState.wrappedValue = .Ephemeris(date: savedDate.planetsDateChoice, calculationSettings: manager.calculationSettings) }) {
                    Text("Ephemeris").font(Font.headline).padding(.trailing)
                }.padding(.trailing)
            }
#endif
            
        }
    }
}

extension MundanePlanetsRow {
    func mundane() {
        var start = savedDate.planetsDateChoice
        let calendar = Calendar.current
        start = calendar.startOfDay(for: start)
        let end = calendar.date(byAdding: .day, value: 1, to: start)
        if let end = end {
            roomState.wrappedValue = .Mundane(transits: getTransitTimes(start_time: start.getAstroTime(), end_time: end.getAstroTime(), manager: manager), date: start)
        }
    }
}

struct MundanePlanetsRow_Previews: PreviewProvider {
    static var previews: some View {
        MundanePlanetsRow()
    }
}
 
 /*
#Preview {
 MundanePlanetsRow()
 }
  */
 

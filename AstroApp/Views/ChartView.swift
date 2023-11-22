/*
*  Copyright (C) 2022 Michael R Adams.
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

import SwiftUI

struct ChartView: View {
    @Binding var data: [DisplayPlanetRow]
    @Environment(\.roomState) private var roomState
    @EnvironmentObject var manager:BirthDataManager
    
    var body: some View {
        
            VStack {
                ScrollView {
                    ScrollViewReader { value in
                        LazyVStack {
                            ForEach($data, id:\.id)
                            { $planetRow in
                                VStack {
                                    ChartTitle(planetRow: $planetRow)

                                    switch(planetRow.type) {
                                    case .Planets:
                                        PlanetsEntry(data: planetRow)
                                    case .Transits(let date, _, let time):
                                        Button(action: { showTransitsOfDay(date: time) }) {
                                            Text("Transits of Day").font(Font.subheadline)
                                        }
                                        Text("on \(date)")
                                        AspectsEntry(data: planetRow)
                                    case .Houses:
                                        HousesEntry(data: planetRow)
                                    default:
                                        AspectsEntry(data: planetRow)
                                    }
                                }
                                
                            }.onChange(of: data.count) { _ in
                                if data.count > 0 {
                                    value.scrollTo(data.count - 1)
                                }
                                
                            }.onChange(of: manager.selectedName) { _ in
                                if data.count > 0 {
                                    value.scrollTo(data.count - 1)
                                }
                            }
                        }
                        
                    }
                }
                
            }.padding(.vertical)
    } // end body
}

extension ChartView: AstrobotInterface {
    func showTransitsOfDay(date: Date) {
        var start = date
        let calendar = Calendar.current
        start = calendar.startOfDay(for: start)
        let end = calendar.date(byAdding: .day, value: 1, to: start)
        if let end = end {
            roomState.wrappedValue = .TransitsView(transits: [], skyTransits: getTransitTimes(start_time: start.getAstroTime(), end_time: end.getAstroTime(), manager: manager), date: start)
        }
        roomState.wrappedValue = .TransitsView(transits: [], skyTransits: [], date: Date())
    }
}

struct ChartView_Previews: PreviewProvider {
    @State static var state: RoomState = .Chart
    @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets, name: "Mike", calculationSettings: CalculationSettings())]
    static var previews: some View {
        ChartView(data: $row)
    }
}

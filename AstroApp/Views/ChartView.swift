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
                AstroButtons(data: $data)
                Divider()
                       .padding([.top, .bottom], 3)
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
                                    case .Transits(let date):
                                        Text("on \(date)")
                                        AspectsEntry(data: planetRow)
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

struct ChartView_Previews: PreviewProvider {
    @State static var state: RoomState = .Chart
    @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets, name: "Mike")]
    static var previews: some View {
        ChartView(data: $row)
    }
}

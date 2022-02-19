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
    @Binding var state: RoomState
    @EnvironmentObject var manager:BirthDataManager
    
    var body: some View {
        
            VStack {
                AstroButtons(data: $data)
                Divider()
                       .padding([.top, .bottom], 3)
                ScrollView {
                    LazyVStack {
                        ForEach($data, id:\.id)
                        { $planetRow in
                            
                            
                            VStack {
                                Text("\(planetRow.type.rawValue)  \(planetRow.name)").padding(.top).font(.headline)
                                switch(planetRow.type) {
                                case .Planets:
                                    PlanetsEntry(data: planetRow, state: $state)
                                default:
                                    AspectsEntry(data: planetRow)
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
        ChartView(data: $row, state: $state)
    }
}

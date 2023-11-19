/*
*  Copyright (C) 2022-2023 Michael R Adams.
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

struct PlanetRoom: View {
    @Binding var data: [DisplayPlanetRow]
    var body: some View {
        VStack {
            PlanetButtons(data: $data).padding([.top], 20)
            MundanePlanetsRow()
            Divider().padding([.top, .bottom], 3)
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
                                case .Transits(let date, _):
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
                            
                        }
                    }
                }
            }
        }
    }
}

struct PlanetRoom_Previews: PreviewProvider {
    @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets, name: "Mike", calculationSettings: CalculationSettings())]
    static var previews: some View {
        PlanetRoom(data: $row)
    }
}

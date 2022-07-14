//
//  PlanetRoom.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/13/22.
//

import SwiftUI

struct PlanetRoom: View {
    @Binding var data: [DisplayPlanetRow]
    var body: some View {
        VStack {
            PlanetButtons(data: $data)
            Divider().padding([.top, .bottom], 3)
            ScrollView {
                ScrollViewReader { value in
                    LazyVStack {
                        ForEach($data, id:\.id)
                        { $planetRow in
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
                    }
                }
            }
        }
    }
}

struct PlanetRoom_Previews: PreviewProvider {
    @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets, name: "Mike")]
    static var previews: some View {
        PlanetRoom(data: $row)
    }
}

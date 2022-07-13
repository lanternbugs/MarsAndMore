//
//  ChartTitle.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/13/22.
//

import SwiftUI

struct ChartTitle: View {
    @Binding var planetRow: DisplayPlanetRow
    var body: some View {
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text("\(planetRow.type.getName())  \(planetRow.name)").textSelection(.enabled).padding(.top).font(.headline)
            }
            else {
                Text("\(planetRow.type.getName())  \(planetRow.name)").padding(.top).font(.headline)
                }
#else
            if #available(iOS 15.0, *) {
                Text("\(planetRow.type.getName())  \(planetRow.name)").textSelection(.enabled).padding(.top).font(.headline)
            }
            else {
                Text("\(planetRow.type.getName())  \(planetRow.name)").padding(.top).font(.headline)
                }
#endif
    }
}

struct ChartTitle_Previews: PreviewProvider {
    @State static var row: DisplayPlanetRow = DisplayPlanetRow(planets: [], id: 0, type: .Planets, name: "mike")
    static var previews: some View {
        ChartTitle(planetRow: $row)
    }
}

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

struct ChartTitle: View {
    @Binding var planetRow: DisplayPlanetRow
    var planetRowText: String  {
        var title = "none"
        switch planetRow.type {
        case .Planets, .Houses:
            title = planetRow.calculationSettings.tropical ? "\(planetRow.type.getName())  \(planetRow.name)" : "\(planetRow.type.getName())  \(planetRow.name) \(planetRow.calculationSettings.siderealSystem.getName())"
        default:
           title =  "\(planetRow.type.getName())  \(planetRow.name)"
            
        }
        return title
    }

    var body: some View {
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text(planetRowText).textSelection(.enabled).padding(.top).font(.headline)
            }
            else {
                Text(planetRowText).padding(.top).font(.headline)
                }
#else
            if #available(iOS 15.0, *) {
                Text(planetRowText).textSelection(.enabled).padding(.top).font(.headline)
            }
            else {
                Text(planetRowText).padding(.top).font(.headline)
                }
#endif
    }
}

struct ChartTitle_Previews: PreviewProvider {
    @State static var row: DisplayPlanetRow = DisplayPlanetRow(planets: [], id: 0, type: .Planets(chartModel: NatalChartViewModel(chartName: "mike")), name: "mike", calculationSettings: CalculationSettings())
    static var previews: some View {
        ChartTitle(planetRow: $row)
    }
}

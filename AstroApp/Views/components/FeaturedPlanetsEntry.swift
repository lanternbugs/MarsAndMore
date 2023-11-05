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

struct FeaturedPlanetsEntry: View {
    @Environment(\.roomState) private var roomState
    let marsData: PlanetCell
    let venusData: PlanetCell
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                roomState.wrappedValue = .Reading(planet: venusData.planet, sign: venusData.sign)
            }) {
                Text("\(venusData.planet.getName())")
                
            }.layoutPriority(1)
            Text(" \(venusData.degree) ")
#if os(iOS)
            UIDevice.isIPhone ? Text(" \(venusData.sign.getNameShort())") : Text(" \(venusData.sign.getName())")
#else
            Text(" \(venusData.sign.getName())")
#endif
            if venusData.retrograde {
                Text(" R ")
            }
            Spacer()
            
            Button(action: {
                roomState.wrappedValue = .Reading(planet: marsData.planet, sign: marsData.sign)
            }) {
                Text("\(marsData.planet.getName())")
                
            }.layoutPriority(1)
            Text(" \(marsData.degree) ")
#if os(iOS)
            UIDevice.isIPhone ? Text(" \(marsData.sign.getNameShort())") : Text(" \(marsData.sign.getName())")
#else
            Text(" \(marsData.sign.getName())")
#endif
            
            if marsData.retrograde {
                Text(" R ")
            }
            Spacer()
        }
    }
}

struct FeaturedPlanetsEntry_Previews: PreviewProvider {
    static var previews: some View {
        let mars = PlanetCell(planet: Planets.Mars, degree: "0", sign: Signs.Scorpio,  retrograde: false)
        let venus = PlanetCell(planet: Planets.Venus, degree: "0", sign: Signs.Scorpio,  retrograde: false)
        FeaturedPlanetsEntry(marsData: mars, venusData: venus)
    }
}

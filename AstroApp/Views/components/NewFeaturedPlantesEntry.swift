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

struct NewFeaturedPlanetsEntry: View {
    @Environment(\.roomState) private var roomState
    let sunData: PlanetCell
    let moonData: PlanetCell
    let mercuryData: PlanetCell
    
    var body: some View {
        HStack {
#if os(macOS)
            Spacer()
#endif
            Button(action: {
                roomState.wrappedValue = .Reading(planet: sunData.planet, sign: sunData.sign)
            }) {
                Text("\(sunData.planet.getName())")
                
            }.layoutPriority(1)
            Text(" \(sunData.degree) ")
#if os(iOS)
            UIDevice.isIPhone ? Text(" \(sunData.sign.getNameShort())") : Text(" \(sunData.sign.getName())")
#else
            Text(" \(sunData.sign.getName())")
#endif
            
            if sunData.retrograde {
                Text(" R ")
            }
            Spacer()
            
            Button(action: {
                roomState.wrappedValue = .Reading(planet: moonData.planet, sign: moonData.sign)
            }) {
                Text("\(moonData.planet.getName())")
                
            }.layoutPriority(1)
            Text(" \(moonData.degree) ")
#if os(iOS)
            UIDevice.isIPhone ? Text(" \(moonData.sign.getNameShort())") : Text(" \(moonData.sign.getName())")
#else
            Text(" \(moonData.sign.getName())")
#endif
            if moonData.retrograde {
                Text(" R ")
            }
            Spacer()
            Button(action: {
                roomState.wrappedValue = .Reading(planet: mercuryData.planet, sign: mercuryData.sign)
            }) {
                Text("\(mercuryData.planet.getName())")
                
            }.layoutPriority(1)
            Text(" \(mercuryData.degree) ")
#if os(iOS)
            UIDevice.isIPhone ? Text(" \(mercuryData.sign.getNameShort())") : Text(" \(mercuryData.sign.getName())")
#else
            Text(" \(mercuryData.sign.getName())")
#endif
            
            if mercuryData.retrograde {
                Text(" R ")
            }
#if os(macOS)
            Spacer()
#endif
        }
    }
}

struct NewFeaturedPlanetsEntry_Previews: PreviewProvider {
    static var previews: some View {
        let sun = PlanetCell(planet: Planets.Mars, degree: "0", sign: Signs.Scorpio,  retrograde: false)
        let moon = PlanetCell(planet: Planets.Venus, degree: "0", sign: Signs.Scorpio,  retrograde: false)
        let mercury = PlanetCell(planet: Planets.Venus, degree: "0", sign: Signs.Scorpio,  retrograde: false)
        NewFeaturedPlanetsEntry(sunData: sun, moonData: moon, mercuryData: mercury)
    }
}

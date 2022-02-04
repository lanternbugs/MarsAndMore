//
//  FeaturedPlanetsEntry.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/3/22.
//

import SwiftUI

struct FeaturedPlanetsEntry: View {
    @Binding var state: ReadingState
    let marsData: PlanetCell
    let venusData: PlanetCell
    var body: some View {
        HStack {
#if os(macOS)
            Spacer()
#endif
            Button(action: {
                state = .Reading(planet: marsData.planet, sign: marsData.sign)
            }) {
                Text("\(marsData.planet.getName())")
                
            }.layoutPriority(1)
            Text(" \(marsData.degree) ")
#if os(iOS)
            UIDevice.isIPhone ? Text(" \(marsData.sign.getNameShort())") : Text(" \(marsData.sign.getName())")
#else
            Text(" \(marsData.sign.getName())")
#endif
            
            
            Button(action: {
                state = .Reading(planet: venusData.planet, sign: venusData.sign)
            }) {
                Text("\(venusData.planet.getName())")
                
            }.layoutPriority(1)
            Text(" \(venusData.degree) ")
#if os(iOS)
            UIDevice.isIPhone ? Text(" \(venusData.sign.getNameShort())") : Text(" \(venusData.sign.getName())")
#else
            Text(" \(venusData.sign.getName())")
#endif
#if os(macOS)
            Spacer()
#endif
        }
    }
}

struct FeaturedPlanetsEntry_Previews: PreviewProvider {
    @State static var state: ReadingState = .Chart
    static var previews: some View {
        let mars = PlanetCell(type: PlanetFetchType.planets, planet: Planets.Mars, sign: Signs.Scorpio, degree: "0")
        let venus = PlanetCell(type: PlanetFetchType.planets, planet: Planets.Venus, sign: Signs.Scorpio, degree: "0")
        FeaturedPlanetsEntry(state: $state, marsData: mars, venusData: venus)
    }
}

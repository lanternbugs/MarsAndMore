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
            Spacer()
            Button(action: {
                state = .Reading(planet: marsData.planet, sign: marsData.sign)
            }) {
                HStack {
                    Text("\(marsData.planet.getName())")
                }
                
            }
            Text(" \(marsData.degree) ")
            Text(" \(marsData.sign.getName())")
            Spacer()
            Button(action: {
                state = .Reading(planet: venusData.planet, sign: venusData.sign)
            }) {
                HStack {
                    Text("\(venusData.planet.getName())")
                }
                
            }
            Text(" \(venusData.degree) ")
            Text(" \(venusData.sign.getName())")
            Spacer()
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

//
//  PlanetsEntry.swift
//  MarsAndMore (iOS)
//
//  Created by Michael Adams on 2/2/22.
//

import SwiftUI

struct PlanetsEntry: View {
    let data: PlanetRow
    @Binding var state: ReadingState
    
    var venusData: PlanetCell? {
        nil
    }
    var regularPlanets: [PlanetCell] {
        if let planets: [PlanetCell]  = data.planets as? [PlanetCell] {
            return  planets.filter { planet in
                planet.planet != Planets.Mars && planet.planet != Planets.Venus
            }
        }
       return [PlanetCell]()
    }
    
    var body: some View {
        VStack {
            if let mars = getData(planet: .Mars) , let venus = getData(planet: .Venus) {
                FeaturedPlanetsEntry(state: $state, marsData: mars, venusData: venus)
            }
          
            Text(rowFromPlanets(row: regularPlanets))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
            
    }
}

extension PlanetsEntry {
    func rowFromPlanets(row: [PlanetCell])->String {
        var rowString = ""
        for val in row {
            rowString += val.planet.getName() + " " + val.degree + " " + val.sign.getNameShort() + " "
        }
        return rowString
    }
    func getData(planet: Planets) -> PlanetCell? {
        if let planets: [PlanetCell]  = data.planets as? [PlanetCell] {
            for val in planets {
                switch(val.planet) {
                case planet:
                    return val
                default:
                    continue
                }
            }
        }
        return nil
    }
}


struct PlanetsEntry_Previews: PreviewProvider {
    @State static var state: ReadingState = .Chart
    static var previews: some View {
        let row = PlanetRow(id: 0)
        PlanetsEntry(data: row, state: $state)
    }
}

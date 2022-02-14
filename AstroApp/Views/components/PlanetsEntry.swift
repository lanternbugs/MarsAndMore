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

struct PlanetsEntry: View {
    let data: DisplayPlanetRow
    @Binding var state: RoomState
    
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
    @State static var state: RoomState = .Chart
    static var previews: some View {
        let row = DisplayPlanetRow(planets: [], id: 0)
        PlanetsEntry(data: row, state: $state)
    }
}
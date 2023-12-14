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
    @Environment(\.roomState) private var roomState
    @EnvironmentObject private var manager: BirthDataManager
    
    var venusData: PlanetCell? {
        nil
    }
    var regularPlanets: [PlanetCell] {
        if let planets: [PlanetCell]  = data.planets as? [PlanetCell] {
            return  planets.filter { planet in
                planet.planet != Planets.Mars && planet.planet != Planets.Venus &&
                planet.planet != Planets.Sun && planet.planet != Planets.Moon &&
                planet.planet != Planets.Mercury
            }
        }
       return [PlanetCell]()
    }
    
    var allPlanets: [PlanetCell] {
        if let planets = data.planets as? [PlanetCell] {
            return planets
            
        } else {
            return []
        }
        
    }
    
    var body: some View {
        VStack {
            if manager.showPlanetReadingButtons  {
                if let sun = getData(planet: .Sun), let moon = getData(planet: .Moon), let mercury = getData(planet: .Mercury) {
                    NewFeaturedPlanetsEntry(sunData: sun, moonData: moon, mercuryData: mercury)
                }
                if let mars = getData(planet: .Mars) , let venus = getData(planet: .Venus) {
                    FeaturedPlanetsEntry(marsData: mars, venusData: venus)
                }
                    
    #if os(macOS)
                if #available(macOS 12.0, *) {
                    Text(rowFromPlanets(row: regularPlanets))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                else {
                    Text(rowFromPlanets(row: regularPlanets))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
    #else
                if #available(iOS 15.0, *) {
                    Text(rowFromPlanets(row: regularPlanets))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                else {
                    Text(rowFromPlanets(row: regularPlanets))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
    #endif
                
            } else {
                
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text(rowFromPlanets(row: allPlanets))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            else {
                Text(rowFromPlanets(row: allPlanets))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
#else
            if #available(iOS 15.0, *) {
                Text(rowFromPlanets(row: allPlanets))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            else {
                Text(rowFromPlanets(row: allPlanets))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
#endif
            }
            
        }
            
    }
}

extension PlanetsEntry {
    func rowFromPlanets(row: [PlanetCell])->String {
        var rowString = ""
        for val in row {
            if manager.bodiesToShow.contains(val.planet) {
                rowString += val.planet.getName() + " " + val.degree + " " + val.sign.getNameShort()
                rowString += val.retrograde ? " R; " : "; "
            }
            
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
    static var previews: some View {
        let row = DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets(chartModel: NatalChartViewModel(chartName: "mike")), name: "Mike", calculationSettings: CalculationSettings())
        PlanetsEntry(data: row)
    }
}

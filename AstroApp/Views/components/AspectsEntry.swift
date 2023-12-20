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

struct AspectsEntry: View {
    let data: DisplayPlanetRow
    @EnvironmentObject private var manager: BirthDataManager
    var displayString: String {
        var display = ""
        if let transitData = data.planets as? [TransitCell] {
            for val in transitData {
                
                if manager.bodiesToShow.contains(val.planet) && manager.bodiesToShow.contains(val.planet2) && showAspect(aspect: val.aspect)
                {
                    if display.count > 0 {
                        display += "; "
                    }
                    if val.movement == .Applying {
                        display += val.movement.rawValue + " "
                    }
                    display += val.planet.getName() + " " + val.aspect.getName() + " " + val.planet2.getName() + " " + val.degree
                }
                
            }
            return display
        }
        
        return "No Aspects"
    }
    @ViewBuilder
    var body: some View {
        
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text(displayString).textSelection(.enabled).padding([.top,.bottom])
            }
            else {
                Text(displayString).padding([.top,.bottom])
                }
#else
            if #available(iOS 15.0, *) {
                Text(displayString).textSelection(.enabled).padding([.top,.bottom])
            }
            else {
                Text(displayString).padding([.top,.bottom])
                }
#endif
    }
}
extension AspectsEntry {
    func showAspect(aspect: Aspects) -> Bool {
        if manager.showMinorAspects  {
            return true
        }
        if aspect.isMajor() {
            return true
        }
        return false
    }
}


struct AspectsEntry_Previews: PreviewProvider {
    
    static var previews: some View {
        let row = DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets(chartModel: ChartViewModel(chartName: "mike", chartType: .Natal)), name: "Mike", calculationSettings: CalculationSettings())
        AspectsEntry(data: row)
    }
}

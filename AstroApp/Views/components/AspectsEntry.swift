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
    var majorDisplayString: String {
        var display = ""
        if let transitData = data.planets as? [TransitCell] {
            for val in transitData {
                if manager.bodiesToShow.contains(val.planet) && manager.bodiesToShow.contains(val.planet2) && val.aspect.isMajor()
                {
                    display += getTransitString(val: val, count: display.count)
                }
            }
            return display
        }
        return "No Aspects"
    }
    var minorDisplayString: String {
        var display = ""
        if let transitData = data.planets as? [TransitCell] {
            for val in transitData {
                if manager.bodiesToShow.contains(val.planet) && manager.bodiesToShow.contains(val.planet2) && showAspect(aspect: val.aspect) && !val.aspect.isMajor()
                {
                    display += getTransitString(val: val, count: display.count)
                }
            }
            return display
        }
        return "No Minor Aspects"
    }
    @ViewBuilder
    var body: some View {
        
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text(majorDisplayString).textSelection(.enabled).padding([.top,.bottom])
                if manager.showMinorAspects {
                    Text("Minor").font(.headline)
                    Text(minorDisplayString).textSelection(.enabled).padding([.top,.bottom])
                }
            }
            else {
                Text(majorDisplayString).padding([.top,.bottom])
                if manager.showMinorAspects {
                    Text("Minor").font(.headline)
                    Text(minorDisplayString).padding([.top,.bottom])
                }
            }
        
#else
            if #available(iOS 15.0, *) {
                Text(majorDisplayString).textSelection(.enabled).padding([.top,.bottom])
                if manager.showMinorAspects {
                    Text("Minor").font(.headline)
                    Text(minorDisplayString).textSelection(.enabled).padding([.top,.bottom])
                }
            }
            else {
                Text(majorDisplayString).padding([.top,.bottom])
                if manager.showMinorAspects {
                    Text("Minor").font(.headline)
                    Text(minorDisplayString).padding([.top,.bottom])
                }
            }
#endif
    }
}
extension AspectsEntry {
    func showAspect(aspect: Aspects) -> Bool {
        if manager.showMinorAspects && manager.aspectsToShow.contains(aspect)  {
            return true
        }
        if aspect.isMajor() {
            return true
        }
        return false
    }
    
    func getTransitString(val: TransitCell, count: Int) -> String {
        var display = ""
        if count > 0 {
            display += "; "
        }
        if val.movement == .Applying {
            display += val.movement.rawValue + " "
        }
        display += val.planet.getName() + " " + val.aspect.getName() + " " + val.planet2.getName() + " " + val.degree
        return display
    }
}


struct AspectsEntry_Previews: PreviewProvider {
    
    static var previews: some View {
        let row = DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets(viewModel: ChartViewModel(model: WheelChartModel(chartName: "mike", chart: .Natal, manager: BirthDataManager()))), name: "Mike", calculationSettings: CalculationSettings())
        AspectsEntry(data: row)
    }
}

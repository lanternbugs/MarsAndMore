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
    var displayString: String {
        var display = ""
        if let transitData = data.planets as? [TransitCell] {
            for val in transitData {
                if display.count > 0 {
                    display += " "
                }
                display += val.planet.getName() + " " + val.aspect.getName() + " " + val.planet2.getName() + " " + val.degree
            }
            return display
        }
        
        return "No Aspects"
    }
    var body: some View {
        
        Text(displayString).padding([.top,.bottom])
    }
}

struct AspectsEntry_Previews: PreviewProvider {
    
    static var previews: some View {
        let row = DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets, name: "Mike")
        AspectsEntry(data: row)
    }
}
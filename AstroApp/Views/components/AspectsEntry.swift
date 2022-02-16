//
//  AspectsEntry.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/16/22.
//

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
        let row = DisplayPlanetRow(planets: [], id: 0)
        AspectsEntry(data: row)
    }
}

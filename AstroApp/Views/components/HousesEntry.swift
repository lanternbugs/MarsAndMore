//
//  HousesEntry.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/1/22.
//

import SwiftUI

struct HousesEntry: View {
    let data: DisplayPlanetRow
    @EnvironmentObject private var manager: BirthDataManager
    var displayString: String {
        var display = ""
        if let houseData = data.planets as? [HouseCell] {
            for val in houseData {
                display += val.house.getHouseShortName() + ": " + val.degree + " " + val.sign.getNameShort() + "; "
            }
          return display
        }
        
        return "No Houses"
    }
    var body: some View {
        Text(displayString)
    }
}

struct HousesEntry_Previews: PreviewProvider {
    static var previews: some View {
        let row = DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets, name: "Mike")
        HousesEntry(data: row)
    }
}
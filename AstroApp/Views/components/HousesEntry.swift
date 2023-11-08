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
#if os(macOS)
        if #available(macOS 12.0, *) {
            Text(displayString).textSelection(.enabled)
        } else {
            Text(displayString)
        }
        
#else
        if #available(iOS 15.0, *) {
            Text(displayString).textSelection(.enabled)
        } else {
            Text(displayString)
        }
#endif
    }
}

struct HousesEntry_Previews: PreviewProvider {
    static var previews: some View {
        let row = DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets, name: "Mike", calculationSettings: CalculationSettings())
        HousesEntry(data: row)
    }
}

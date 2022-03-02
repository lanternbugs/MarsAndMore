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

struct AstroButtons: View, AstrobotInterface {
    
    @EnvironmentObject private var manager: BirthDataManager
    @Binding var data: [DisplayPlanetRow]
    var body: some View {
        HStack(alignment: .top) {
            Spacer()
            Button(action: planets) {
                Text("Planets")
            }
            Spacer()
            Button(action: aspects) {
                Text("Aspects")
            }
            Spacer()
            Button(action: transits) {
                Text("Transits")
            }
            Spacer()
        }
    }
}
extension AstroButtons {
    func planets()
    {
        let row = getPlanets(time: getTime(), location: getLocation())
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.count, type: .Planets, name: manager.getCurrentName())
        data.append(displayRow)
    }
    
    func aspects()
    {
        getAspectTransitData(type: .Aspects)
    }
    
    func transits()
    {
        getAspectTransitData(type: .Transits)
    }
    
    func getAspectTransitData(type: PlanetFetchType) {
        let row = getAspects(time: getTime(), type: type)
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.count, type: type, name: manager.getCurrentName())
        data.append(displayRow)
    }
    
    func getTime()->Double {
        if let index = manager.selectedName {
            let data = manager.birthDates.first {
                $0.id == index
            }
            guard let data = data else {
                return Date().getAstroTime()
            }
            return data.getAstroTime()
        }
        return Date().getAstroTime()
    }
    
    func getLocation()->LocationData?
    {
        if let index = manager.selectedName {
            let data = manager.birthDates.first {
                $0.id == index
            }
            guard let data = data else {
                return nil
            }
            return data.location
        }
        return nil
    }
}
struct AstroButtons_Previews: PreviewProvider {
    @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets, name: "Mike")]
    static var previews: some View {
        AstroButtons(data: $row)
    }
}

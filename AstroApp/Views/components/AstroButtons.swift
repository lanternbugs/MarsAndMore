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
    @ViewBuilder
    var body: some View {
        VStack {
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
            }
            if let _ = manager.selectedName {
                TransitsButtonControl()
            }
        }
        
    }
}
extension AstroButtons {
    func planets()
    {
        let row = getPlanets(time: manager.getSelectionTime(), location: manager.getSelectionLocation())
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.count, type: .Planets, name: manager.getCurrentName())
        data.append(displayRow)
    }
    
    func aspects()
    {
        let row = getAspects(time: manager.getSelectionTime(), with: nil)
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.count, type: .Aspects, name: manager.getCurrentName())
        data.append(displayRow)
    }
}
struct AstroButtons_Previews: PreviewProvider {
    @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets, name: "Mike")]
    static var previews: some View {
        AstroButtons(data: $row)
    }
}

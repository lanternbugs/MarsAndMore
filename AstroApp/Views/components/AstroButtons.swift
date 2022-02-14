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
        let row = getPlanets(time: Date().getAstroTime())
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.count)
        data.append(displayRow)
    }
    
    func aspects()
    {
        
    }
    func transits()
    {
        
    }
}
struct AstroButtons_Previews: PreviewProvider {
    @State static var row = [DisplayPlanetRow(planets: [], id: 0)]
    static var previews: some View {
        AstroButtons(data: $row)
    }
}
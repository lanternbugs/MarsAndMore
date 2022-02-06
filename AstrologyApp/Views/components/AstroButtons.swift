//
//  AstroButtons.swift
//  MarsAndMore (iOS)
//
//  Created by Michael Adams on 2/2/22.
//

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

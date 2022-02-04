//
//  AstroButtons.swift
//  MarsAndMore (iOS)
//
//  Created by Michael Adams on 2/2/22.
//

import SwiftUI

struct AstroButtons: View, AstrobotInterface {
    
    @Binding var data: [PlanetRow]
    var body: some View {
        HStack {
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
        data.append(getPlanets(id: data.count))
    }
    
    func aspects()
    {
        
    }
    func transits()
    {
        
    }
}
struct AstroButtons_Previews: PreviewProvider {
    @State static var row = [PlanetRow(id: 0)]
    static var previews: some View {
        AstroButtons(data: $row)
    }
}

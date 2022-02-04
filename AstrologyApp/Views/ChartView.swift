//
//  ChartView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

import SwiftUI

struct ChartView: View {
    @Binding var data: [PlanetRow]
    @Binding var state: ReadingState
    
    var body: some View {
        
            VStack {
                AstroButtons(data: $data)
                ScrollView {
                    VStack {
                        ForEach($data, id:\.id)
                        { $planetRow in
                            PlanetsEntry(data: planetRow, state: $state)
                        }
                    }
                }
                
            }
#if os(iOS)
            .frame(width: UIScreen.main.bounds.size.width * 2.7 / 4.0, alignment: .leading)
#elseif os(macOS)
        
#endif
            
        
    } // end body
}

struct ChartView_Previews: PreviewProvider {
    @State static var state: ReadingState = .Chart
    @State static var row = [PlanetRow(id: 0)]
    static var previews: some View {
        ChartView(data: $row, state: $state)
    }
}

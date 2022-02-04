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
                Divider()
                       .padding([.top, .bottom], 3)
                ScrollView {
                    LazyVStack {
                        ForEach($data, id:\.id)
                        { $planetRow in
                            PlanetsEntry(data: planetRow, state: $state)
                        }
                    }
                }
                
            }.padding(.vertical)
    } // end body
}

struct ChartView_Previews: PreviewProvider {
    @State static var state: ReadingState = .Chart
    @State static var row = [PlanetRow(id: 0)]
    static var previews: some View {
        ChartView(data: $row, state: $state)
    }
}

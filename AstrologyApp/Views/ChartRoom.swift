//
//  ChartRoom.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

import SwiftUI

struct ChartRoom: View {
    @State var readingState: ReadingState = .Chart
    @State var planetData: [PlanetRow] = Array<PlanetRow>()
    @ViewBuilder
    var body: some View {
        switch(readingState) {
        case .Reading:
            ReadingView(state: $readingState)
        default:
            HStack {
                ChartView(data: $planetData, state: $readingState)
                Divider()
                       .padding([.leading, .trailing], 3)
                NamesView()
            }
        }
    }
}

struct ChartRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChartRoom()
    }
}

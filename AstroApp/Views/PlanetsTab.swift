//
//  PlanetsView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/12/22.
//

import SwiftUI

struct PlanetsTab: View {
    @Environment(\.roomState) private var roomState
    @EnvironmentObject var manager: BirthDataManager
    @State private var data: [DisplayPlanetRow] = Array<DisplayPlanetRow>()
    @ViewBuilder
    var body: some View {
        switch(roomState.wrappedValue) {
        case .Reading:
            VStack {
                DoneView(newRoomState: .Chart)
                ReadingView(state: roomState)
            }
        case .ChartSettings:
            VStack {
                DoneView(newRoomState: .Chart)
                ChartSettings()
            }
        default:
            PlanetRoom(data: $data)
            
        }
    }
}

struct PlanetsTab_Previews: PreviewProvider {
    static var previews: some View {
        PlanetsTab()
    }
}

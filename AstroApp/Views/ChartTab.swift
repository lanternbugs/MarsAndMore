//
//  ChartTab.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/11/22.
//

import SwiftUI

struct ChartTab: View {
    @State private var roomState: RoomState = .Chart
    @State var name: String = ""
    @State var date: Date = Date(timeIntervalSince1970: 0)
    @State var exactTime: Bool = false
    @ViewBuilder
    var body: some View {
        switch(roomState) {
        case .Reading:
            VStack {
                DoneView(state: $roomState, newRoomState: .Chart)
                ReadingView(state: $roomState)
            }
            
        case .Cities:
            VStack {
                DoneView(state: $roomState, newRoomState: .Names)
                CitiesView(state: $roomState)
            }
             
        case .Names:
            VStack {
                DoneView(state: $roomState, newRoomState: .Chart)
                NameDataView(state: $roomState,
                             name: $name, birthdate: $date, exactTime: $exactTime)
            }
            
        default:
            ChartRoom(readingState: $roomState)
            
        }
    }
}

struct ChartTab_Previews: PreviewProvider {
    static var previews: some View {
        ChartTab()
    }
}

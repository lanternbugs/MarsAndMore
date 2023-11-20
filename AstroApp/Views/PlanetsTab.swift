/*
*  Copyright (C) 2022-2023 Michael R Adams.
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

struct PlanetsTab: View {
    @Environment(\.roomState) private var roomState
    @State private var data: [DisplayPlanetRow] = Array<DisplayPlanetRow>()
    @ViewBuilder
    var body: some View {
        switch(roomState.wrappedValue) {
        case .Reading:
            VStack {
                DoneView(newRoomState: .Planets)
                ReadingView(state: roomState)
            }
        case .ChartSettings:
            VStack {
                DoneView(newRoomState: .Planets)
                ChartSettings()
            }
        case .Mundane(let transits):
            VStack {
                DoneView(newRoomState: .Planets)
                MundaneView(transits: transits)
            }
        default:
            PlanetRoom(data: $data, roomState: roomState)
            
        }
    }
}

struct PlanetsTab_Previews: PreviewProvider {
    static var previews: some View {
        PlanetsTab()
    }
}

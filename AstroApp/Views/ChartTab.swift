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

struct ChartTab: View {
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
            
        case .Cities:
            VStack {
                DoneView(newRoomState: .Names)
                CitiesView()
            }
        case .UpdateCity:
            VStack {
                DoneView(newRoomState: .EditName)
                CitiesView()
            }
        case .Names, .EditName:
            VStack {
                DoneView(newRoomState: .Chart)
                NameDataView()
            }
        case .ChartSettings:
            VStack {
                DoneView(newRoomState: .Chart)
                ChartSettings()
            }
        case .Resources:
            VStack {
                DoneView(newRoomState: .Chart)
                ResourcesView()
            }
        case .TransitsView(let transits, let skyTransits, let date):
            VStack {
                DoneView(newRoomState: .Chart)
                TransitsView(transits: transits, skyTransits: skyTransits, date: date)
            }
        default:
            ChartRoom(planetData: $data)
            
        }
    }
}
extension ChartTab {
    
}
struct ChartTab_Previews: PreviewProvider {
    static var previews: some View {
        ChartTab()
    }
}

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
    @EnvironmentObject var manager: BirthDataManager
    @State private var data: [DisplayPlanetRow] = Array<DisplayPlanetRow>()
    @ViewBuilder
    var body: some View {
        VStack {
            switch(roomState.wrappedValue) {
            case .Reading:
                DoneView(newRoomState: .Planets)
                ReadingView(state: roomState)
            case .ChartSettings:
                DoneView(newRoomState: .Planets)
                ChartSettings()
            case .Mundane(let transits, let date):
                DoneView(newRoomState: .Planets)
                MundaneView(viewModel: TransitMundaneViewModel(transits: [], skyTransits: transits, transitData: nil, date: date, manager: manager))
            case .NatalView(let dismissal, let viewModel):
                DoneView(newRoomState: dismissal)
                WheelChartView(viewModel: viewModel)
            case .Cities(let onDismiss):
                DoneView(newRoomState: .Names(onDismiss: onDismiss))
                CitiesView(dismissView: onDismiss)
            case .PlanetsCity:
                DoneView(newRoomState: .Planets)
                CitiesView()
            case .About:
                DoneView(newRoomState: .ChartSettings)
                ReadingView(state: roomState)
            case .Names(let onDismiss), .EditName(let onDismiss):
                DoneView(newRoomState: onDismiss)
                NameDataView(dismissView: onDismiss)
            case .SynastryChooser:
                DoneView(newRoomState: .Planets)
                if manager.birthDates.count < 2 {
                    SynastryChooserView(selectedNameOne: "mike", selectedNameTwo: "jane")
                } else {
                    SynastryChooserView(selectedNameOne: manager.birthDates[0].name, selectedNameTwo: manager.birthDates[1].name)
                }
            default:
                PlanetRoom(data: $data, roomState: roomState)
            }
        }
    }
}

struct PlanetsTab_Previews: PreviewProvider {
    static var previews: some View {
        PlanetsTab()
    }
}

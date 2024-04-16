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
            
        case .Cities(let onDismiss):
            VStack {
                DoneView(newRoomState: .Names(onDismiss: onDismiss))
                CitiesView(dismissView: onDismiss)
            }
        case .PlanetsCity:
            VStack {
                DoneView(newRoomState: .Planets)
                CitiesView()
            }
        case .UpdateCity:
            VStack {
                DoneView(newRoomState: .EditName(onDismiss: .Chart))
                CitiesView()
            }
        case .Names(let onDismiss), .EditName(let onDismiss):
            VStack {
                DoneView(newRoomState: onDismiss)
                NameDataView(dismissView: onDismiss)
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
        case .TransitsView(let transits, let skyTransits, let date, let chartName, let transitData):
            VStack {
                DoneView(newRoomState: .Chart)
                TransitsView(viewModel: TransitMundaneViewModel(transits: transits, skyTransits: skyTransits, transitData: transitData, date: date, manager: manager),  chartName: chartName)
            }
        case .NatalView(let dismissal, let viewModel):
            VStack {
                DoneView(newRoomState: dismissal)
                WheelChartView(viewModel: viewModel)
            }
        case .About:
            VStack {
                DoneView(newRoomState: .ChartSettings)
                ReadingView(state: roomState)
            }
        case .SynastryChooser:
            VStack {
                DoneView(newRoomState: .Chart)
                if manager.birthDates.count < 2 {
                    SynastryChooserView(selectedNameOne: "mike", selectedNameTwo: "jane")
                } else {
                    SynastryChooserView(selectedNameOne: manager.birthDates[0].name, selectedNameTwo: manager.birthDates[1].name)
                }
                
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

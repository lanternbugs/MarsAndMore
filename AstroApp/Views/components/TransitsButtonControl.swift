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

struct TransitsButtonControl: View {
    
    @EnvironmentObject private var manager: BirthDataManager
    @Environment(\.roomState) private var roomState
    @State private var transitDate: Date = Date()
    @ObservedObject var viewModel: AstroPlanetButtonsViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: transits) {
                    Text("Transits")
                }
                Spacer()
                
                Text("\(manager.getCurrentName() )")
                Spacer()
                
                if let num = manager.selectedName,  manager.birthDates[num].location != nil
                {
                    Button(action: houses) {
                        Text("Chart Wheel")
                    }
                    Spacer()
                }
            }
            DatePicker(
              "On",
              selection: $transitDate,
              displayedComponents: [.date, .hourAndMinute]
            ).datePickerStyle(DefaultDatePickerStyle())
        }
        
    }
}

extension TransitsButtonControl {
    func houses() {
        if let vModel = viewModel.houses() {
            vModel.model.transitTime = vModel.model.originalTransitTime
            manager.chartTabChartJumpedInTime = false
            vModel.resetData()
            roomState.wrappedValue = .NatalView(onDismiss: .Chart, viewModel: vModel)
        }
    }
    
    func transits() {
        viewModel.transits(transitDate: transitDate)
    }
}

struct TransitsButtonControl_Previews: PreviewProvider {
    @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets(viewModel: ChartViewModel(model: WheelChartModel(chartName: "mike", chart: .Natal, manager: BirthDataManager()))), name: "Mike", calculationSettings: CalculationSettings())]
    static var previews: some View {
        TransitsButtonControl(viewModel: AstroPlanetButtonsViewModel(data: $row, manager: BirthDataManager()))
    }
}

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

struct PlanetButtons: View {
    
    
    @Environment(\.roomState) private var roomState
    @EnvironmentObject private var savedDate: PlanetsDate
    @EnvironmentObject private var manager: BirthDataManager
    @ObservedObject var viewModel: AstroPlanetButtonsViewModel
    @ViewBuilder
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Spacer()
                Button(action: planets) {
                    Text("Planets")
                }
                Spacer()
                Button(action: aspects) {
                    Text("Aspects")
                }
                Spacer()
                if viewModel.data.wrappedValue.count > 0 {
                    Button(action: clearData) {
                        Text("Clear")
                    }
                    Spacer()
                }
            }
            HStack(alignment: .top) {
                if !savedDate.exactPlanetsTime {
                    DatePicker(
                      "Date",
                      selection: $savedDate.planetsDateChoice,
                      displayedComponents: .date
                    ).datePickerStyle(DefaultDatePickerStyle())
                } else {
                    DatePicker(
                      "Date",
                      selection: $savedDate.planetsDateChoice,
                      displayedComponents: [.date, .hourAndMinute]
                    ).datePickerStyle(DefaultDatePickerStyle())
                }
            }
            HStack {
                Button(action: { savedDate.planetsDateChoice = Date()  }) {
                    Text("Reset to Now").font(Font.subheadline)
                }
                Spacer()
                Toggle("Exact Time", isOn: $savedDate.exactPlanetsTime)
                Spacer()
                
                Button(action: { roomState.wrappedValue = .ChartSettings }) {
                    Text("Settings").font(Font.subheadline)
                }
            }
            
        }
        
    }
}

extension PlanetButtons {
    func planets() {
        viewModel.planets(savedDate: savedDate)
    }
    
    func aspects() {
        viewModel.aspects(savedDate: savedDate)
    }
    
    func clearData() {
        viewModel.clearData()
    }
}

struct PlanetButtons_Previews: PreviewProvider {
    @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets(chartModel: ChartViewModel(chartName: "mike", chartType: .Natal)), name: "Mike", calculationSettings: CalculationSettings())]
    static var previews: some View {
        AstroButtons(viewModel: AstroPlanetButtonsViewModel(data: $row, manager: BirthDataManager()))
    }
}

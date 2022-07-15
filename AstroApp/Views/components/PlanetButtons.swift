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

struct PlanetButtons: View, AstrobotInterface {
    
    @Binding var data: [DisplayPlanetRow]
    @Environment(\.roomState) private var roomState
    @EnvironmentObject private var savedDate: PlanetsDate
    @State private var planetButtonsEnabled = true
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
                if data.count > 0 {
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
    func temporaryDisableButtons()->Void
    {
        planetButtonsEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            planetButtonsEnabled = true
        }
    }
    func planets()
    {
        guard planetButtonsEnabled else {
            return
        }
        temporaryDisableButtons()
        
        let row = getPlanets(time: savedDate.planetsDateChoice.getAstroTime(), location: nil)
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.count, type: .Planets, name: getStringDate())
        data.append(displayRow)
    }
    
    func aspects()
    {
        guard planetButtonsEnabled else {
            return
        }
        temporaryDisableButtons()
        let row = getAspects(time: savedDate.planetsDateChoice.getAstroTime(), with: nil, and: nil)
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.count, type: .Aspects, name: getStringDate())
        data.append(displayRow)
    }
    
    func clearData()
    {
        data.removeAll()
    }
    
    func getStringDate()->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        if savedDate.exactPlanetsTime {
            dateFormatter.dateFormat = "YY-MM-dd HH:mm Z"
        }
        return dateFormatter.string(from: savedDate.planetsDateChoice)
    }
}
struct PlanetButtons_Previews: PreviewProvider {
    @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets, name: "Mike")]
    static var previews: some View {
        AstroButtons(data: $row)
    }
}

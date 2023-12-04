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

struct TransitsButtonControl: View, AstrobotInterface {
    
    @EnvironmentObject private var manager: BirthDataManager
    @State private var transitDate: Date = Date()
    @Binding var data: [DisplayPlanetRow]
    @State private var astroButtonsEnabled = true
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
    func temporaryDisableButtons()->Void
    {
        astroButtonsEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            astroButtonsEnabled = true
        }
    }
    
    func houses()
    {
        guard astroButtonsEnabled else {
            return
        }
        temporaryDisableButtons()
        if let location = manager.getSelectionLocation() {
            let row = getHouses(time: manager.getSelectionTime(), location: location, system: manager.houseSystem.getHouseCode(), calculationSettings:  manager.calculationSettings)
            var viewModel = NatalChartViewModel()
            if let planets = row.planets as? [HouseCell] {
                viewModel.houseData = planets
            }
            
            let displayRow = DisplayPlanetRow(planets: row.planets, id: data.count, type: .Houses(system: manager.houseSystem, chartModel: viewModel), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
            data.append(displayRow)
        }
        
    }
    
    func transits()
    {
        guard astroButtonsEnabled else {
            return
        }
        temporaryDisableButtons()
        
        let row = getAspects(time: manager.getSelectionTime(), with: transitDate.getAstroTime(), and: manager.getSelectionLocation(), type: manager.transitOrbSelection, calculationSettings: manager.calculationSettings)
        let dateFormater = DateFormatter()
        dateFormater.locale   = Locale(identifier: "en_US_POSIX")
        dateFormater.dateFormat = "YY/MM/dd h:m"
        let transitData = TransitTimeData(calculationSettings: manager.calculationSettings, time: manager.getSelectionTime(), transitTime: transitDate, location: manager.getSelectionLocation())
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.count, type: .Transits(date: dateFormater.string(from: transitDate), orbs: manager.transitOrbSelection.getShortName(), transitData: transitData, chartName: manager.getCurrentName()), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
        data.append(displayRow)
    }
}

struct TransitsButtonControl_Previews: PreviewProvider {
    @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets, name: "Mike", calculationSettings: CalculationSettings())]
    static var previews: some View {
        TransitsButtonControl(data: $row)
    }
}

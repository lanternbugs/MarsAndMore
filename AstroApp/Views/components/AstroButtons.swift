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

struct AstroButtons: View, AstrobotInterface {
    
    @EnvironmentObject private var manager: BirthDataManager
    @Binding var data: [DisplayPlanetRow]
    @State private var astroButtonsEnabled = true
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
            if let _ = manager.selectedName {
                TransitsButtonControl(data: $data).padding([.top])
            }
        }
        
    }
}



extension AstroButtons {
    func temporaryDisableButtons()->Void
    {
        astroButtonsEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            astroButtonsEnabled = true
        }
    }
    func planets()
    {
        guard astroButtonsEnabled else {
            return
        }
        temporaryDisableButtons()
        
        let row = getPlanets(time: manager.getSelectionTime(), location: manager.getSelectionLocation(), calculationSettings: manager.calculationSettings)
        var viewModel = NatalChartViewModel(chartName: manager.getCurrentName())
        if let planets = row.planets as? [PlanetCell] {
            viewModel.planetData = planets
        }
        if let location = manager.getSelectionLocation() {
            let housesRow = getHouses(time: manager.getSelectionTime(), location: location, system: manager.houseSystem.getHouseCode(), calculationSettings:  manager.calculationSettings)
            if let planets = housesRow.planets as? [HouseCell] {
                viewModel.houseData = planets
            }
        }
        
        let aspectsRow = getAspects(time: manager.getSelectionTime(), with: nil, and: nil, type: manager.orbSelection, calculationSettings: manager.calculationSettings)
        
        if let aspects = aspectsRow.planets as? [TransitCell] {
            viewModel.aspectsData = aspects
        }
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.count, type: .Planets(chartModel: viewModel), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
        data.append(displayRow)
    }
    
    func aspects()
    {
        guard astroButtonsEnabled else {
            return
        }
        temporaryDisableButtons()
        let row = getAspects(time: manager.getSelectionTime(), with: nil, and: manager.getSelectionLocation(), type: manager.orbSelection, calculationSettings: manager.calculationSettings)
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.count, type: .Aspects(orbs: manager.orbSelection.getShortName()), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
        data.append(displayRow)
    }
    
    func clearData()
    {
        data.removeAll()
    }
}
struct AstroButtons_Previews: PreviewProvider {
    @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets(chartModel: NatalChartViewModel(chartName: "mike")), name: "Mike", calculationSettings: CalculationSettings())]
    static var previews: some View {
        AstroButtons(data: $row)
    }
}

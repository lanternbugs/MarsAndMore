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
    let viewModel: AstroPlanetButtonsViewModel
    @ViewBuilder
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Spacer()
                Button(action: astroPlanets) {
                    Text("Planets")
                }
                Spacer()
                Button(action: astroAspects) {
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
            if let _ = manager.selectedName {
                TransitsButtonControl(viewModel: AstroPlanetButtonsViewModel(data: viewModel.data)).padding([.top])
            }
        }
        
    }
}

extension AstroButtons {
    
    func astroPlanets() {
        viewModel.astroPlanets(manager: manager)
    }
    
    func astroAspects() {
        viewModel.astroAspects(manager: manager)
    }
    
    func clearData()
    {
        viewModel.clearData()
    }
}

 struct AstroButtons_Previews: PreviewProvider {
 @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets(chartModel: ChartViewModel(chartName: "mike", chartType: .Natal)), name: "Mike", calculationSettings: CalculationSettings())]
 static var previews: some View {
 AstroButtons(viewModel: AstroPlanetButtonsViewModel(data: $row))
 }
 }
 

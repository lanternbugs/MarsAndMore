/*
*  Copyright (C) 2022-24 Michael R Adams.
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
//  Created by Michael Adams on 4/10/24.
//

import SwiftUI

struct WheelChartPlanetListing: View {
    let viewModel: WheelChartDataViewModel
    @EnvironmentObject var manager:BirthDataManager
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(viewModel.chartTitle).font(.title2)
                Spacer()
            }
            ForEach(viewModel.planetData.sorted(by: { if $0.planet == .MC && $1.planet == .Ascendant {
                return false
            } else if $0.planet == .Ascendant && $1.planet == .MC {
                return true
            }
               return $0.planet.rawValue < $1.planet.rawValue }), id: \.id) {
                data in
                HStack {
                    if viewModel.showPlanet(data: data, manager: manager) {
                        if manager.chartDataSymbols {
                            viewModel.getPlanetSymbolRow(data).padding(.leading)
                        } else {
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text(viewModel.getPlanetRow(data)).textSelection(.enabled).padding(.leading)
            }
            else {
                Text(viewModel.getPlanetRow(data)).padding(.leading)
                }
#else
            if #available(iOS 15.0, *) {
                Text(viewModel.getPlanetRow(data)).textSelection(.enabled).padding(.leading)
            }
            else {
                Text(viewModel.getPlanetRow(data)).padding(.leading)
                }
#endif

                        }



                        
                            Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: [PlanetCell](), aspects: [TransitCell](), houses: [HouseCell](), chart: .Natal, title: "chart", houseSystem: HouseSystem.Placidus))
}

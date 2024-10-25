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
//  Created by Michael Adams on 4/14/24.
//

import SwiftUI

struct WheelChartAspectsListing: View {
    let viewModel: WheelChartDataViewModel
    @EnvironmentObject var manager:BirthDataManager
    let major: Bool
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if major {
                    if viewModel.chart == .Synastry || viewModel.chart == .Natal {
                        Text("Aspects").font(.title2)
                    } else {
                        Text("Transits").font(.title2)
                    }
                } else {
                    if viewModel.chart == .Synastry || viewModel.chart == .Natal {
                        Text("Minor Aspects").font(.title2)
                    } else {
                        Text("Minor Transits").font(.title2)
                    }
                }
                
                
                Spacer()
            }
            ForEach(viewModel.getAspectsData(), id: \.id) {
                data in
                HStack {
                    if viewModel.showAspect(data: data, manager: manager, major: major){
                        if manager.chartDataSymbols {
                            viewModel.getAspectSymbolRow(data)
                        } else {
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text(viewModel.getAspectRow(data)).textSelection(.enabled).padding(.leading)
            }
            else {
                Text(viewModel.getAspectRow(data)).padding(.leading)
                }
#else
            if #available(iOS 15.0, *) {
                Text(viewModel.getAspectRow(data)).textSelection(.enabled).padding(.leading)
            }
            else {
                Text(viewModel.getAspectRow(data)).padding(.leading)
                }
#endif
                        }

                        Spacer()
                    }
                    
                }
            }
            if major {
                if viewModel.chart == .Transit  {
                    Text("")
                    HStack {
                        Text("* for Applying").font(.title3)
                        Spacer()
                    }
                }
            } else {
                if viewModel.chart == .Transit  {
                    Text("")
                    HStack {
                        Text("Minor Transits do not show on Wheel").font(.body)
                        Spacer()
                    }
                } else {
                    Text("")
                    HStack {
                        Text("Minor Aspects do not show on Wheel").font(.body)
                        Spacer()
                    }
                }
            }
            
        }
    }
}


#Preview {
    WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: [PlanetCell](), aspects: [TransitCell](), houses: [HouseCell](), chart: .Natal, title: "chart", houseSystem: HouseSystem.Placidus), major: true)
}

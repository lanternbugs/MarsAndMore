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
//  Created by Michael Adams on 4/9/24.
//

import SwiftUI

struct WheelChartData: View {
    @State var showSymbolKey = false
    let viewModel: ChartViewModel
    @EnvironmentObject var manager:BirthDataManager
    var body: some View {

        if manager.chartDataSymbols {
            HStack {
                
                Spacer()
                if manager.chartDataSymbols {
                    if showSymbolKey {
                        Button(action:  { showSymbolKey.toggle()
                            }) {
                            Text("Hide Key")
                            }.padding(.trailing)
                    } else {
                        Button(action:  { showSymbolKey.toggle()
                            }) {
                            Text("Key")
                            }.padding(.trailing)
                    }
                }
            }
        }
        

        if manager.chartDataSymbols && showSymbolKey {
            AstroSymbolsKey(showAspectsSymbols: true)
        }
        VStack {
            if viewModel.chart == .Natal {
                WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: .Natal, title: "Planets", houseSystem: manager.houseSystem), tropical: viewModel.tropical)
                if !viewModel.houseData.isEmpty {
                    WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: .Natal, title: viewModel.houseSystemName + " Houses", houseSystem: manager.houseSystem))
                }
            }
            
            if !viewModel.aspectsData.isEmpty {
                WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: "Aspects", houseSystem: manager.houseSystem), major: true)
                
                if manager.showMinorAspects {
                    WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: "Aspects", houseSystem: manager.houseSystem), major: false)
                }
            }

            if viewModel.chart == .Synastry {
                WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: viewModel.name1, houseSystem: manager.houseSystem), tropical: viewModel.tropical)
                if !viewModel.houseData.isEmpty {
                    Text("")
                    WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: viewModel.houseSystemName + " Houses", houseSystem: manager.houseSystem))
                }
                if !viewModel.personOneAspectsData.isEmpty {
                    WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.personOneAspectsData, houses: viewModel.houseData, chart: .Natal, title: "Aspects", houseSystem: manager.houseSystem), major: true)
                    
                    if manager.showMinorAspects {
                        WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.personOneAspectsData, houses: viewModel.houseData, chart: .Natal, title: "Aspects", houseSystem: manager.houseSystem), major: false)
                    }
                }
                WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.secondaryPlanetData, aspects: viewModel.aspectsData, houses: viewModel.secondaryHouseData, chart: viewModel.chart, title: viewModel.name2, houseSystem: manager.houseSystem), tropical: viewModel.tropical)
                if !viewModel.secondaryHouseData.isEmpty {
                    Text("")
                    WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: viewModel.secondaryPlanetData, aspects: viewModel.aspectsData, houses: viewModel.secondaryHouseData, chart: viewModel.chart, title: viewModel.houseSystemName + " Houses", houseSystem: manager.houseSystem))
                }
                if !viewModel.personTwoAspectsData.isEmpty {
                    WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.secondaryPlanetData, aspects: viewModel.personTwoAspectsData, houses: viewModel.secondaryHouseData, chart: .Natal, title: "Aspects", houseSystem: manager.houseSystem), major: true)
                    
                    if manager.showMinorAspects {
                        WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.secondaryPlanetData, aspects: viewModel.personTwoAspectsData, houses: viewModel.secondaryHouseData, chart: .Natal, title: "Aspects", houseSystem: manager.houseSystem), major: false)
                    }
                }
            }
            else if viewModel.chart == .Transit {
                WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.secondaryPlanetData, aspects: viewModel.aspectsData, houses: viewModel.secondaryHouseData, chart: viewModel.chart, title: viewModel.name2, houseSystem: manager.houseSystem), tropical: viewModel.tropical)
                if !viewModel.personTwoAspectsData.isEmpty {
                    WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.secondaryPlanetData, aspects: viewModel.personTwoAspectsData, houses: viewModel.secondaryHouseData, chart: .Natal, title: "Aspects", houseSystem: manager.houseSystem), major: true)
                    
                    if manager.showMinorAspects {
                        WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.secondaryPlanetData, aspects: viewModel.personTwoAspectsData, houses: viewModel.secondaryHouseData, chart: .Natal, title: "Aspects", houseSystem: manager.houseSystem), major: false)
                    }
                }
                WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: viewModel.name1, houseSystem: manager.houseSystem), tropical: viewModel.tropical)
                if !viewModel.personOneAspectsData.isEmpty {
                    WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.personOneAspectsData, houses: viewModel.houseData, chart: .Natal, title: "Aspects", houseSystem: manager.houseSystem), major: true)
                    
                    if manager.showMinorAspects {
                        WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.personOneAspectsData, houses: viewModel.houseData, chart: .Natal, title: "Aspects", houseSystem: manager.houseSystem), major: false)
                    }
                }
                if !viewModel.houseData.isEmpty {
                    WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: viewModel.houseSystemName + " Houses", houseSystem: manager.houseSystem))
                }
            }
            Text("")
            if viewModel.showIndividualCompositeData {
                IndividualCompositeDataView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    WheelChartData(viewModel: ChartViewModel(model: WheelChartModel(chartName: "mike", chart: .Natal, manager: BirthDataManager())))
}

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
    let viewModel: ChartViewModel
    @EnvironmentObject var manager:BirthDataManager
    var body: some View {
        VStack {
            if viewModel.chart == .Natal {
                WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: .Natal, title: "Planets", houseSystem: manager.houseSystem))
                if !viewModel.houseData.isEmpty {
                    WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: .Natal, title: "Houses", houseSystem: manager.houseSystem))
                }
            }
            
            if !viewModel.aspectsData.isEmpty {
                WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: "Aspects", houseSystem: manager.houseSystem), major: true)
                
                if manager.showMinorAspects {
                    WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: "Aspects", houseSystem: manager.houseSystem), major: false)
                }
            }

            if viewModel.chart == .Synastry {
                WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: viewModel.name1, houseSystem: manager.houseSystem))
                if !viewModel.houseData.isEmpty {
                    Text("")
                    WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: "", houseSystem: manager.houseSystem))
                }
                WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.secondaryPlanetData, aspects: viewModel.aspectsData, houses: viewModel.secondaryHouseData, chart: viewModel.chart, title: viewModel.name2, houseSystem: manager.houseSystem))
                if !viewModel.secondaryHouseData.isEmpty {
                    Text("")
                    WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: viewModel.secondaryPlanetData, aspects: viewModel.aspectsData, houses: viewModel.secondaryHouseData, chart: viewModel.chart, title: "", houseSystem: manager.houseSystem))
                }
            }
            Text("")
        }
    }
}

#Preview {
    WheelChartData(viewModel: ChartViewModel(model: WheelChartModel(chartName: "mike", chart: .Natal, manager: BirthDataManager())))
}

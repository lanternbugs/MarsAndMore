//
//  WheelChartData.swift
//  MarsAndMore
//
//  Created by Michael Adams on 4/9/24.
//

import SwiftUI

struct WheelChartData: View {
    let viewModel: ChartViewModel
    @EnvironmentObject var manager:BirthDataManager
    var body: some View {
        VStack {
            if viewModel.chart == .Natal {
                WheelChartPlanetListing(planetData: viewModel.planetData, houseData: viewModel.houseData, chartTitle: "Planets")
                if !viewModel.houseData.isEmpty {
                    WheelChartHouseListing(houseData: viewModel.houseData, planetData: viewModel.planetData, chartTitle: "Houses")
                }
            }
            
            if !viewModel.aspectsData.isEmpty {
                WheelChartAspectsListing(chart: viewModel.chart, aspectsData: viewModel.aspectsData)
            }

            if viewModel.chart == .Synastry {
                WheelChartPlanetListing(planetData: viewModel.planetData, houseData: viewModel.houseData, chartTitle: viewModel.name1)
                if !viewModel.houseData.isEmpty {
                    Text("")
                    WheelChartHouseListing(houseData: viewModel.houseData, planetData: viewModel.planetData, chartTitle: "")
                }
                WheelChartPlanetListing(planetData: viewModel.secondaryPlanetData, houseData: viewModel.secondaryHouseData, chartTitle: viewModel.name2)
                if !viewModel.secondaryHouseData.isEmpty {
                    Text("")
                    WheelChartHouseListing(houseData: viewModel.secondaryHouseData, planetData: viewModel.secondaryPlanetData, chartTitle: "")
                }
            }
            Text("")
        }
    }
}

#Preview {
    WheelChartData(viewModel: ChartViewModel(chartName: "mike", chartType: .Natal))
}

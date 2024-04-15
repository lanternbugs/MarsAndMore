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
                WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: .Natal, title: "Planets"))
                if !viewModel.houseData.isEmpty {
                    WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: .Natal, title: "Houses"))
                }
            }
            
            if !viewModel.aspectsData.isEmpty {
                WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: "Aspects"))
            }

            if viewModel.chart == .Synastry {
                WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: viewModel.name1))
                if !viewModel.houseData.isEmpty {
                    Text("")
                    WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: viewModel.planetData, aspects: viewModel.aspectsData, houses: viewModel.houseData, chart: viewModel.chart, title: ""))
                }
                WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.secondaryPlanetData, aspects: viewModel.aspectsData, houses: viewModel.secondaryHouseData, chart: viewModel.chart, title: viewModel.name2))
                if !viewModel.secondaryHouseData.isEmpty {
                    Text("")
                    WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: viewModel.secondaryPlanetData, aspects: viewModel.aspectsData, houses: viewModel.secondaryHouseData, chart: viewModel.chart, title: ""))
                }
            }
            Text("")
        }
    }
}

#Preview {
    WheelChartData(viewModel: ChartViewModel(chartName: "mike", chartType: .Natal))
}

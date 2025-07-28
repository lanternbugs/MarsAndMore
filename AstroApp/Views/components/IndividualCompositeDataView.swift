//
//  IndividualCompositeDataView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 10/3/24.
//

import SwiftUI

struct IndividualCompositeDataView: View {
    let viewModel: ChartViewModel
    @EnvironmentObject var manager:BirthDataManager
    var body: some View {
        VStack() {
            
            WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.personOnePlanetData, aspects: viewModel.personOneAspectsData, houses: viewModel.personOneHouseData, chart: .Natal, title: viewModel.name1, houseSystem: manager.houseSystem), tropical: viewModel.tropical)
            if !viewModel.personOneHouseData.isEmpty {
                WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: viewModel.personOnePlanetData, aspects: viewModel.personOneAspectsData, houses: viewModel.personOneHouseData, chart: .Natal, title: viewModel.houseSystemName + " Houses", houseSystem: manager.houseSystem))
            }
            WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.personOnePlanetData, aspects: viewModel.personOneAspectsData, houses: viewModel.personOneHouseData, chart: .Natal, title: "Aspects", houseSystem: manager.houseSystem), major: true)
            if manager.showMinorAspects {
                WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.personOnePlanetData, aspects: viewModel.personOneAspectsData, houses: viewModel.personOneHouseData, chart: .Natal, title: "Aspects", houseSystem: manager.houseSystem), major: false)
            }
            
            WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: viewModel.personTwoPlanetData, aspects: viewModel.personTwoAspectsData, houses: viewModel.personTwoHouseData, chart: .Natal, title: viewModel.name2, houseSystem: manager.houseSystem), tropical: viewModel.tropical)
            if !viewModel.personTwoHouseData.isEmpty {
                WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: viewModel.personTwoPlanetData, aspects: viewModel.personTwoAspectsData, houses: viewModel.personTwoHouseData, chart: .Natal, title: viewModel.houseSystemName + " Houses", houseSystem: manager.houseSystem))
            }
            WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.personTwoPlanetData, aspects: viewModel.personTwoAspectsData, houses: viewModel.personTwoHouseData, chart: .Natal, title: "Aspects", houseSystem: manager.houseSystem), major: true)
            if manager.showMinorAspects {
                WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: viewModel.personTwoPlanetData, aspects: viewModel.personTwoAspectsData, houses: viewModel.personTwoHouseData, chart: .Natal, title: "Aspects", houseSystem: manager.houseSystem), major: false)
            }
            Text("")

            
            
        }
        
    }
}

#Preview {
    IndividualCompositeDataView(viewModel: ChartViewModel(model: WheelChartModel(chartName: "", chart: .Natal, manager: BirthDataManager())))
}

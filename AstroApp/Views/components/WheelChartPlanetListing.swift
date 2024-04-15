//
//  WheelChartPlanetListing.swift
//  MarsAndMore
//
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
            ForEach(viewModel.planetData.sorted(by: { if $0.planet == .MC && $1.planet == .Ascendent {
                return false
            } else if $0.planet == .Ascendent && $1.planet == .MC {
                return true
            }
               return $0.planet.rawValue < $1.planet.rawValue }), id: \.id) {
                data in
                HStack {
                    if viewModel.showPlanet(data: data, manager: manager) {
                            Text(viewModel.getPlanetRow(data))
                            Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    WheelChartPlanetListing(viewModel: WheelChartDataViewModel(planets: [PlanetCell](), aspects: [TransitCell](), houses: [HouseCell](), chart: .Natal, title: "chart"))
}

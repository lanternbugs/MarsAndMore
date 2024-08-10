//
//  WheelChartAspectsListing.swift
//  MarsAndMore
//
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
                        Text(viewModel.getAspectRow(data))
                        Spacer()
                    }
                    
                }
            }
            if viewModel.chart == .Transit && major {
                Text("")
                HStack {
                    Text("* for Applying").font(.title3)
                    Spacer()
                }
            }
        }
    }
}


#Preview {
    WheelChartAspectsListing(viewModel: WheelChartDataViewModel(planets: [PlanetCell](), aspects: [TransitCell](), houses: [HouseCell](), chart: .Natal, title: "chart", houseSystem: HouseSystem.Placidus), major: true)
}

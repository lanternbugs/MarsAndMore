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
                HStack {
                    Spacer()
                    Text("Planets").font(.title2)
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
                        if manager.bodiesToShow.contains(data.planet) {
                            Text(getPlanetRow(data))
                            Spacer()
                        }
                        
                    }
                }
            }
                if !viewModel.aspectsData.isEmpty {
                    HStack {
                        Spacer()
                        if viewModel.chart == .Synastry || viewModel.chart == .Natal {
                            Text("Aspects").font(.title2)
                        } else {
                            Text("Transits").font(.title2)
                        }
                        
                        Spacer()
                    }
                    ForEach(viewModel.aspectsData.sorted(by: {
                        if $0.planet2 == .MC && $1.planet2 == .Ascendent  {
                            return false
                        }
                        if $0.planet2 == .Ascendent && $1.planet2 == .MC  {
                            return true
                        }
                        return $0.planet2.rawValue < $1.planet2.rawValue }), id: \.id) {
                        data in
                        HStack {
                            if data.aspect.isMajor() && manager.bodiesToShow.contains(data.planet) && manager.bodiesToShow.contains(data.planet2){
                                Text(getAspectRow(data))
                                Spacer()
                            }
                            
                        }
                    }
                }
           
        }
    }
}

extension WheelChartData {
    func getPlanetRow(_ data: PlanetCell) -> String {
        var text =  data.planet.getName().uppercased() + " " + data.sign.getName() + " " + data.degree
        if data.retrograde {
            text = text + " " + "R"
        }
        
        return text
    }
    func getAspectRow(_ data: TransitCell) -> String {
        if viewModel.chart == .Transit {
            return data.planet.getName() + " " + data.aspect.getName() + " " + data.planet2.getName() + " " + data.degree
        }
        return data.planet2.getName() + " " + data.aspect.getName() + " " + data.planet.getName() + " " + data.degree
    }
}

#Preview {
    WheelChartData(viewModel: ChartViewModel(chartName: "mike", chartType: .Natal))
}

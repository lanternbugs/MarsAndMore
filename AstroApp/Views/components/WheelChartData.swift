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
                WheelChartPlanetListing(planetData: viewModel.planetData, chartTitle: "Planets")
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
                    ForEach(getAspectsData(), id: \.id) {
                        data in
                        HStack {
                            if data.aspect.isMajor() && manager.bodiesToShow.contains(data.planet) && manager.bodiesToShow.contains(data.planet2){
                                Text(getAspectRow(data))
                                Spacer()
                            }
                            
                        }
                    }
                    if viewModel.chart == .Transit {
                        Text("")
                        HStack {
                            Text("* for Applying").font(.title3)
                            Spacer()
                        }
                    }
                }
            if viewModel.chart == .Synastry {
                WheelChartPlanetListing(planetData: viewModel.planetData, chartTitle: viewModel.name1)
                Text("")
            }
            
            if viewModel.chart == .Synastry {
                WheelChartPlanetListing(planetData: viewModel.secondaryPlanetData, chartTitle: viewModel.name2)
            }
           
        }
    }
}

extension WheelChartData {
    func getAspectsData() -> [TransitCell] {
        if viewModel.chart == .Natal {
            return viewModel.aspectsData.sorted(by: {
                if  $0.planet.rawValue < $1.planet.rawValue {
                    if $0.planet.rawValue < $1.planet2.rawValue {
                        return true
                    } else {
                        if $0.planet2.rawValue < $1.planet2.rawValue {
                            return true
                        }
                        return false
                    }
                } else {
                    if $0.planet2.rawValue < $1.planet.rawValue {
                        if $0.planet2.rawValue < $1.planet2.rawValue {
                            return true
                        }
                        return false
                    } else {
                        if $1.planet.rawValue < $0.planet.rawValue {
                            return false
                        }
                        return false
                    }
                }
                        
                        
            })
        }
        if viewModel.chart == .Synastry {
            return viewModel.aspectsData.sorted(by: {
                if $0.planet2 == .MC && $1.planet2 == .Ascendent  {
                    return false
                }
                if $0.planet2 == .Ascendent && $1.planet2 == .MC  {
                    return true
                }
                return $0.planet2.rawValue < $1.planet2.rawValue })
        }
        return viewModel.aspectsData.sorted(by: {
            return $0.planet.rawValue < $1.planet.rawValue })
    }
    
    func getAspectRow(_ data: TransitCell) -> String {
        if viewModel.chart == .Transit {
            var tempo =   data.planet.getName() + " " + data.aspect.getName() + " " + data.planet2.getName() + " " + data.degree
            if data.movement == .Applying {
                tempo = "*" + tempo
            }
            return tempo
        }
        if viewModel.chart == .Natal {
            if data.planet.rawValue < data.planet2.rawValue {
                return data.planet.getName() + " " + data.aspect.getName() + " " + data.planet2.getName() + " " + data.degree
            } else {
                return data.planet2.getName() + " " + data.aspect.getName() + " " + data.planet.getName() + " " + data.degree
            }
        }
        return data.planet2.getName() + " " + data.aspect.getName() + " " + data.planet.getName() + " " + data.degree
    }
}

#Preview {
    WheelChartData(viewModel: ChartViewModel(chartName: "mike", chartType: .Natal))
}

/*
*  Copyright (C) 2022-23 Michael R Adams.
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
//  Created by Michael Adams on 11/30/23.
//

import SwiftUI

struct WheelChartView: View {
    let viewModel: ChartViewModel
    @EnvironmentObject var manager:BirthDataManager

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Text(viewModel.chartName)
                    Spacer()
#if os(macOS)
                    if manager.chartWheelColorType == .Light {
                                            Button(action:  { manager.chartWheelColorType = .Dark }) {
                                                Text("Dark Chart")
                                            }
                                        } else {
                                            Button(action:  { manager.chartWheelColorType = .Light }) {
                                                Text("Light Chart")
                                            }
                                        }
#elseif os(iOS)
                    if manager.chartWheelColorType == .Light {
                                            Button(action:  { manager.chartWheelColorType = .Dark }) {
                                                Text("Dark Chart")
                                            }.padding(.top)
                                        } else {
                                            Button(action:  { manager.chartWheelColorType = .Light }) {
                                                Text("Light Chart")
                                            }.padding(.top)
                                        }
#endif
                }
                if manager.chartWheelColorType == .Light {
#if os(macOS)
                NatalViewRepresentable(model: viewModel).frame(maxWidth: .infinity, idealHeight: getScreenWidth() * 0.6)
#elseif os(iOS)
                NatalViewRepresentable(model: viewModel).frame(width: getScreenWidth(), height: getScreenWidth())
#endif
                } else {
                    
#if os(macOS)
                NatalViewRepresentable(model: viewModel).frame(maxWidth: .infinity, idealHeight: getScreenWidth() * 0.6)
#elseif os(iOS)
                NatalViewRepresentable(model: viewModel).frame(width: getScreenWidth(), height: getScreenWidth())
#endif
            }
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
}

extension WheelChartView {
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
    
    func getScreenWidth()->Double
    {
#if os(macOS)
        guard let mainScreen = NSScreen.main else {
            return 200.0
        }
        return mainScreen.visibleFrame.size.width / 2.0
#elseif os(iOS)
        if UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height {
            return UIScreen.main.bounds.size.width
        }
        return UIScreen.main.bounds.size.height * 0.77
    
#endif
    
    }
}

#Preview {
    WheelChartView(viewModel: ChartViewModel(chartName: "mike", chartType: .Natal))
}

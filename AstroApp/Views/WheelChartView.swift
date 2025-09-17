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
    @State var opaqueValue = 0.0
    @AppStorage("WheelStepTime") var stepTime: StepTimes = .oneDay
    let easeDuration = 0.5

    var body: some View {
        ScrollView {
            
            HStack {
                
                if manager.chartDataSymbols {
                    Button(action:  { manager.chartDataSymbols = false }) {
                        Text("Text")
                    }.padding([.leading, .top])
                } else {
                    Button(action:  { manager.chartDataSymbols = true }) {
                        Text("Symbols")
                    }.padding([.leading, .top])
                }
                
                Spacer()
                if (manager.chartTabChartJumpedInTime && viewModel.model.tab == .ChartTab) || (manager.planetsTabChartJumpedInTime && viewModel.model.tab == .PlanetsTab) {
                        if viewModel.model.chart == .Transit {
                            if viewModel.model.originalTransitTime == viewModel.model.transitTime {
                                Text(viewModel.chartName)
                            } else {
                                Text(viewModel.chartName + "*")
                            }
                        } else if viewModel.chart == .Natal {
                            if viewModel.model.originalSelectedTime == viewModel.model.selectedTime {
                                Text(viewModel.chartName)
                            } else {
                                Text(viewModel.chartName + "*")
                            }
                        }
                        
                    } else {
                        Text(viewModel.chartName)
                    }
                    
                    Spacer()

                    if manager.chartWheelColorType == .Light {
                                            Button(action:  { manager.chartWheelColorType = .Dark }) {
                                                Text("Dark Chart")
                                            }.padding(.top)
                                        } else {
                                            Button(action:  { manager.chartWheelColorType = .Light }) {
                                                Text("Light Chart")
                                            }.padding(.top)
                                        }

                }
            if viewModel.model.selectedTime != nil {
                HStack {
                    if (manager.chartTabChartJumpedInTime && viewModel.model.tab == .ChartTab) || (manager.planetsTabChartJumpedInTime && viewModel.model.tab == .PlanetsTab) {
                        Button(action: {
                            reset()
                        }) {
                            Text("Reset").font(Font.subheadline)
                        }.padding(.leading)
                    }
                    Spacer()
                    Button(action: {
                        stepInTime(forward: false) }) {
                        Text("<<").font(Font.subheadline)
                    }.padding(.trailing)
                    Button(action: {
                        stepInTime(forward: true)
                    }) {
                        Text(">>").font(Font.subheadline)
                    }.padding(.trailing)
                    
                    Picker(selection: $stepTime, label: Text("Step Time")) {
                        ForEach(StepTimes.allCases, id: \.rawValue) {
                            system in
#if os(iOS)
                            Text(system.getShortName()).tag(system)
#else
                            Text(system.rawValue).tag(system)
#endif
                            
                        }
                    }.padding(.trailing)
                }.padding(.bottom)
                
            }

                
                if manager.chartWheelColorType == .Light {
#if os(macOS)
                    NatalViewRepresentable(model: viewModel).frame(maxWidth: .infinity, idealHeight: getScreenWidth() * 0.6).opacity(opaqueValue).animation(.easeIn(duration: easeDuration), value: opaqueValue)
#elseif os(iOS)
                NatalViewRepresentable(model: viewModel).frame(width: getScreenWidth(), height: getScreenWidth()).opacity(opaqueValue).animation(.easeIn(duration: easeDuration), value: opaqueValue)
#endif
                } else {
                    
#if os(macOS)
                NatalViewRepresentable(model: viewModel).frame(maxWidth: .infinity, idealHeight: getScreenWidth() * 0.6).opacity(opaqueValue).animation(.easeIn(duration: easeDuration), value: opaqueValue)
#elseif os(iOS)
                NatalViewRepresentable(model: viewModel).frame(width: getScreenWidth(), height: getScreenWidth()).opacity(opaqueValue).animation(.easeIn(duration: easeDuration), value: opaqueValue)
#endif
            }
             
#if os(iOS)
            HStack {
                Spacer()
                Text("Double Tap Zooms")
                Spacer()
            }
 
#endif
            WheelChartData(viewModel: viewModel)
        }.onAppear() {
            opaqueValue = 1.0
        }
    }
}

extension WheelChartView {
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

extension WheelChartView {
    func stepInTime(forward: Bool) {
        if viewModel.model.tab == .ChartTab {
            manager.chartTabChartJumpedInTime = false
            manager.chartTabChartJumpedInTime = true
        } else if viewModel.model.tab == .PlanetsTab {
            manager.planetsTabChartJumpedInTime = false
            manager.planetsTabChartJumpedInTime = true
        }
        
        viewModel.jumpChartInTime(forward: forward, stepTime: stepTime)
    }
    
    func reset() {
        if viewModel.model.tab == .ChartTab {
            manager.chartTabChartJumpedInTime = false
        } else if viewModel.model.tab == .PlanetsTab {
            manager.planetsTabChartJumpedInTime = false
        }
        viewModel.resetToOriginalDate()
    }
}

#Preview {
    WheelChartView(viewModel: ChartViewModel(model: WheelChartModel(chartName: "mike", chart: .Natal, manager: BirthDataManager())))
}

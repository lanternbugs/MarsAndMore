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
struct WheelChartView: View  {
    let viewModel: ChartViewModel
    @EnvironmentObject var manager:BirthDataManager
    @State var opaqueValue = 0.0
    @State var zoomed = false
    @AppStorage("WheelStepTime") var stepTime: StepTimes = .oneDay
    let easeDuration = 0.5

    var body: some View {
        ScrollView {
            
            if !zoomed {
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
                    if (manager.chartTabChartJumpedInTime && viewModel.model.tab == .ChartTab) || (manager.planetsTabChartJumpedInTime && viewModel.model.tab == .PlanetsTab) || (manager.partnerJumpedInTime && (!viewModel.personOneAspectsData.isEmpty && !viewModel.personTwoAspectsData.isEmpty  )) {
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
                                                Button(action:  { manager.chartWheelColorType = .Dark
                                                zoomed = false }) {
                                                    Text("Dark Chart")
                                                }.padding(.top)
                                            } else {
                                                Button(action:  { manager.chartWheelColorType = .Light
                                                zoomed = false }) {
                                                    Text("Light Chart")
                                                }.padding(.top)
                                            }

                    }
                if viewModel.model.selectedTime != nil {
                    
    #if os(iOS)
                    HStack {
                        if (manager.chartTabChartJumpedInTime && viewModel.model.tab == .ChartTab) || (manager.planetsTabChartJumpedInTime && viewModel.model.tab == .PlanetsTab) || (!viewModel.personOneAspectsData.isEmpty && !viewModel.personTwoAspectsData.isEmpty && manager.partnerJumpedInTime) {
                            Button(action: {
                                reset()
                            }) {
                                Text("Reset").font(Font.subheadline)
                            }.padding([.leading, .bottom])
                        }
                        Spacer()
                        Button(action: {
                            stepInTime(forward: false) }) {
                            Text("<<").font(Font.subheadline)
                            }.padding([.trailing, .bottom])
                        Button(action: {
                            stepInTime(forward: true)
                        }) {
                            Text(">>").font(Font.subheadline)
                        }.padding([.trailing, .bottom])
                            Picker(selection: $stepTime, label: Text("Step Time")) {
                                ForEach(StepTimes.allCases, id: \.rawValue) {
                                    system in
        #if os(iOS)
                                    Text(system.getShortName()).tag(system)
        #else
                                    Text(system.rawValue).tag(system)
        #endif
                                    
                                }
                            }.padding([.trailing, .bottom])
                            
                            if viewModel.model.tab == .PlanetsTab {
                                Button(action: {
                                    stepToNow() }) {
                                    Text("Now").font(Font.subheadline)
                                    }.padding([.trailing, .bottom])
                            }
                    }.padding(viewModel.model.tab == .PlanetsTab ? .bottom : .leading)
                    
    #else
                    HStack {
                        Button(action: {
                        stepInTime(forward: false) }) {
                        Text("<<").font(Font.subheadline)
                        }.padding([.leading])
                    Button(action: {
                        stepInTime(forward: true)
                    }) {
                        Text(">>").font(Font.subheadline)
                    }.padding([.leading])
                    if (manager.chartTabChartJumpedInTime && viewModel.model.tab == .ChartTab) || (manager.planetsTabChartJumpedInTime && viewModel.model.tab == .PlanetsTab) || (!viewModel.personOneAspectsData.isEmpty && !viewModel.personTwoAspectsData.isEmpty && manager.partnerJumpedInTime) {
                        Button(action: {
                            reset()
                        }) {
                            Text("Reset").font(Font.subheadline)
                        }.padding([.leading])
                    }
                        Picker(selection: $stepTime, label: Text("Step Time")) {
                            ForEach(StepTimes.allCases, id: \.rawValue) {
                                system in
    #if os(iOS)
                                Text(system.getShortName()).tag(system)
    #else
                                Text(system.rawValue).tag(system)
    #endif
                                
                            }
                        }.padding([.trailing])
                        
                        if viewModel.model.tab == .PlanetsTab {
                            Button(action: {
                                stepToNow() }) {
                                Text("Now").font(Font.subheadline)
                                }.padding([.trailing])
                        }
                    }
                        
    #endif
                        
                        
 
                    
                    
                }

            }
                
                if manager.chartWheelColorType == .Light {
#if os(macOS)
                    NatalViewRepresentable(model: viewModel).frame(maxWidth: .infinity, idealHeight: getScreenWidth() * 0.6).opacity(opaqueValue).animation(.easeIn(duration: easeDuration), value: opaqueValue)
#elseif os(iOS)
                    if viewModel.model.tab == .PlanetsTab && !zoomed {
                        NatalViewRepresentable(model: viewModel).frame(width: getScreenWidth(), height: zoomed ?  getCurrentChartHeightiOS() : getScreenWidth()).opacity(opaqueValue).animation(.easeIn(duration: easeDuration), value: opaqueValue).padding(.top)
                    } else {
                        NatalViewRepresentable(model: viewModel).frame(width: getScreenWidth(), height: zoomed ?  getCurrentChartHeightiOS() : getScreenWidth()).opacity(opaqueValue).animation(.easeIn(duration: easeDuration), value: opaqueValue)
                    }
                    
                    
#endif
                } else {
                    
#if os(macOS)
                NatalViewRepresentable(model: viewModel).frame(maxWidth: .infinity, idealHeight: getScreenWidth() * 0.6).opacity(opaqueValue).animation(.easeIn(duration: easeDuration), value: opaqueValue)
#elseif os(iOS)
                    if viewModel.model.tab == .PlanetsTab && !zoomed {
                        NatalViewRepresentable(model: viewModel).frame(width: getScreenWidth(), height:  zoomed ?  getCurrentChartHeightiOS() : getScreenWidth()).opacity(opaqueValue).animation(.easeIn(duration: easeDuration), value: opaqueValue).padding(.top)
                    } else {
                        NatalViewRepresentable(model: viewModel).frame(width: getScreenWidth(), height:  zoomed ?  getCurrentChartHeightiOS() : getScreenWidth()).opacity(opaqueValue).animation(.easeIn(duration: easeDuration), value: opaqueValue)
                    }
                        
                        
                        
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
            viewModel.zoomed = $zoomed
        }
    }
}

extension WheelChartView {
#if os(iOS)
    
    func getCurrentChartHeightiOS() -> Double {
        UIScreen.main.bounds.size.height * 0.70
    }
    
#endif
    
    func getScreenWidth() -> Double
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
    func stepToNow() {
        if viewModel.model.tab == .PlanetsTab {
            manager.planetsTabChartJumpedInTime = false
            manager.planetsTabChartJumpedInTime = true
        }
        viewModel.jumpChart(newDate: Date())
    }
    
    func stepInTime(forward: Bool) {
        if !viewModel.personOneAspectsData.isEmpty && !viewModel.personTwoAspectsData.isEmpty  {
            manager.partnerJumpedInTime = false
            manager.partnerJumpedInTime = true
        }
        else if viewModel.model.tab == .ChartTab {
            manager.chartTabChartJumpedInTime = false
            manager.chartTabChartJumpedInTime = true
        } else if viewModel.model.tab == .PlanetsTab {
            manager.planetsTabChartJumpedInTime = false
            manager.planetsTabChartJumpedInTime = true
        }
        
        viewModel.jumpChartInTime(forward: forward, stepTime: stepTime)
    }
    
    func reset() {
        if !viewModel.personOneAspectsData.isEmpty && !viewModel.personTwoAspectsData.isEmpty  {
            manager.partnerJumpedInTime = false
        }
        else if viewModel.model.tab == .ChartTab {
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

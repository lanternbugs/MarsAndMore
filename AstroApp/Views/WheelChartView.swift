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
    let easeDuration = 0.5

    var body: some View {
        ScrollView {
            
                HStack {

                    if manager.chartDataSymbols {
                        Button(action:  { manager.chartDataSymbols = false }) {
                                                Text("Text")
                        }.padding(.leading)
                                        } else {
                                            Button(action:  { manager.chartDataSymbols = true }) {
                                                Text("Symbols")
                                            }.padding(.leading)
                                        }

                    Spacer()
                    Text(viewModel.chartName)
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

#Preview {
    WheelChartView(viewModel: ChartViewModel(model: WheelChartModel(chartName: "mike", chart: .Natal, manager: BirthDataManager())))
}

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
//  Created by Michael Adams on 11/19/23.
//

import SwiftUI

struct MundaneView: View, AstrobotInterface {
    @ObservedObject var viewModel: TransitMundaneViewModel
    @EnvironmentObject private var manager: BirthDataManager
    var body: some View {
        VStack {
            HStack {
                if manager.showTransitTimeSymbols {
                    Button(action:  { manager.showTransitTimeSymbols.toggle()
                        viewModel.reload()
                        }) {
                        Text("Text")
                        }.padding([.top, .leading])
                } else {
                    Button(action:  { manager.showTransitTimeSymbols.toggle()
                        viewModel.reload()
                        }) {
                        Text("Symbols")
                        }.padding([.top, .leading])
                }
                Spacer()
                Text("Mundane").font(.title)
                Spacer()
            }
            HStack {
                Button(action: viewModel.previousDay) {
                    Text("<<").font(.title)
                }
                Spacer()
                Text("\(viewModel.date.getLongDateTitleString())").font(.title2)
                Spacer()
                Button(action: viewModel.nextDay) {
                    Text(">>").font(.title)
                }
            }
            
            ScrollView {
                VStack {
                    HStack {
                        Text("Planetary Transits").font(.title)
                        Spacer()
                    }
                    TransitTimesView(transits: $viewModel.skyTransits, viewModel: TransitTimesViewModel(transitToShow: .Planetary))
                    Text(" ")
                    HStack {
                        Text("Moon Transits").font(.title)
                        Spacer()
                    }
                    TransitTimesView(transits: $viewModel.skyTransits, viewModel: TransitTimesViewModel(transitToShow: .Moon))
                }
            }
        }
    }
}

#Preview {
    MundaneView(viewModel: TransitMundaneViewModel(transits: [], skyTransits: [], transitData: TransitTimeData(), date: Date(), manager: BirthDataManager()))
}

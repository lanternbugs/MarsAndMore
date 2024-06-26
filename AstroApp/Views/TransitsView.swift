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
//  Created by Michael Adams on 11/21/23.
//

import SwiftUI

struct TransitsView: View {
    @ObservedObject var viewModel: TransitMundaneViewModel
    let chartName: String
    @EnvironmentObject private var manager: BirthDataManager
    var body: some View {
        ScrollView {
            VStack {
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
                HStack {
                    Text("Plantary Transits for \(chartName)").font(.title)
                    Spacer()
                }
                TransitTimesView(transits: $viewModel.transits, viewModel: TransitTimesViewModel(transitToShow: .Planetary))
                Text(" ")
                HStack {
                    Text("Moon Transits for \(chartName)").font(.title)
                    Spacer()
                }
                TransitTimesView(transits: $viewModel.transits, viewModel: TransitTimesViewModel(transitToShow: .Moon))
                Text(" ")
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

#Preview {
    TransitsView(viewModel: TransitMundaneViewModel(transits: [], skyTransits: [], transitData: TransitTimeData(), date: Date(), manager: BirthDataManager()), chartName: "none")
}

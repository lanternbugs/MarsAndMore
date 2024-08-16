/*
*  Copyright (C) 2022-24 Michael R Adams.
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
//  Created by Michael Adams on 8/16/24.
//

import SwiftUI

struct EphemerisButtonsView: View {
    @EnvironmentObject var viewModel: EphemerisViewModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: { viewModel.previousMonth() }) {
                    Text("Prev Month").font(Font.subheadline).padding(.leading)
                }
                Spacer()
                Text(viewModel.date.getMonthYearDisplayDate())
                Spacer()
                Button(action: { viewModel.nextMonth() }) {
                    Text("Next Month").font(Font.subheadline).padding(.trailing)
                }
            }
            HStack {
                if viewModel.showEphemerisSymbols {
                    Button(action:  { viewModel.toggleEphemerisSymbols()
                        viewModel.calculateMonthsPlanetData()}) {
                            Text("Text")
                        }.padding([.top, .leading])
                } else {
                    Button(action:  { viewModel.toggleEphemerisSymbols()
                        viewModel.calculateMonthsPlanetData()}) {
                            Text("Symbols")
                        }.padding([.top, .leading])
                }
                Spacer()
                if viewModel.showEphemerisSymbols {
                    if viewModel.showEphemerisKey {
                        Button(action:  { viewModel.toggleEphemerisKey()
                            viewModel.calculateMonthsPlanetData()}) {
                                Text("Hide Key")
                            }.padding([.top, .leading])
                    } else {
                        Button(action:  { viewModel.toggleEphemerisKey()
                            viewModel.calculateMonthsPlanetData()}) {
                                Text("Key")
                            }.padding([.top, .leading])
                    }
                    Spacer()
                }
                
                if viewModel.showModernEphemeris {
                    Button(action:  { viewModel.toggleModernEphemeris()
                        viewModel.calculateMonthsPlanetData()}) {
                            Text("Classical")
                        }.padding([.top, .trailing])
                } else {
                    Button(action:  { viewModel.toggleModernEphemeris()
                        viewModel.calculateMonthsPlanetData()}) {
                            Text("Modern")
                        }.padding([.top, .trailing])
                }
            }
        }
    }
}

#Preview {
    EphemerisButtonsView()
}

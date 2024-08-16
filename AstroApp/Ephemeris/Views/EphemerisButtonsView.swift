//
//  EphemerisButtonsView.swift
//  MarsAndMore
//
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
                if viewModel.getShowEphemerisSymbols() {
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
                if viewModel.getShowEphemerisSymbols() {
                    if viewModel.getShowEphemerisKey() {
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
                
                if viewModel.getShowModernEphemeris() {
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

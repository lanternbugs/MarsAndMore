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
//  Created by Michael Adams on 8/3/24.
//

import SwiftUI

struct EphemerisView: View {
    @ObservedObject var viewModel: EphemerisViewModel
#if os(iOS)
    let symbolFontSize = UIDevice.current.userInterfaceIdiom == .pad ? 24.0 : 18.0
#else
    let symbolFontSize = 20.0
#endif
    
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
                    Button(action:  { viewModel.showEphemerisSymbols = !viewModel.showEphemerisSymbols
                        viewModel.calculateMonthsPlanetData()}) {
                        Text("Text")
                        }.padding([.top, .leading])
                } else {
                    Button(action:  { viewModel.showEphemerisSymbols = !viewModel.showEphemerisSymbols 
                        viewModel.calculateMonthsPlanetData()}) {
                        Text("Symbols")
                        }.padding([.top, .leading])
                }
                Spacer()
                if viewModel.showModernEphemeris {
                    Button(action:  { viewModel.showModernEphemeris = !viewModel.showModernEphemeris
                        viewModel.calculateMonthsPlanetData()}) {
                        Text("Classical")
                        }.padding([.top, .trailing])
                } else {
                    Button(action:  { viewModel.showModernEphemeris = !viewModel.showModernEphemeris
                        viewModel.calculateMonthsPlanetData()}) {
                        Text("Modern")
                        }.padding([.top, .trailing])
                }
            }

            ScrollView([.horizontal, .vertical]) {
                let rows: [GridItem] = Array(repeating: .init(.flexible()), count: viewModel.numbersOfDays)
                LazyHGrid(rows: rows) {
                    let count = viewModel.planetGrid.count
                    ForEach(0 ..< count, id: \.self) { i in
                        HStack {
                            if viewModel.showEphemerisSymbols {
                                if viewModel.planetGrid[i].retrograde && viewModel.planetGrid[i].planet != Planets.TrueNode {
                                    if i < viewModel.numbersOfDays {
                                        Text("\(i + 1) ") +
                                        Text(" \(viewModel.planetGrid[i].planet.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize))
                                        + Text(" \(viewModel.planetGrid[i].degree) ")
                                        + Text(" \(viewModel.planetGrid[i].sign.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize))
                                        + Text(" R")
                                        
                                        
                                    } else {
                                        Text(" \(viewModel.planetGrid[i].planet.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize))
                                        + Text(" \(viewModel.planetGrid[i].degree) ")
                                        + Text(" \(viewModel.planetGrid[i].sign.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize))
                                        + Text(" R")
                                    }
                                } else {
                                    if i < viewModel.numbersOfDays {
                                        Text("\(i + 1) ") +
                                        Text(" \(viewModel.planetGrid[i].planet.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize))
                                        + Text(" \(viewModel.planetGrid[i].degree) ")
                                        + Text(" \(viewModel.planetGrid[i].sign.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize))
                                        
                                        
                                    } else {
                                        Text(" \(viewModel.planetGrid[i].planet.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize))
                                        + Text(" \(viewModel.planetGrid[i].degree) ")
                                        + Text(" \(viewModel.planetGrid[i].sign.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize))
                                    }
                                }
                            } else {
                                if i < viewModel.numbersOfDays {
                                    Text("\(i + 1) ") +
                                    Text(viewModel.getPlanetString(cell: viewModel.planetGrid[i]))
                                    
                                } else {
                                    Text(viewModel.getPlanetString(cell: viewModel.planetGrid[i]))
                                }
                            }
                            
                            
                        }
                    }
                }.padding(4)
                    
            }
        }
    }
}

#Preview {
    EphemerisView(viewModel: EphemerisViewModel(date :Date(), calculationSettings: CalculationSettings()))
}

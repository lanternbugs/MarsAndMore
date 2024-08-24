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
    var body: some View {
        VStack(alignment: .leading) {
            EphemerisButtonsView().environmentObject(viewModel)

            ScrollView([.horizontal, .vertical]) {
                if viewModel.showEphemerisKey && viewModel.showEphemerisSymbols {
                    AstroSymbolsKey(showAspectsSymbols: false)
                }
                let rows: [GridItem] = Array(repeating: .init(.flexible()), count: viewModel.numbersOfDays)
                LazyHGrid(rows: rows) {
                    let count: Int = viewModel.planetGrid.count
                    ForEach(0 ..< count, id: \.self) { i in
                        if viewModel.showEphemerisSymbols {
                            if i < viewModel.numbersOfDays {
                                HStack {
                                    Text("\(i + 1) ") +
                                    Text(" \(viewModel.planetGrid[i].planet.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: viewModel.symbolFontSize))
                                    + Text(" \(viewModel.planetGrid[i].degree) ")
                                    + Text("\(viewModel.planetGrid[i].sign.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: viewModel.symbolFontSize))
                                    + Text(" ")
                                }
                                
                            } else {
                                if viewModel.planetGrid[i].retrograde {
                                    HStack {
                                        Text(" \(viewModel.planetGrid[i].planet.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: viewModel.symbolFontSize))
                                        + Text(" \(viewModel.planetGrid[i].degree) ")
                                        + Text("\(viewModel.planetGrid[i].sign.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: viewModel.symbolFontSize))
                                        + Text(" R ").font(Font.custom("AstroDotBasic", size: viewModel.symbolFontSize))
                                    }
                                
                                } else {
                                    HStack {
                                        Text("\(viewModel.planetGrid[i].planet.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: viewModel.symbolFontSize))
                                        + Text(" \(viewModel.planetGrid[i].degree) ")
                                        + Text("\(viewModel.planetGrid[i].sign.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: viewModel.symbolFontSize))
                                        + Text(" ")
                                    }
                                }
                            } 
                        } else {
                            if i < viewModel.numbersOfDays {
                                HStack {
                                    Text("\(i + 1) ") +
                                    Text(viewModel.getPlanetString(cell: viewModel.planetGrid[i]))
                                }
                            } else {
                                HStack {
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


/*
 
 */

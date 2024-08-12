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

struct TransitTimesView: View {
    @Binding var transits: [TransitTime]
    let viewModel: TransitTimesViewModel
    let shouldShowTransitModel: TransitMundaneViewModel
#if os(iOS)
    let symbolFontSize = UIDevice.current.userInterfaceIdiom == .pad ? 24.0 : 18.0
#else
    let symbolFontSize = 20.0
#endif
    var body: some View {
        VStack {
            ForEach(transits.sorted(), id: \.time) {
                transit in
                HStack {
                    printTransit(transit)
                }
            }
        }
    }
}
extension TransitTimesView {
    @ViewBuilder
    func printTransit(_ transit: TransitTime) -> some View {
        if viewModel.shouldShowTransit(transit) {
            let displayTime = viewModel.getDisplayTime(transit: transit)
            var centerText = transit.sign != nil ? "Enters" : transit.aspect.getName()
            var finalText = transit.sign != nil ? transit.sign!.getName() : transit.planet2.getName()
            if shouldShowTransitModel.showTransitTimeSymbols && transit.planet != .Pholus {
                if transit.sign != nil {
                    Text(" \(transit.planet.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize)) + Text(" \(centerText) ") + Text("\(transit.sign!.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize)) + Text("  \(displayTime)")
                } else {
                    if (transit.planet2 != .Pholus) {
                        Text(" \(transit.planet.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize)) + Text(" \(transit.aspect.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize)) + Text(" \(transit.planet2.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize)) + Text("  \(displayTime)")
                        
                    } else {
                        Text(" \(transit.planet.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize)) + Text(" \(transit.aspect.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize)) + Text(" \(finalText)") + Text("  \(displayTime)")
                    }
                }
                Text(" ")
            } else {
#if os(macOS)
                if #available(macOS 12.0, *) {
                    Text("\(transit.planet.getName()) \(centerText) \(finalText) \(displayTime)").textSelection(.enabled)

                } else {
                    Text("\(transit.planet.getName()) \(centerText) \(finalText) \(displayTime)")
                }
#else
                if #available(iOS 15.0, *) {
                    Text("\(transit.planet.getName()) \(centerText) \(finalText) \(displayTime)").textSelection(.enabled)
                } else {
                    Text("\(transit.planet.getName()) \(centerText) \(finalText) \(displayTime)")
                }
#endif
            }
            Spacer()
        }
    }
}



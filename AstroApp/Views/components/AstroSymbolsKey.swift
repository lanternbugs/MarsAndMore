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
//  Created by Michael Adams on 8/9/24.
//

import SwiftUI

struct AstroSymbolsKey: View {
    let columns: [GridItem] =
                 Array(repeating: .init(.flexible()), count: 2)
    let showAspectsSymbols: Bool
#if os(iOS)
    let symbolFontSize = UIDevice.current.userInterfaceIdiom == .pad ? 32.0 : 20.0
#else
    let symbolFontSize = 32.0
#endif
    var body: some View {
        HStack {
            Text("Chart Planet Symbols").font(.title2)
            Spacer()
        }

        LazyVGrid(columns: columns) {
            ForEach(Planets.allCases, id: \.self) { planet in
                HStack {
                    if planet == .Lilith {
                        Text(" \(planet.getAstroCharacter().0)").font(Font.custom(planet.getAstroCharacter().1, size: symbolFontSize)) +
                        Text(" \(planet.getName())").font(.body)
                    } else {
                        Text(" \(planet.getAstroCharacter().0)").font(Font.custom(planet.getAstroCharacter().1, size: symbolFontSize)) +
                        Text(" \(planet.getLongName())").font(.body)
                    }
                    
                    Spacer()
                }
            }
        }
        Text("")
        HStack {
            Text("Chart Sign Symbols").font(.title2)
            Spacer()
        }

        LazyVGrid(columns: columns) {
            ForEach(Signs.allCases, id: \.self) { sign in
                switch(sign) {
                case .None:
                    HStack {
                        Text("")
                        Spacer()
                    }
                default:
                    HStack {
                        Text(" \(sign.getAstroCharacter().0)").font(Font.custom(sign.getAstroCharacter().1, size: symbolFontSize)) +
                        Text(" \(sign.getName())").font(.body)
                        Spacer()
                    }
                }
            }
        }
        
        if showAspectsSymbols {
            Text("")
            HStack {
                Text("Aspect Symbols").font(.title2)
                Spacer()
            }

            LazyVGrid(columns: columns) {
                ForEach(Aspects.allCases, id: \.rawValue) {
                    aspect in
                    HStack {
                        Text(" \(aspect.getAstroCharacter().0)").font(Font.custom(aspect.getAstroCharacter().1, size: symbolFontSize)) +
                        Text("  \(aspect.getName())").font(.body)
                        Spacer()
                    }
                }
            }
        }
            
    }
}

#Preview {
    AstroSymbolsKey(showAspectsSymbols: false)
}

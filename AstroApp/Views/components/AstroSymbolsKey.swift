//
//  AstroSymbolsKey.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/9/24.
//

import SwiftUI

struct AstroSymbolsKey: View {
    let columns: [GridItem] =
                 Array(repeating: .init(.flexible()), count: 2)
#if os(iOS)
    let symbolFontSize = UIDevice.current.userInterfaceIdiom == .pad ? 32.0 : 20.0
#else
    let symbolFontSize = 32.0
#endif
    var body: some View {
        VStack {
            HStack {
                Text("Chart Planet Symbols").font(.title2)
                Spacer()
            }

            LazyVGrid(columns: columns) {
                ForEach(Planets.allCases, id: \.self) { planet in
                    switch(planet) {
                    case .Pholus:
                        HStack {
                            Text(" \(planet.getName()) - No Symbol").font(.body)
                            Spacer()
                        }
                    case .Ascendant:
                        HStack {
                            Text(" \(planet.getName()) - Ascendant").font(.body)
                            Spacer()
                        }
                    case .MC:
                        HStack {
                            Text(" \(planet.getName()) - Medium Coeli").font(.body)
                            Spacer()
                        }
                    default:
                        HStack {
                            Text(" \(planet.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize))
                            Text(planet.getName()).font(.body)
                            Spacer()
                        }
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
                            Text(" \(sign.getAstroDotCharacter())").font(Font.custom("AstroDotBasic", size: symbolFontSize))
                            Text(sign.getName()).font(.body)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AstroSymbolsKey()
}
/*
*  Copyright (C) 2022 Michael R Adams.
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

import SwiftUI

struct ResourcesView: View {
    let astrologyKingAspects = "https://astrologyking.com/aspects/"
    let astrologyKingTransits = "https://astrologyking.com/transits/"
    let cafeAstrology = "https://cafeastrology.com/siteindex.html"
    let columns: [GridItem] =
                 Array(repeating: .init(.flexible()), count: 2)
#if os(iOS)
    let symbolFontSize = UIDevice.current.userInterfaceIdiom == .pad ? 32.0 : 20.0
#else
    let symbolFontSize = 32.0
#endif
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("For those new to Astrological Charts and wondering what does it mean, this page hopes to offer a few resources and tips").font(.headline)
                Text("First enter a name with a birth date in chart room by tapping + button to begin.").font(.body)
                Text("Planets button used with that name selected gives the signs the planets were in at birth or what is called the Natal Chart.").font(.body).padding([.bottom])
                Text("Signs are shortened to first three letters so Sco is Scorpio. If it says Jupiter is in Scorpio then users can Google natal jupiter scorpio").font(.headline)
                Text("Also two sites that come up near top of Google I've noticed for general info on all aspects or transits are astrologyking.com and cafeastrology.com. MarsAndMore has no affiliation with them.").font(.body)
                Text("Users can find text descriptions of Planets, Aspects and Transits that are shown in Chart Room at these three links below, versus just searching in a search engine.").font(.body)
                Button(action: {
                    self.openLink(link: cafeAstrology)
                }) {
                    Text(cafeAstrology).font(.body).foregroundColor(Color.blue)
                }.padding()
                Button(action: {
                    self.openLink(link: astrologyKingAspects)
                }) {
                    Text(astrologyKingAspects).font(.body).foregroundColor(Color.blue)
                }.padding()
                Button(action: {
                    self.openLink(link: astrologyKingTransits)
                }) {
                    Text(astrologyKingTransits).font(.body).foregroundColor(Color.blue)
                }.padding()
            }.padding([.trailing, .leading])
            HStack {
                Text("Major Aspects Shown").font(.title2)
                Spacer()
            }
            ForEach(Aspects.allCases, id: \.rawValue) {
                aspect in
                if aspect.isMajor() {
                    HStack {
                        Text("\(aspect.getName()) \(Int(aspect.rawValue))").font(.body)
                        Spacer()
                    }
                }
            }
            Text("")
            HStack {
                Text("Minor Aspects Shown").font(.title2)
                Spacer()
            }
            ForEach(Aspects.allCases, id: \.rawValue) {
                aspect in
                if !aspect.isMajor() {
                    HStack {
                        Text("\(aspect.getName()) \(Int(aspect.rawValue))").font(.body)
                        Spacer()
                    }
                }
            }

            Text("")
            HStack {
                Text("Wheel Chart Planet Symbols").font(.title2)
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
                    case .Ascendent:
                        HStack {
                            Text(" \(planet.getName()) - Ascendent").font(.body)
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
                Text("Wheel Chart Sign Symbols").font(.title2)
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
            Text("")
        }
        
    }
}

struct ResourcesView_Previews: PreviewProvider {
    static var previews: some View {
        ResourcesView()
    }
}

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

struct ReadingView: View {
    @Binding var state: RoomState
    @ViewBuilder
    var body: some View {
        let reading = state.getReading()
        ScrollView() {
            VStack {
                if case .Reading(let planet, let sign) = state
                {
                    Text("\(planet.getName()) in \(sign.getName())").padding()
                } else  if case .About = state
                {
                    Text("About Astrology Charts & Mars - More").padding()
                }
                
                ForEach(reading, id: \.id) { entry in
#if os(macOS)

            if #available(macOS 12.0, *) {
                Text("\(entry.text)").textSelection(.enabled).fixedSize(horizontal: false, vertical: true)

            } else {
                Text("\(entry.text)").fixedSize(horizontal: false, vertical: true)
            }

#else

            if #available(iOS 15.0, *) {
                Text("\(entry.text)").textSelection(.enabled).fixedSize(horizontal: false, vertical: true)
            } else {
                Text("\(entry.text)").fixedSize(horizontal: false, vertical: true)
            }

#endif
                }
                if case .Reading(let planet, _) = state
                {
                    if case  planet = Planets.Sun {
                        ReadingCreditsView(book: .YourPlaceSun)
                    } else {
                        ReadingCreditsView(book: .YourPlaceStars)
                    }
                
                } 
                else if state != .About {
                    ReadingCreditsView(book: .YourPlaceStars)
                }
                
            }
        }.padding(.vertical)
    }
}

struct ReadingView_Previews: PreviewProvider {
    @State static var reading = RoomState.Chart
    static var previews: some View {
        ReadingView(state: $reading)
    }
}

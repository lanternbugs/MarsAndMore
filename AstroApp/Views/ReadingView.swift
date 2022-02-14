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
                }
                
                ForEach(reading, id: \.id) { entry in
                    Text("\(entry.text)")
                }
                ReadingCreditsView()
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

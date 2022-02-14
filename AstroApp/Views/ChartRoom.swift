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

struct ChartRoom: View {
    @Binding var readingState: RoomState
    @State private var planetData: [DisplayPlanetRow] = Array<DisplayPlanetRow>()
    
    var body: some View {
        HStack {
            ChartView(data: $planetData, state: $readingState)
            Divider()
                   .padding([.leading, .trailing], 3)
            NamesView(state: $readingState)
        }
        .background(Image("night-sky", bundle: nil)
                        .resizable()
                        .aspectRatio(1 / 1, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                        .saturation(0.5)
                    .opacity(0.2))
            
    }
}

struct ChartRoom_Previews: PreviewProvider {
    @State static var state: RoomState = .Chart
    static var previews: some View {
        ChartRoom(readingState: $state)
    }
}
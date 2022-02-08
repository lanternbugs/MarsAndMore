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

struct DoneView: View {
    @Binding var readingState: RoomState
    let newReadingState: RoomState
    var body: some View {
        Button(action: {
            readingState = newReadingState
        }) {
            HStack(alignment: .center) {
                Text("<\(newReadingState.getName())")
                    .font(.title2)
                    .frame(minWidth: 20, alignment: .bottom).padding(0)
                Spacer()
            }.padding(.vertical)
            
        }
    }
}

struct DoneView_Previews: PreviewProvider {
    @State static var readingState:RoomState = .Chart
    static var previews: some View {
        DoneView(readingState: $readingState, newReadingState: .Chart)
    }
}

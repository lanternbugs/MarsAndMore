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

struct NameDataView: View {
    @Binding var state: RoomState
    var body: some View {
        Button(action: {
            state = .Cities
        }) {
            Text("Cities").font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct NameDataView_Previews: PreviewProvider {
    @State static var state: RoomState = .Cities
    static var previews: some View {
        NameDataView(state: $state)
    }
}

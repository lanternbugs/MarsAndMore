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

struct ArtTab: View {
    @Environment(\.roomState) private var artState
    var body: some View {
        VStack {
            switch(artState.wrappedValue) {
            case .Library:
                DoneView(newRoomState: .Art)
                ArtLibraryView()
            default:
                ArtView()
            }
        }
    }
}

struct ArtTab_Previews: PreviewProvider {
    static var previews: some View {
        ArtTab()
    }
}

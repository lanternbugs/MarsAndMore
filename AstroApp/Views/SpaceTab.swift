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

struct SpaceTab: View {
    @Environment(\.roomState) private var spaceState
    @EnvironmentObject private var manager: SpaceDataManager
    var body: some View {
        switch(spaceState.wrappedValue) {
        case .Picture:
            VStack {
                DoneView(newRoomState: .Space)
                NasaPhotoView()
            }
        default:
            SpaceView().onAppear {
                manager.checkForNewData()
                
            }
        }
    }
}

struct SpaceTab_Previews: PreviewProvider {
    static var previews: some View {
        SpaceTab()
    }
}

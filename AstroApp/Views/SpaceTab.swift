//
//  SpaceTab.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/26/22.
//

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

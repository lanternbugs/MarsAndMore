//
//  ArtTab.swift
//  MarsAndMore
//
//  Created by Michael Adams on 9/6/22.
//

import SwiftUI

struct ArtTab: View {
    @Environment(\.roomState) private var artState
    var body: some View {
        switch(artState.wrappedValue) {
        case .Library:
            VStack {
                DoneView(newRoomState: .Art)
                ArtLibraryView()
            }
        default:
            ArtView()
        }
    }
}

struct ArtTab_Previews: PreviewProvider {
    static var previews: some View {
        ArtTab()
    }
}

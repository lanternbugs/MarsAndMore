//
//  ArtLibraryView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 9/6/22.
//

import SwiftUI

struct ArtLibraryView: View {
    @EnvironmentObject private var artDataManager: ArtDataManager
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(artDataManager.libraryData, id: \.stringId) {
                    image in
                    ArtDisplayView(image: image, type: ImagePhotoType.Library)
                }
            }
        }
    }
}

struct ArtLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        ArtLibraryView()
    }
}

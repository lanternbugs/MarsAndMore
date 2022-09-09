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
                if artDataManager.libraryData.count  == 0 {
                    Text("No pictures have been saved yet. Above Mars and Venus Art users can select Add to Library")
                } else {
                    ForEach(artDataManager.libraryData, id: \.stringId) {
                        image in
                        ArtDisplayView(image: image, type: ImagePhotoType.Library)
                    }
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

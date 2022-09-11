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

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

struct NasaPhotoView: View {
    @EnvironmentObject private var manager: SpaceDataManager
    var body: some View {
        ScrollView {
            VStack {
                ForEach(manager.imageOfDayData, id: \.id) {
                    imageInfo in
                    Text(imageInfo.title).font(Font.headline.weight(.semibold))
                    switch imageInfo.mediaType
                    {
                    case .Picture:
                        DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .NasaPhotoOfDay, id: imageInfo.id, enity: .Nasa))
                        Text(imageInfo.description).font(Font.headline.weight(.regular))
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct NasaPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        NasaPhotoView()
    }
}

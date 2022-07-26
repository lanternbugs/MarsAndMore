//
//  PhotoView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/26/22.
//

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
                        DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .NasaPhotoOfDay, id: imageInfo.id))
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

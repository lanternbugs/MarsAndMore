//
//  SpaceView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/17/22.
//

import SwiftUI

struct SpaceView: View {
    @EnvironmentObject private var manager: SpaceDataManager
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Text("Photos Update Daily")
                    Spacer()
                }                
                
                ForEach(manager.imageOfDayData, id: \.id) {
                    imageInfo in
                    Text(imageInfo.title)
                    DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .NasaPhotoOfDay, id: imageInfo.id))
                }
                ForEach(manager.curiosityPhotos, id: \.id) {
                    imageInfo in
                    Text(imageInfo.title)
                    Text(imageInfo.description)
                    DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .Curiosity, id: imageInfo.id))
                }
            }
        }
    }
}

struct SpaceView_Previews: PreviewProvider {
    static var previews: some View {
        SpaceView()
    }
}

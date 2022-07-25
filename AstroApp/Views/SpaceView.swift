//
//  SpaceView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/17/22.
//

import SwiftUI

struct SpaceView: View {
    @EnvironmentObject private var manager: SpaceDataManager
    @State private var roverChoice: NASAPhotoType = NASAPhotoType.Curiosity
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Text("Photos Update Daily").font(.title)
                    Spacer()
                }                
                
                ForEach(manager.imageOfDayData, id: \.id) {
                    imageInfo in
                    Text(imageInfo.title)
                    DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .NasaPhotoOfDay, id: imageInfo.id))
                }
                HStack {
                    Spacer()
                    Text("Mars Rovers").font(.title)
                    Spacer()
                }
                Picker(selection: $roverChoice, label: Text("Rover")) {
                    Text(NASAPhotoType.Curiosity.rawValue).tag(NASAPhotoType.Curiosity)
                    Text(NASAPhotoType.Opportunity.rawValue).tag(NASAPhotoType.Opportunity)
                    Text(NASAPhotoType.Spirit.rawValue).tag(NASAPhotoType.Spirit)
                }.background(Color.white).pickerStyle(SegmentedPickerStyle())
                switch(roverChoice) {
                case .Curiosity:
                    ForEach(manager.curiosityPhotos, id: \.id) {
                        imageInfo in
                        Text(imageInfo.title)
                        Text(imageInfo.description)
                        DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .Curiosity, id: imageInfo.id))
                    }
                case .Opportunity:
                    ForEach(manager.opportunityPhotos, id: \.id) {
                        imageInfo in
                        Text(imageInfo.title)
                        Text(imageInfo.description)
                        DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .Opportunity, id: imageInfo.id))
                    }
                case .Spirit:
                    ForEach(manager.spiritPhotos, id: \.id) {
                        imageInfo in
                        Text(imageInfo.title)
                        Text(imageInfo.description)
                        DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .Spirit, id: imageInfo.id))
                    }
                default:
                    Text("Error, invalid picker choice ")
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

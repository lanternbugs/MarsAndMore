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

struct SpaceView: View {
    @EnvironmentObject private var manager: SpaceDataManager
    @Environment(\.roomState) private var spaceState
    @AppStorage("roverChoice") private var roverChoice: ImagePhotoType = ImagePhotoType.Curiosity
    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    Spacer()
                    Text("Photos Update Daily").font(.title)
                    Spacer()
                }                
                
                ForEach(manager.imageOfDayData, id: \.id) {
                    imageInfo in
                    Text(imageInfo.title).font(Font.headline.weight(.semibold))
                    switch imageInfo.mediaType
                    {
                    case .Video:
                        Button(action:  { openURL(url: imageInfo.url) }) {
                            Text("Open Video")
                        }
                    case .Picture:
                        Button(action:  { spaceState.wrappedValue = RoomState.Picture }) {
                            Text("Nasa Picture of Day")
                        }
                    }
                    
                }
                HStack {
                    Spacer()
                    Text("Mars Rovers").font(.title)
                    Spacer()
                }
                Picker(selection: $roverChoice, label: Text("Rover")) {
                    Text(ImagePhotoType.Curiosity.rawValue).tag(ImagePhotoType.Curiosity)
                    Text(ImagePhotoType.Opportunity.rawValue).tag(ImagePhotoType.Opportunity)
                    Text(ImagePhotoType.Spirit.rawValue).tag(ImagePhotoType.Spirit)
                }.background(Color.white).pickerStyle(SegmentedPickerStyle())
                switch(roverChoice) {
                case .Curiosity:
                    ForEach(manager.curiosityPhotos, id: \.id) {
                        imageInfo in
                        Text(imageInfo.title).font(Font.headline.weight(.semibold)).id(UUID())
                        Text(imageInfo.description).font(Font.headline.weight(.regular)).id(UUID())
                        DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .Curiosity, id: imageInfo.id, enity: .Nasa)).id(UUID())
                    }
                case .Opportunity:
                    ForEach(manager.opportunityPhotos, id: \.id) {
                        imageInfo in
                        Text(imageInfo.title).font(Font.headline.weight(.semibold)).id(UUID())
                        Text(imageInfo.description).font(Font.headline.weight(.regular)).id(UUID())
                        DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .Opportunity, id: imageInfo.id, enity: .Nasa)).id(UUID())
                    }
                case .Spirit:
                    ForEach(manager.spiritPhotos, id: \.id) {
                        imageInfo in
                        Text(imageInfo.title).font(Font.headline.weight(.semibold)).id(UUID())
                        Text(imageInfo.description).font(Font.headline.weight(.regular)).id(UUID())
                        DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .Spirit, id: imageInfo.id, enity: .Nasa)).id(UUID())
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

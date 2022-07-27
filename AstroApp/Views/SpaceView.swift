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
                    Text(NASAPhotoType.Curiosity.rawValue).tag(NASAPhotoType.Curiosity)
                    Text(NASAPhotoType.Opportunity.rawValue).tag(NASAPhotoType.Opportunity)
                    Text(NASAPhotoType.Spirit.rawValue).tag(NASAPhotoType.Spirit)
                }.background(Color.white).pickerStyle(SegmentedPickerStyle())
                switch(roverChoice) {
                case .Curiosity:
                    ForEach(manager.curiosityPhotos, id: \.id) {
                        imageInfo in
                        Text(imageInfo.title).font(Font.headline.weight(.semibold))
                        Text(imageInfo.description).font(Font.headline.weight(.regular))
                        DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .Curiosity, id: imageInfo.id))
                    }
                case .Opportunity:
                    ForEach(manager.opportunityPhotos, id: \.id) {
                        imageInfo in
                        Text(imageInfo.title).font(Font.headline.weight(.semibold))
                        Text(imageInfo.description).font(Font.headline.weight(.regular))
                        DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .Opportunity, id: imageInfo.id))
                    }
                case .Spirit:
                    ForEach(manager.spiritPhotos, id: \.id) {
                        imageInfo in
                        Text(imageInfo.title).font(Font.headline.weight(.semibold))
                        Text(imageInfo.description).font(Font.headline.weight(.regular))
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

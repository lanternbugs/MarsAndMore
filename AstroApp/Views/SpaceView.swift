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
    @State var scaleFactor = 3.0
    @State var opaqueValue = 0.0
    @State var rotationAngle = 4.0
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
                        }.scaleEffect(manager.nasaPhotoAnimationRan ? CGSize(width: 1.0, height: 1.0) : CGSize(width: scaleFactor, height: scaleFactor)).opacity(manager.nasaPhotoAnimationRan ? 1 : opaqueValue).rotationEffect(.radians(manager.nasaPhotoAnimationRan ? 0 : rotationAngle))
                    }
                    
                }
                HStack {
                    Spacer()
                    Text("Curiosity Rover").font(.title)
                    Spacer()
                }
                ForEach(manager.curiosityPhotos, id: \.id) {
                    imageInfo in
                    Text(imageInfo.title).font(Font.headline.weight(.semibold)).id(UUID())
                    Text(imageInfo.description).font(Font.headline.weight(.regular)).id(UUID())
                    DelayedImageView(url: imageInfo.url, key: PhotoKey(type: .Curiosity, id: imageInfo.id, enity: .Nasa)).id(UUID())
                    
                }
                    
                   
            }
        }.onAppear() {
            withAnimation(.easeIn(duration: 0.4)) {
                manager.nasaPhotoAnimationRan = true
              }
        }
    }
}

struct SpaceView_Previews: PreviewProvider {
    static var previews: some View {
        SpaceView()
    }
}

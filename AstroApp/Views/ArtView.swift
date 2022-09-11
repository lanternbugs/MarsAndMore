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

struct ArtView: View {
    @EnvironmentObject private var artDataManager: ArtDataManager
    @Environment(\.roomState) private var artState
    @AppStorage("artChoice") private var artChoice: Planets = Planets.Mars
    var body: some View {
        ScrollView {
            
            
            LazyVStack {
                HStack {
                    Spacer()
                    Text("Mars and Venus themed Art").font(.title)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("Images update daily").font(.title)
                    Spacer()
                }
                Button(action: { artState.wrappedValue = .Library }) {
                    Text("Library")
                }
                
                Picker(selection: $artChoice, label: Text("Choice")) {
                    Text("Mars").tag(Planets.Mars)
                    Text("Venus").tag(Planets.Venus)
                }.background(Color.white).pickerStyle(SegmentedPickerStyle())
                switch artChoice {
                case .Mars:
                    ForEach(artDataManager.marsArtData, id: \.stringId) {
                        image in
                        ArtDisplayView(image: image, type: ImagePhotoType.MarsArt)
                    }
                case .Venus:
                    ForEach(artDataManager.venusArtData, id: \.stringId) {
                        image in
                        ArtDisplayView(image: image, type: ImagePhotoType.VenusArt)
                    }
                default:
                    EmptyView()
                }
                
            }
        }.onAppear {
            artDataManager.checkForNewData()
            
        }
    }
}

struct ArtView_Previews: PreviewProvider {
    static var previews: some View {
        ArtView()
    }
}

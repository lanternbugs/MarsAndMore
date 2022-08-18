//
//  ArtView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/11/22.
//

import SwiftUI

struct ArtView: View {
    @EnvironmentObject private var artDataManager: ArtDataManager
    @State private var planetChoice: Planets = Planets.Mars
    var body: some View {
        ScrollView {
            
            
            LazyVStack {
                HStack {
                    Spacer()
                    Text("Mars and Venus themed Art")
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("Images update daily")
                    Spacer()
                }
                Picker(selection: $planetChoice, label: Text("Choice")) {
                    Text("Mars").tag(Planets.Mars)
                    Text("Venus").tag(Planets.Venus)
                }.background(Color.white).pickerStyle(SegmentedPickerStyle())
                switch planetChoice {
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

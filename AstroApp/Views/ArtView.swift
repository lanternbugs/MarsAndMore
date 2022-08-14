//
//  ArtView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/11/22.
//

import SwiftUI

struct ArtView: View {
    @EnvironmentObject private var artDataManager: ArtDataManager
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(artDataManager.artData, id: \.id) {
                    image in
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text(image.name).textSelection(.enabled)
                if let artistName = image.artistDisplayName, artistName.count > 0 {
                    Text("by \(artistName)").textSelection(.enabled)
                }
                if let objDate = image.objectDate {
                    Text(objDate).textSelection(.enabled)
                }
                Text(String(image.objectId)).textSelection(.enabled)
                
            }
            else {
                Text(image.name)
                if let artistName = image.artistDisplayName, artistName.count > 0 {
                    Text("by \(artistName)")
                }
                if let objDate = image.objectDate {
                    Text(objDate)
                }
                Text(String(image.objectId))
                }
#else
            if #available(iOS 15.0, *) {
                Text(image.name).textSelection(.enabled)
                if let artistName = image.artistDisplayName, artistName.count > 0 {
                    Text("by \(artistName)").textSelection(.enabled)
                }
                if let objDate = image.objectDate {
                    Text(objDate).textSelection(.enabled)
                }
                Text(String(image.objectId)).textSelection(.enabled)
            }
            else {
                Text(image.name)
                if let artistName = image.artistDisplayName, artistName.count > 0 {
                    Text("by \(artistName)")
                }
                if let objDate = image.objectDate {
                    Text(objDate)
                }
                Text(String(image.objectId))
                }
#endif
                    DelayedImageView(url: image.url, key: nil)
                }
            }
        }
    }
}

struct ArtView_Previews: PreviewProvider {
    static var previews: some View {
        ArtView()
    }
}

//
//  ArtDisplayView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/15/22.
//

import SwiftUI

struct ArtDisplayView: View {
    let image: MetImageData
    let type: ImagePhotoType
    var body: some View {
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text(image.name).textSelection(.enabled)
                if let artistName = image.artistDisplayName, artistName.count > 0 {
                    Text("by \(artistName)").textSelection(.enabled)
                }
                if let objDate = image.objectDate {
                    Text(objDate).textSelection(.enabled)
                }
                Text("MET id: " + String(image.objectId)).textSelection(.enabled)
                
            }
            else {
                Text(image.name)
                if let artistName = image.artistDisplayName, artistName.count > 0 {
                    Text("by \(artistName)")
                }
                if let objDate = image.objectDate {
                    Text(objDate)
                }
                Text("MET id: " + String(image.objectId))
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
            }
            else {
                Text(image.name)
                if let artistName = image.artistDisplayName, artistName.count > 0 {
                    Text("by \(artistName)")
                }
                if let objDate = image.objectDate {
                    Text(objDate)
                }
                }
#endif
        DelayedImageView(url: image.url, key: PhotoKey(type: type, id: image.id, enity: ImageEnities.Met))
                }
}

struct ArtDisplayView_Previews: PreviewProvider {
    static var image = MetImageData(objectId: 0, name: "image", artistDisplayName: nil, objectDate: nil, objectName: nil, url: URL(string: "https://www.google.com")!, id: 0, stringId: UUID().uuidString)
    static var type = ImagePhotoType.MarsArt
    static var previews: some View {
        ArtDisplayView(image: image, type: type)
    }
}

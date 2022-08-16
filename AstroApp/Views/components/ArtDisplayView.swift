//
//  ArtDisplayView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/15/22.
//

import SwiftUI

struct ArtDisplayView: View {
    let image: MetImageData
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

struct ArtDisplayView_Previews: PreviewProvider {
    static var image = MetImageData(objectId: 0, name: "image", artistDisplayName: nil, objectDate: nil, objectName: nil, url: URL(string: "https://www.google.com")!, id: UUID().uuidString)
    static var previews: some View {
        ArtDisplayView(image: image)
    }
}

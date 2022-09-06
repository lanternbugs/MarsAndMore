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
    @EnvironmentObject private var artDataManager: ArtDataManager
    var body: some View {
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text(image.name).textSelection(.enabled).font(Font.headline.weight(.regular))
                if let artistName = image.artistDisplayName, artistName.count > 0 {
                    Text("by \(artistName)").font(Font.headline.weight(.regular)).textSelection(.enabled)
                }
                if let objDate = image.objectDate {
                    Text(objDate).textSelection(.enabled).font(Font.headline.weight(.regular))
                }
                //Text("MET id: " + String(image.objectId)).font(Font.headline.weight(.regular)).textSelection(.enabled)
                
            }
            else {
                Text(image.name).font(Font.headline.weight(.regular))
                if let artistName = image.artistDisplayName, artistName.count > 0 {
                    Text("by \(artistName)").font(Font.headline.weight(.regular))
                }
                if let objDate = image.objectDate {
                    Text(objDate).font(Font.headline.weight(.regular))
                }
                }
#else
            if #available(iOS 15.0, *) {
                Text(image.name).textSelection(.enabled).font(Font.headline.weight(.regular))
                if let artistName = image.artistDisplayName, artistName.count > 0 {
                    Text("by \(artistName)").font(Font.headline.weight(.regular)).textSelection(.enabled)
                }
                if let objDate = image.objectDate {
                    Text(objDate).textSelection(.enabled).font(Font.headline.weight(.regular))
                }
            }
            else {
                Text(image.name).font(Font.headline.weight(.regular))
                if let artistName = image.artistDisplayName, artistName.count > 0 {
                    Text("by \(artistName)").font(Font.headline.weight(.regular))
                }
                if let objDate = image.objectDate {
                    Text(objDate).font(Font.headline.weight(.regular))
                }
                }
#endif
        HStack {
            Spacer()
            if artDataManager.libraryData.first { $0.objectId == image.objectId} == nil {
                Button(action: { artDataManager.saveToLibrary(image: image, type: type) }) {
                    Text("Add to Library")
                }
            }
            Spacer()
            
        }
        switch type {
        case .Library:
            DelayedImageView(url: image.url, key: PhotoKey(type: type, id: image.objectId + ArtDataManager.libraryOffset, enity: ImageEnities.Met))
        default:
            DelayedImageView(url: image.url, key: PhotoKey(type: type, id: image.id, enity: ImageEnities.Met))
        }
        
    }
}

struct ArtDisplayView_Previews: PreviewProvider {
    static var image = MetImageData(objectId: 0, name: "image", artistDisplayName: nil, objectDate: nil, objectName: nil, url: URL(string: "https://www.google.com")!, id: 0, stringId: UUID().uuidString)
    static var type = ImagePhotoType.MarsArt
    static var previews: some View {
        ArtDisplayView(image: image, type: type)
    }
}

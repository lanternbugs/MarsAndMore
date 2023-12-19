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

struct ArtDisplayView: View {
    let image: MetImageData
    let type: ImagePhotoType
    @State private var showButton = true
    @State private var showWarning = false
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
        switch type {
        case .Library:
            if showWarning {
                HStack {
                    Button(action: {
                        if showButton {
                            deleteFromLibrary(id: image.objectId)
                            showButton = false
                            // we want the button back if they later delete image from library and go back to this view but this provides a long lock till the core data layer is done.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                showButton = true
                            }
                        }
                        
                    }) {
                        Text("Delete")
                    }
                    Button(action: { showWarning = false }) {
                        Text("Cancel")
                    }
                    Text(" Are you sure? ")
                    Spacer()
                }
            } else {
                HStack {
                    Spacer()
                    if artDataManager.libraryData.first(where: { $0.objectId == image.objectId}) != nil && showButton {
                        Button(action: {
                            if showButton {
                                showWarning = true
                            }
                            
                        }) {
                            Text("Delete from Library")
                        }
                    }
                    Spacer()
                    
                }
            }
            
        default:
            HStack {
                Spacer()
                if artDataManager.libraryData.first(where: { $0.objectId == image.objectId}) == nil && showButton {
                    Button(action: {
                        if showButton {
                            artDataManager.saveToLibrary(image: image, type: type)
                            showButton = false
                            // we want the button back if they later delete image from library and go back to this view but this provides a long lock till the core data layer is done.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                showButton = true
                            }
                        }
                        
                    }) {
                        Text("Add to Library")
                    }
                }
                Spacer()
                
            }
        }
        
        switch type {
        case .Library:
            DelayedImageView(url: image.url, key: PhotoKey(type: type, id: image.libraryKey, enity: ImageEnities.Met))
        default:
            DelayedImageView(url: image.url, key: PhotoKey(type: type, id: image.id, enity: ImageEnities.Met))
        }
        
    }
}

extension ArtDisplayView {
    func deleteFromLibrary(id: Int)
    {
        for (i, img) in artDataManager.libraryData.enumerated() {
            if img.objectId == id {
                artDataManager.libraryData.remove(at: i)
                artDataManager.deleteFromLibrary(image: img)
                break
            }
            
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

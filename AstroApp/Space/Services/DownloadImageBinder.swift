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


import Foundation
import Combine
#if os(macOS)
import Cocoa
typealias UIImage = NSImage
#elseif os(iOS)
    import UIKit
#endif
class DownloadImageBinder: ObservableObject {
    private var subscription: AnyCancellable?
    @Published private(set) var image: UIImage?
    func load(url: URL, key: PhotoKey?) {
        var saveMode = false
#if DEBUG
        saveMode = SpaceDataManager.saveMode
#endif
        if !saveMode, let key = key, let uiimage = SpaceDataManager.getPhotoForKeyOrNil(key: key) {
           image = uiimage
            switch key.type {
            case .MarsArt, .VenusArt:
                ArtDataManager.updateImage(image: uiimage, type: key.type, id: key.id)
            default:
                break
            }
           return
        }
         URLSession.shared
                               .dataTaskPublisher(for: url)
                               .map { UIImage(data: $0.data) }
                               .replaceError(with: nil)
                               .handleEvents(receiveOutput: {
#if os(macOS)
                                   #if DEBUG
                                   if SpaceDataManager.saveMode {
                                           if let img = $0  {
                                               SpaceDataManager.saveNasaPhotoToFile(image: img, url: url)
                                           }
                                   }
                                   #endif
#endif
                                   if let img = $0, let key = key {
                                       switch key.type {
                                       case .MarsArt, .VenusArt:
#if os(macOS)

            let compressedImage = img.jpgData()
            let img = NSImage.init(data: compressedImage)
                                           
#elseif os(iOS)
                                           guard let compressedImage = img.jpegData(compressionQuality: CGFloat(JPEGQuality.low.rawValue)) else {
                                               return
                                           }
            let img = UIImage(data: compressedImage)
#endif
                                           if let img = img {
                                               ArtDataManager.updateImage(image: img, type: key.type, id: key.id)
                                               SpaceDataManager.setPhotoForKey(key: key, image: img)
                                           }
                                           
                                       default:
                                           SpaceDataManager.setPhotoForKey(key: key, image: img)
                                       }
                                       
                                       
                                   }})
                               .receive(on: DispatchQueue.main)
                               .assign(to: &$image)
    }
    
    func saveImage(key: PhotoKey, img: UIImage)
    {
        
    }
}

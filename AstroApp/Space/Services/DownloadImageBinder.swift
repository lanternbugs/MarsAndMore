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
    func load(url: URL, key: PhotoKey) {
        if let uiimage = SpaceDataManager.getPhotoForKeyOrNil(key: key) {
           image = uiimage
           return
        }
        subscription = URLSession.shared
                               .dataTaskPublisher(for: url)
                               .map { UIImage(data: $0.data) }
                               .replaceError(with: nil)
                               .handleEvents(receiveOutput: {
                                   if let img = $0 {
                                       SpaceDataManager.setPhotoForKey(key: key, image: img)
                                   }})
                               .receive(on: DispatchQueue.main)
                               .assign(to: \.image, on: self)
    }
    func cancel() {
        subscription?.cancel()
    }
}

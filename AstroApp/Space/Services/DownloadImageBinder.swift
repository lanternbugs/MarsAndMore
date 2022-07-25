//
//  DownloadImageBinder.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/17/22.
//

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

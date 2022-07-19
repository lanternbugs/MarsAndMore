//
//  DownloadImageBinder.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/17/22.
//

import Foundation
import Combine
import UIKit
// 1
class DownloadImageBinder: ObservableObject {
    private var subscription: AnyCancellable?
    @Published private(set) var image: UIImage?
    func load(url: URL) {
        subscription = URLSession.shared
                               .dataTaskPublisher(for: url)
                               .map { UIImage(data: $0.data) }
                               .replaceError(with: nil)
                               .receive(on: DispatchQueue.main)
                               .assign(to: \.image, on: self)
    }
    func cancel() {
        subscription?.cancel()
    }
}

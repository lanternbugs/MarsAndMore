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
                    Text(image.name)
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text(String(image.objectId)).textSelection(.enabled)
            }
            else {
                Text(String(image.objectId))
                }
#else
            if #available(iOS 15.0, *) {
                Text(String(image.objectId)).textSelection(.enabled)
            }
            else {
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

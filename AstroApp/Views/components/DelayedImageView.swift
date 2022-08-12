//
//  NasaImageViewWithLateURL.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/17/22.
//

import SwiftUI

struct DelayedImageView: View {
    @ObservedObject var binder = DownloadImageBinder()
    init(url: URL, key: PhotoKey?) {
        binder.load(url: url, key: key)
    }
    var body: some View {
        VStack {
            
            if binder.image != nil {
#if os(macOS)
                Image(nsImage: binder.image!)
                    .imageModifierFitScreen()
                    
#elseif os(iOS)
                Image(uiImage: binder.image!)
                    .imageModifierFitScreen()
#endif
                
            } else {
                HStack {
                    Spacer()
                    Image("placeholder", bundle: nil).imageModifierFitScreen()
                    Spacer()
                }
            }
                    
        }.onAppear {  }
                
    }
}

struct DelayedImageView_Previews: PreviewProvider {
    static var url = URL(string: "https://www.google.com")!
    static var key = PhotoKey(type: .Curiosity, id: 0)
    static var previews: some View {
        DelayedImageView(url: url, key: key)
    }
}

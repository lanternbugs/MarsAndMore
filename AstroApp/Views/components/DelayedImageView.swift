//
//  NasaImageViewWithLateURL.swift
//  MarsAndMore
//
//  Created by Michael Adams on 7/17/22.
//

import SwiftUI

struct DelayedImageView: View {
    @ObservedObject var binder = DownloadImageBinder()
    var url: URL
    init(url: URL) {
        self.url = url
        binder.load(url: self.url)
    }
    var body: some View {
        VStack {
            
            if binder.image != nil {
                Image(uiImage: binder.image!)
                    .renderingMode(.original)
                    .resizable()
            } else {
                HStack {
                    Spacer()
                    Text("No Image Yet")
                    Spacer()
                }
            }
                    
        }.onAppear {  }
        .onDisappear { self.binder.cancel() }
                
    }
}

struct DelayedImageView_Previews: PreviewProvider {
    static var url = URL(string: "https://www.google.com")!
    static var previews: some View {
        DelayedImageView(url: url)
    }
}

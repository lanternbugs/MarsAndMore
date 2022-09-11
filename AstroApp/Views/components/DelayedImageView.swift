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
    static var key = PhotoKey(type: .Curiosity, id: 0, enity: .Nasa)
    static var previews: some View {
        DelayedImageView(url: url, key: key)
    }
}

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
extension Image {
    func imageModifierFitScreen() -> some View {
        
#if os(macOS)
        self.resizable().aspectRatio(contentMode: .fit)
                    .frame(maxWidth: NSScreen.main?.visibleFrame.size.width, maxHeight: NSScreen.main?.visibleFrame.size.height)
                    
#elseif os(iOS)
        self.resizable().aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.size.width, maxHeight: UIScreen.main.bounds.size.height)
#endif
   }
}

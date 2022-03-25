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
extension View {
  func namesStyle() -> some View {
    ModifiedContent(
      content: self,
      modifier: NamesTextModifier()
    )
  }
  func selectedNameColor() -> some View {
    ModifiedContent(
        content: self,
        modifier: SelectedNameModifier()
      )
   }
    
    func openLink(link: String)->Void {
        if let url = URL(string: link) {
#if os(iOS)
            UIApplication.shared.open(url)
#elseif os(macOS)
            NSWorkspace.shared.open(url)
#endif
           
        }
    }
}

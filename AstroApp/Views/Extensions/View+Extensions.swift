//
//  View+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/18/22.
//

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

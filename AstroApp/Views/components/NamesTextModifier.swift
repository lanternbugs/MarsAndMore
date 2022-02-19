//
//  NamesTextModifier.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/18/22.
//

import SwiftUI

struct NamesTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.padding(.trailing)
            .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
    }
}



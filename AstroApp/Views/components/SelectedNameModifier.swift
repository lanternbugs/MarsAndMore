//
//  SelectedNameModifier.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/18/22.
//

import SwiftUI

struct SelectedNameModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundColor(Color.black)
            .background(Color.green)
    }
}

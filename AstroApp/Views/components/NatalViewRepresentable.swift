//
//  NatalViewRepresentable.swift
//  MarsAndMore
//
//  Created by Michael Adams on 12/1/23.
//

import Foundation
import SwiftUI

#if os(iOS)
struct NatalViewRepresentable: UIViewRepresentable {
    let model: NatalChartViewModel

    func makeUIView(context: Context) -> NatalChartDrawingView {
        NatalChartDrawingView(model: model)
    }

    func updateUIView(_ uiView: NatalChartDrawingView, context: Context) {
        
    }
}

#else
struct NatalViewRepresentable: NSViewRepresentable {
    let model: NatalChartViewModel
    
    func makeNSView(context: Context) -> NatalChartDrawingView {
        NatalChartDrawingView(model: model)
    }
    
    func updateNSView(_ nsView: NatalChartDrawingView, context: Context) {
        
    }
    
    typealias NSViewType = NatalChartDrawingView
}
#endif


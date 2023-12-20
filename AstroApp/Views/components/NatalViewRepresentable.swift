/*
*  Copyright (C) 2022-23 Michael R Adams.
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
//  Created by Michael Adams on 12/1/23.
//

import Foundation
import SwiftUI

#if os(iOS)
struct NatalViewRepresentable: UIViewRepresentable {
    let model: ChartViewModel

    func makeUIView(context: Context) -> NatalChartDrawingView {
        if model.chart == .Transit {
            TransitChartDrawingView(model: model)
        } else {
            NatalChartDrawingView(model: model)
        }
        
    }

    func updateUIView(_ uiView: NatalChartDrawingView, context: Context) {
        
    }
}

#else
struct NatalViewRepresentable: NSViewRepresentable {
    let model: ChartViewModel
    
    func makeNSView(context: Context) -> NatalChartDrawingView {
        if model.chart == .Transit {
            TransitChartDrawingView(model: model)
        } else {
            NatalChartDrawingView(model: model)
        }
    }
    
    func updateNSView(_ nsView: NatalChartDrawingView, context: Context) {
        
    }
    
    typealias NSViewType = NatalChartDrawingView
}
#endif


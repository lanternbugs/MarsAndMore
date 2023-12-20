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
//  Created by Michael Adams on 12/19/23.
//

import Foundation
#if os(iOS)
import UIKit
#else
import Cocoa
#endif

class TransitChartDrawingView: NatalChartDrawingView {
    
#if os(iOS)
    override func draw(_ rect: CGRect) {
        drawTransitChart()
    }
#else
    override func draw(_ dirtyRect: NSRect) {
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
        drawTransitChart()
    }
#endif
    
}

extension TransitChartDrawingView {
    func drawTransitChart() {
        viewModel.setWidth(frame.width)
        viewModel.setHeight(frame.height)
        viewModel.populateData()
#if os(iOS)
        drawColoredArciOS(CGPoint(x: viewModel.center.x, y: viewModel.center.y), rad: viewModel.radius)
#else
        drawColoredArcMac(CGPoint(x: viewModel.center.x, y: viewModel.center.y), rad: viewModel.radius)
#endif
    }
}

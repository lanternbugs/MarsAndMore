//
//  NatalChartDrawingView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 12/1/23.
//

import Foundation
#if os(iOS)
import UIKit
class NatalChartDrawingView: UIView {
    typealias NSColor = UIColor
    typealias NSBezierPath = UIBezierPath
    
    let model: NatalChartViewModel
    override init(frame frameRect: CGRect) {
        model = NatalChartViewModel()
        super.init(frame: frameRect)
    }

    required init(coder: NSCoder) {
        model = NatalChartViewModel()
        super.init(coder: coder)!
    }

    init(model: NatalChartViewModel) {
        self.model = model
        super.init(frame: CGRect.zero)
        backgroundColor = NSColor.white
    }
    
    override func draw(_ rect: CGRect) {
        drawChart()
    }
}

#else
import Cocoa
class NatalChartDrawingView: NSView {
    let model: NatalChartViewModel
    override init(frame frameRect: NSRect) {
        model = NatalChartViewModel()
        super.init(frame: frameRect);
    }

    required init(coder: NSCoder) {
        model = NatalChartViewModel()
        super.init(coder: coder)!
    }

    init(model: NatalChartViewModel) {
        self.model = model
        super.init(frame: NSRect.zero);
    }
    
    override func draw(_ dirtyRect: NSRect) {
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
        drawChart()
    }
}
#endif

extension NatalChartDrawingView {
    func drawChart() {
        let width = frame.width
        let height = frame.height
        
        let radius = frame.width < frame.height ? width / 2.0 : height / 2.0
        let center: (x: Double, y: Double) = (width / 2.0, width / 2 -  ((width - height) / 2.0))
        drawColoredArc(CGPoint(x: center.x, y: center.y), rad: radius)
        drawCircle(center, radius: radius * 0.40)
    }
    
    func drawCircle(_ center: (Double, Double), radius: Double, lineWidth: Double = 1) {
        let fillColor: NSColor = NSColor.white
        let strokeColor: NSColor = NSColor.black
        let oval = NSBezierPath.init(ovalIn: CGRect(x: frame.width / 2.0 - radius, y: frame.height / 2.0 - radius, width: radius * 2, height: radius * 2))
        oval.close()
            oval.lineWidth = lineWidth
            fillColor.set()
            oval.fill()
            strokeColor.set()
            oval.stroke()
    }
    
    func drawColoredArc( _ center: CGPoint, rad: Double) {
        var strokeWidth = 30.0
        var strokeColor: NSColor = NSColor.green
        var startAngleRadian: Double = 0
        var endAngleRadian =   30.0
#if os(iOS)
        endAngleRadian = Double.pi / 6.0
        strokeWidth = 20.0
#endif
        let radius = rad - strokeWidth / 2.0
        for segment in 1...12 {
            let arc = NSBezierPath.init()
#if os(iOS)
            arc.addArc(withCenter: center, radius: radius, startAngle: startAngleRadian, endAngle: endAngleRadian, clockwise: true)
#else
            arc.appendArc(withCenter: center, radius: radius, startAngle: startAngleRadian, endAngle: endAngleRadian, clockwise: false)
#endif
            arc.lineWidth = strokeWidth
            if segment % 4 == 0 {
                strokeColor = NSColor.green
                //NSColor(red: 0, green: 173.0, blue: 0, alpha: 1.0)
                
            } else if segment % 4 == 1 {
                strokeColor = NSColor.red
                
            } else if segment % 4 == 2 {
                strokeColor = NSColor.blue
                
            } else if segment % 4 == 3 {
                strokeColor = NSColor.yellow
            }
            strokeColor.set()
            arc.stroke()
            startAngleRadian = endAngleRadian
#if os(iOS)
            endAngleRadian += .pi / 6.0
#else
            endAngleRadian += 30.0
#endif
            
            
        }
    }
}

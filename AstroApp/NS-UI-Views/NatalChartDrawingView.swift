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
    let model: NatalChartViewModel
    override init(frame frameRect: CGRect) {
        model = NatalChartViewModel()
        super.init(frame: frameRect);
    }

    required init(coder: NSCoder) {
        model = NatalChartViewModel()
        super.init(coder: coder)!
    }

    init(model: NatalChartViewModel) {
        self.model = model
        super.init(frame: CGRect.zero);
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
        let width = frame.width
        let height = frame.height
        
        let radius = frame.width < frame.height ? width / 2.0 : height / 2.0
        let center: (x: Double, y: Double) = (width / 2.0, width / 2 -  ((width - height) / 2.0))
        //drawCircle(center, radius: radius * 0.95, lineWidth: 30.0)
        //drawCircle(center, radius: radius * 0.80)
        drawColoredArc(CGPoint(x: center.x, y: center.y), rad: radius)
        drawCircle(center, radius: radius * 0.40)

    }
    func drawColoredArc( _ center: CGPoint, rad: Double) {
        guard let ctx = NSGraphicsContext.current?.cgContext else {
            return
        }
        let strokeWidth = 30.0
        let radius = rad - strokeWidth / 2.0
        var strokeColor: NSColor = NSColor.green
        var startAngleRadian: Double = 0
        var endAngleRadian =   30.0
        
        for segment in 1...12 {
            let arc = NSBezierPath.init()
            arc.appendArc(withCenter: center, radius: radius, startAngle: startAngleRadian, endAngle: endAngleRadian, clockwise: false)
            ctx.saveGState()
            arc.lineWidth = 30.0
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
            ctx.restoreGState()
            startAngleRadian = endAngleRadian
            endAngleRadian += 30.0
        }
        

            
    }
    func drawCircle(_ center: (Double, Double), radius: Double, lineWidth: Double = 1) {
        let fillColor: NSColor = NSColor.white
        let strokeColor: NSColor = NSColor.black
        guard let ctx = NSGraphicsContext.current?.cgContext else {
            return
        }
        let oval = NSBezierPath.init(ovalIn: CGRect(x: frame.width / 2.0 - radius, y: frame.height / 2.0 - radius, width: radius * 2, height: radius * 2))
        oval.close()
        ctx.saveGState()
           // let offset = weight / 2 + 1
           // ctx.translateBy(x: offset, y: offset)

            //path.lineWidth = weight
            oval.lineWidth = lineWidth
            fillColor.set()
            oval.fill()
            strokeColor.set()
            oval.stroke()
            ctx.restoreGState()
        
    }

    
}
#endif

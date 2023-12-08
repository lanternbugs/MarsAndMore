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
    
    var viewModel: NatalChartViewModel
    override init(frame frameRect: CGRect) {
        viewModel = NatalChartViewModel()
        super.init(frame: frameRect)
    }

    required init(coder: NSCoder) {
        viewModel = NatalChartViewModel()
        super.init(coder: coder)!
    }

    init(model: NatalChartViewModel) {
        self.viewModel = model
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
    var viewModel: NatalChartViewModel
    override init(frame frameRect: NSRect) {
        viewModel = NatalChartViewModel()
        super.init(frame: frameRect);
    }

    required init(coder: NSCoder) {
        viewModel = NatalChartViewModel()
        super.init(coder: coder)!
    }

    init(model: NatalChartViewModel) {
        self.viewModel = model
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
        viewModel.setWidth(frame.width)
        viewModel.setHeight(frame.height)
        
        drawColoredArc(CGPoint(x: viewModel.center.x, y: viewModel.center.y), rad: viewModel.radius)
        drawCircle(viewModel.center, radius: viewModel.radius * 0.40)
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
        var startAngleRadian: Double = viewModel.getChartStartDegree()
#if os(iOS)
        startAngleRadian = 360 - startAngleRadian
        startAngleRadian *= ( .pi / 180.0 )
#endif
        print(startAngleRadian)
        var endAngleRadian =   startAngleRadian + 30.0
        
#if os(iOS)
        endAngleRadian = Double.pi / 6.0
        strokeWidth = 20.0
#endif
        let radius = rad - strokeWidth / 2.0
        for sign in Signs.allCases {
            if sign == .None {
                continue
            }
            let arc = NSBezierPath.init()
#if os(iOS)
            arc.addArc(withCenter: center, radius: radius, startAngle: startAngleRadian, endAngle: endAngleRadian, clockwise: true)
#else
            arc.appendArc(withCenter: center, radius: radius, startAngle: startAngleRadian, endAngle: endAngleRadian, clockwise: false)
#endif
            arc.lineWidth = strokeWidth
            if sign.rawValue % 4 == 0 {
                strokeColor = NSColor.red
                //NSColor(red: 0, green: 173.0, blue: 0, alpha: 1.0)
                
            } else if sign.rawValue % 4 == 1 {
                strokeColor = NSColor.blue
                
            } else if sign.rawValue % 4 == 2 {
                strokeColor = NSColor.yellow
                
            } else if sign.rawValue % 4 == 3 {
                strokeColor = NSColor.green
            }
            strokeColor.set()
            arc.stroke()
            var offSet: Double = 0
#if os(iOS)
            offSet = (.pi / 12.0)
#else
            offSet = 15.0
#endif
            printSign(viewModel.getXYFromPolar(radius, endAngleRadian - offSet), sign.getAstroDotCharacter(), endAngleRadian - offSet)
            startAngleRadian = endAngleRadian
            
            
#if os(iOS)
            endAngleRadian += .pi / 6.0
#else
            endAngleRadian += 30.0
#endif
            
            
        }
    }
    
    func printSign(_ coordinates: (Int, Int), _ character: Character, _ degree: Double) {
        var coordinate = coordinates
        let size = 21.0
        var radians = degree * ( .pi / 180.0 )
#if os(iOS)
          radians = degree
#endif
        let xJustification = Int(cos(radians) * size / 2)
        if xJustification < 0 {
            coordinate.0 += xJustification
        } else {
            coordinate.0 -= xJustification
        }
        let yJustification = Int(sin(radians) * size / 2) // sin positive subtract sin negative add
        if yJustification < 0 {
            coordinate.1 += yJustification
        } else {
            coordinate.1 -= yJustification
        }
        
#if os(iOS)
        if let font = UIFont(name: "AstroDotBasic", size: size) {
            let textPoint = CGPoint(x: coordinate.0, y: coordinate.1)
            String(character).draw(at: textPoint, withAttributes:[NSAttributedString.Key.font:font])

        }
#else
        if let font = NSFont(name: "AstroDotBasic", size: size) {
            let textPoint = CGPoint(x: coordinate.0, y: coordinate.1)
            String(character).draw(at: textPoint, withAttributes:[NSAttributedString.Key.font:font])

        }
#endif
        
            
    }
}

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
#if os(iOS)
        drawColoredArciOS(CGPoint(x: viewModel.center.x, y: viewModel.center.y), rad: viewModel.radius)
#else
        drawColoredArcMac(CGPoint(x: viewModel.center.x, y: viewModel.center.y), rad: viewModel.radius)
#endif
        printSigns(CGPoint(x: viewModel.center.x, y: viewModel.center.y), rad: viewModel.radius)
        
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
#if os(iOS)
    func drawColoredArciOS( _ center: CGPoint, rad: Double) {
        let strokeWidth = viewModel.getArcStrokeWidth()
        var strokeColor: NSColor = NSColor.green
        var startAngleRadian: Double = viewModel.getChartStartDegree()
        let distanceFrom180 = abs(180 - startAngleRadian)
        if startAngleRadian > 180 {
            startAngleRadian -= 2.0 * distanceFrom180
        } else if startAngleRadian < 180 {
            startAngleRadian += 2.0 * distanceFrom180
        }

        startAngleRadian *= ( .pi / 180.0 )

        var endAngleRadian =   startAngleRadian + Double.pi / 6.0
        

        var counter = 0
        let radius = rad - strokeWidth / 2.0
        for sign in Signs.allCases {
            if sign == .None {
                continue
            }
            let arc = NSBezierPath.init()
            arc.addArc(withCenter: center, radius: radius, startAngle: startAngleRadian, endAngle: endAngleRadian, clockwise: true)

            arc.lineWidth = strokeWidth
            if sign.rawValue % 4 == 0 {
                strokeColor = NSColor.red
                //NSColor(red: 0, green: 173.0, blue: 0, alpha: 1.0)
                
            } else if sign.rawValue % 4 == 1 {
                strokeColor = NSColor.green
                
            } else if sign.rawValue % 4 == 2 {
                strokeColor = NSColor.yellow
                
            } else if sign.rawValue % 4 == 3 {
                strokeColor = NSColor.cyan
            }
            strokeColor.set()
            arc.stroke()

            startAngleRadian = endAngleRadian
            endAngleRadian += .pi / 6.0
        }
    }
#else
    func drawColoredArcMac( _ center: CGPoint, rad: Double) {
        let strokeWidth = viewModel.getArcStrokeWidth()
        var strokeColor: NSColor = NSColor.green
        var startAngleRadian: Double = viewModel.getChartStartDegree()
        var endAngleRadian =   startAngleRadian + 30.0
        let radius = rad - strokeWidth / 2.0
        for sign in Signs.allCases.reversed() {
            if sign == .None {
                continue
            }
            let arc = NSBezierPath.init()

            arc.appendArc(withCenter: center, radius: radius, startAngle: startAngleRadian, endAngle: endAngleRadian, clockwise: false)

            arc.lineWidth = strokeWidth
            if sign.rawValue % 4 == 1 {
                strokeColor = NSColor.green
                //NSColor(red: 0, green: 173.0, blue: 0, alpha: 1.0)
                
            } else if sign.rawValue % 4 == 2 {
                strokeColor = NSColor.yellow
                
            } else if sign.rawValue % 4 == 3 {
                strokeColor = NSColor.cyan
                
            } else if sign.rawValue % 4 == 0 {
                strokeColor = NSColor.red
            }
            strokeColor.set()
            arc.stroke()
            startAngleRadian = endAngleRadian
            endAngleRadian += 30.0
        }
    }
    
#endif
    
    
    
    func printSigns( _ center: CGPoint, rad: Double) {
        var startAngleRadian: Double = viewModel.getChartStartDegree()
        var endAngleRadian =   startAngleRadian + 30.0
        let strokeWidth = viewModel.getArcStrokeWidth()
        let radius = rad - strokeWidth / 2.0
        for sign in Signs.allCases.reversed() {
            if sign == .None {
                continue
            }
            var offSet: Double = 0
            offSet = 15.0
            printSign(viewModel.getXYFromPolar(radius, endAngleRadian - offSet), sign.getAstroDotCharacter(), endAngleRadian - offSet)
            startAngleRadian = endAngleRadian
            endAngleRadian += 30.0
        }
    }

    func printSign(_ coordinates: (Int, Int), _ character: Character, _ degree: Double) {
        var coordinate = coordinates
        let size = 21.0
        let radians = degree * ( .pi / 180.0 )
        coordinate = viewModel.justifyCoordinate(inputCoordinate: coordinate, radians: radians, size: size)
        
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

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
        viewModel.populateData()
#if os(iOS)
        drawColoredArciOS(CGPoint(x: viewModel.center.x, y: viewModel.center.y), rad: viewModel.radius)
#else
        drawColoredArcMac(CGPoint(x: viewModel.center.x, y: viewModel.center.y), rad: viewModel.radius)
#endif
        printSigns(CGPoint(x: viewModel.center.x, y: viewModel.center.y), rad: viewModel.radius)
        drawCircle(viewModel.center, radius: viewModel.radius - viewModel.getArcStrokeWidth() - 10.0)
        drawCircle(viewModel.center, radius: viewModel.innerRadius)
        
        drawSpoke()
    }
    
    func drawSpoke() {
        let startDegree: Double = viewModel.getChartStartDegree()
        for a in 0...359 {
            let trueDegree =  viewModel.getChartStartDegree()  - Double(a)
            var len = 0
            if a % 5 == 0 {
                len = 10
            } else {
                len = 5
            }
            let thickness = 1
            let planetDegree = a
            if let planetArray = viewModel.planetsDictionary[a] {
                drawLine(degree: trueDegree, radius: viewModel.radius - viewModel.getArcStrokeWidth(), length: 16, thickness: thickness + 1)
                drawPlanetListing(planetArray, trueDegree)
            }
            
            drawLine(degree: Double(a) + startDegree, radius: viewModel.radius - viewModel.getArcStrokeWidth(), length: len, thickness: thickness)
            let houseDegree =   a
            
            if let signTupple = viewModel.houseDictionary[houseDegree] {
                drawHouseInfo(at: houseDegree, for: trueDegree, house: String(signTupple.0), sign: signTupple.1 )
            }
        }
    }
    
    func drawPlanetListing(_ planetArray: [PlanetCell], _ trueDegree: Double) {
        
    }
    
    func drawHouseInfo(at houseDegree: Int, for trueDegree: Double, house: String, sign: Signs) {
        drawLine(degree: Double(trueDegree), radius: viewModel.radius - viewModel.getArcStrokeWidth(), length: Int(viewModel.radius - viewModel.innerRadius - viewModel.getArcStrokeWidth()), thickness: 1)
        drawLine(degree: Double(trueDegree), radius: viewModel.radius + 5, length: 5, thickness: 1)
        var fontSize = 14.0
#if os(iOS)
        fontSize = 10.0
#endif
        printText(viewModel.getXYFromPolar(viewModel.innerRadius + 10, trueDegree - 10.0), house, trueDegree - 10.0, false, fontSize)
        printSign(viewModel.getXYFromPolar(viewModel.radius + 15, trueDegree), Double(houseDegree).getAstroSign().getAstroDotCharacter(), trueDegree)
        let signDegreeText = viewModel.houseData[(Int(house) ?? 1) - 1].numericDegree.getAstroDegree()

        printText(viewModel.getXYFromPolar(viewModel.radius + 20, trueDegree - 6), signDegreeText, trueDegree - 6, true, fontSize)
    }
    
    
    func drawLine(degree: Double, radius: Double, length: Int, thickness: Int) {
        let coordinate1 = viewModel.getXYFromPolar(radius, degree)
        let coordinate2 = viewModel.getXYFromPolar(radius - Double(length), degree)
#if os(iOS)
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x:coordinate1.0, y:coordinate1.1))
        aPath.addLine(to: CGPoint(x: coordinate2.0, y: coordinate2.1))
        aPath.close()
        UIColor.black.set()
        aPath.lineWidth = CGFloat(thickness)
        aPath.stroke()
#else
        let aPath = NSBezierPath.init()
        aPath.move(to: CGPoint(x:coordinate1.0, y:coordinate1.1))
        aPath.line(to: CGPoint(x: coordinate2.0, y: coordinate2.1))
        aPath.close()
        NSColor.black.set()
        aPath.lineWidth = CGFloat(thickness)
        aPath.stroke()
#endif
        
    }
    
    
    func drawCircle(_ center: (Double, Double), radius: Double, lineWidth: Double = 1) {
        let fillColor: NSColor = NSColor.white
        let strokeColor: NSColor = NSColor.black
        let oval = NSBezierPath.init(ovalIn: CGRect(x: frame.width / 2.0 - radius, y: frame.height / 2.0 - radius, width: radius * 2, height: radius * 2))
        oval.close()
            oval.lineWidth = lineWidth
            fillColor.set()
            oval.fill()
            oval.close()
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
    
    func printText(_ coordinates: (Int, Int), _ text: String, _ degree: Double, _ extraJustify: Bool,  _ size: Double = 16.0 ) {
        var coordinate = coordinates
        let radians = degree * ( .pi / 180.0 )
        if text.count < 2 && extraJustify {
            coordinate = viewModel.justifyCoordinate(inputCoordinate: coordinate, radians: radians, size: size)
        } else {
            coordinate = viewModel.justifyTextCoordinatePlus(inputCoordinate: coordinate, radians: radians, size: size, multiplier: text.count + 1)
        }
#if os(iOS)
        if let font = UIFont(name: "Arial", size: size) {
            let textPoint = CGPoint(x: coordinate.0, y: coordinate.1)
            text.draw(at: textPoint, withAttributes:[NSAttributedString.Key.font:font])

        }
#else
        if let font = NSFont(name: "Arial", size: size) {
            let textPoint = CGPoint(x: coordinate.0, y: coordinate.1)
            text.draw(at: textPoint, withAttributes:[NSAttributedString.Key.font:font])

        }
#endif
    }
}

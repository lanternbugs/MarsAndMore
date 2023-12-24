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
enum Colors { case black, red, orange }
#if os(iOS)
import UIKit
class NatalChartDrawingView: UIView {
    typealias NSBezierPath = UIBezierPath
    
    var viewModel: ChartViewModel
    var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    override init(frame frameRect: CGRect) {
        viewModel = ChartViewModel(chartName: "none", chartType: .Natal)
        super.init(frame: frameRect)
    }

    required init(coder: NSCoder) {
        viewModel = ChartViewModel(chartName: "none", chartType: .Natal)
        super.init(coder: coder)!
    }

    init(model: ChartViewModel) {
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
    var viewModel: ChartViewModel
    typealias UIColor = NSColor
    override init(frame frameRect: NSRect) {
        viewModel = ChartViewModel(chartName: "none", chartType: .Natal)
        super.init(frame: frameRect);
    }

    required init(coder: NSCoder) {
        viewModel = ChartViewModel(chartName: "none", chartType: .Natal)
        super.init(coder: coder)!
    }

    init(model: ChartViewModel) {
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
        drawPlanets()
    }
    
    func drawPlanets() {
        guard let manager = viewModel.manager else {
            return
        }
        viewModel.computeNatalPrintingQueue()
        for a in 0...359 {
            let trueDegree =  viewModel.getChartStartDegree()  + Double(a)
            let thickness = 2
            if let planetArray = viewModel.planetsDictionary[a] {
                let usersPlanets = planetArray.filter { manager.bodiesToShow.contains($0.planet) }
                if !usersPlanets.isEmpty {
                    if !usersPlanets.filter({$0.planet != .Ascendent && $0.planet != .MC}).isEmpty {
                        drawLine(degree: trueDegree, radius: viewModel.radius - viewModel.getArcStrokeWidth(), length: 16, thickness: thickness)
                        drawLine(degree: trueDegree, radius: viewModel.innerRadius + 6, length: 6, thickness: thickness)
                        drawPlanetListing(usersPlanets, trueDegree)
                    }
                    
                    drawAspects(usersPlanets, trueDegree, a)
                }
            }
        }
    }
    
    func drawSpoke() {
        
        let startDegree: Double = viewModel.getChartStartDegree()
        for a in 0...359 {
            let trueDegree =  viewModel.getChartStartDegree()  + Double(a)
            var len = 0
            if viewModel.chart == .Natal {
                if a % 5 == 0 {
                    len = 10
                } else {
                    len = 5
                }
            } else {
                if a % 5 == 0 {
                    len = 6
                } else {
                    len = 3
                }
            }
            
            
            let thickness = 1
            drawLine(degree: Double(a) + startDegree, radius: viewModel.radius - viewModel.getArcStrokeWidth(), length: len, thickness: thickness)
            let houseDegree =   a
            
            if let signTupple = viewModel.houseDictionary[houseDegree] {
                drawHouseInfo(at: houseDegree, for: trueDegree, house: String(signTupple.0), sign: signTupple.1 )
            } else if viewModel.houseData.isEmpty && a % 30 == 0 {
                drawLine(degree: Double(trueDegree), radius: viewModel.radius - viewModel.getArcStrokeWidth(), length: Int(viewModel.radius - viewModel.innerRadius - viewModel.getArcStrokeWidth()), thickness: 1)
            }
        }
    }
    
    func drawAspects(_ planetArray: [PlanetCell], _ trueDegree: Double, _ a: Int) {
        guard let manager = viewModel.manager else {
            return
        }
        for planet in planetArray {
            let aspects = viewModel.aspectsData.filter { $0.planet == planet.planet && manager.bodiesToShow.contains($0.planet2)}
            for aspect in aspects {
                if !aspect.aspect.isMajor() || aspect.aspect == .Conjunction {
                    continue
                }
                if let b = viewModel.secondaryPlanetToDegreeMap.isEmpty ? viewModel.planetToDegreeMap[aspect.planet] : viewModel.secondaryPlanetToDegreeMap[aspect.planet], let c =  viewModel.planetToDegreeMap[aspect.planet2] {
                    var secondDegree =  trueDegree
                    let orb = Double(abs(c - b))
                    if c > b && orb < aspect.aspect.rawValue + 20.0 {
                        secondDegree += orb
                    } else if c > b && (360 - orb) < aspect.aspect.rawValue + 20.0 {
                        secondDegree += orb
                    } else {
                        secondDegree -= orb
                    }
                    let coordinate1 = viewModel.getXYFromPolar(viewModel.innerRadius, trueDegree)
                    let coordinate2 = viewModel.getXYFromPolar(viewModel.innerRadius, secondDegree)
                    drawAspect(coordinate1: coordinate1, coordinate2: coordinate2, aspect: aspect.aspect, thickness: 1)
                }
            }
        }
    }
    
    func drawPlanetListing(_ planetArray: [PlanetCell], _ trueDegree: Double) {
        let sortedArray = planetArray.sorted(by: {$0.numericDegree > $1.numericDegree })
        var fontSize = 12.0
        let spreadInfo = viewModel.getNatalWheelSpread()
        let spread = spreadInfo.0
        let firstSpread = spreadInfo.1
#if os(iOS)
        if idiom != .pad {
            fontSize = 10.0
        }
#endif
        
        var i = 0
        for planet in sortedArray {
            if planet.planet == .Ascendent || planet.planet == .MC {
                continue
            }
            let printInfo = viewModel.getNatalPrintingDegree()
            let printDegree = printInfo.0
            let printSize = printInfo.1
            let colorChoice = planet.planet == .Sun ? Colors.orange : Colors.black
            
            printSign(viewModel.getXYFromPolar(viewModel.radius - viewModel.getArcStrokeWidth() - spread, printDegree), planet.planet.getAstroDotCharacter(), trueDegree, colorChoice: colorChoice, printInfo: printSize)
            printText(viewModel.getXYFromPolar(viewModel.radius - viewModel.getArcStrokeWidth() - spread * firstSpread, printDegree), planet.numericDegree.getAstroDegreeOnly(), trueDegree, false, fontSize)
            printSign(viewModel.getXYFromPolar(viewModel.radius - viewModel.getArcStrokeWidth() - spread * 2.2, printDegree), planet.sign.getAstroDotCharacter(), trueDegree)

            printText(viewModel.getXYFromPolar(viewModel.radius - viewModel.getArcStrokeWidth() - spread * 3.0, printDegree), planet.numericDegree.getAstroMinute(), trueDegree, false, fontSize)
            if planet.retrograde {
                printText(viewModel.getXYFromPolar(viewModel.radius - viewModel.getArcStrokeWidth() - spread * 3.4, printDegree), "R", trueDegree, false, fontSize)
            }
            
            i += 1
            
        }
        
    }
    
    func drawHouseInfo(at houseDegree: Int, for trueDegree: Double, house: String, sign: Signs) {
        drawLine(degree: Double(trueDegree), radius: viewModel.radius - viewModel.getArcStrokeWidth(), length: Int(viewModel.radius - viewModel.innerRadius - viewModel.getArcStrokeWidth()), thickness: 1)
        drawLine(degree: Double(trueDegree), radius: viewModel.radius + 5, length: 5, thickness: 1)
        var fontSize = 12.0
        if viewModel.chart != .Natal {
            fontSize = 10.0
        }
#if os(iOS)
        if idiom != .pad {
            fontSize = 10.0
        } else {
            fontSize = 12.0
        }
        
#endif
        var printingHouse = Int(house)
        printingHouse = (printingHouse ?? 1)
        if printingHouse == 0 {
            printingHouse = 12
        }
        var textOffsetFromRadius = 4.0
        
#if os(iOS)
        textOffsetFromRadius = 8
        #else
        if viewModel.chart == .Natal {
            textOffsetFromRadius = 6
        }
#endif
        if viewModel.chart != .Natal {
            printText(viewModel.getXYFromPolar(viewModel.radius + textOffsetFromRadius, trueDegree + 4.0), Double(houseDegree).getAstroDegreeOnly(), trueDegree + 4.0, false, fontSize)
        }
        
        printText(viewModel.getXYFromPolar(viewModel.innerRadius + textOffsetFromRadius, trueDegree + 6.0), String(printingHouse ?? 1), trueDegree + 6.0, false, fontSize)
        if viewModel.chart == .Natal {
            printSign(viewModel.getXYFromPolar(viewModel.radius + 15, trueDegree), Double(houseDegree).getAstroSign().getAstroDotCharacter(), trueDegree)
            let signDegreeText = viewModel.houseData[(Int(house) ?? 1) - 1].numericDegree.getAstroDegree()
            printText(viewModel.getXYFromPolar(viewModel.radius + 20, trueDegree - 6), signDegreeText, trueDegree - 6, true, fontSize)
        }
    }
    
    
    func drawLine(degree: Double, radius: Double, length: Int, thickness: Int, useRed: Bool = false) {
        let coordinate1 = viewModel.getXYFromPolar(radius, degree)
        let coordinate2 = viewModel.getXYFromPolar(radius - Double(length), degree)
#if os(iOS)
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x:coordinate1.0, y:coordinate1.1))
        aPath.addLine(to: CGPoint(x: coordinate2.0, y: coordinate2.1))
        aPath.close()
        if useRed {
            UIColor.red.set()
        } else {
            UIColor.black.set()
        }
        
        aPath.lineWidth = CGFloat(thickness)
        aPath.stroke()
#else
        let aPath = NSBezierPath.init()
        aPath.move(to: CGPoint(x:coordinate1.0, y:coordinate1.1))
        aPath.line(to: CGPoint(x: coordinate2.0, y: coordinate2.1))
        aPath.close()
        if useRed {
            NSColor.red.set()
        } else {
            NSColor.black.set()
        }
        aPath.lineWidth = CGFloat(thickness)
        aPath.stroke()
#endif
        
    }
    
    func drawAspect(coordinate1: (Int, Int), coordinate2: (Int, Int), aspect: Aspects, thickness: Int) {
        
#if os(iOS)
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x:coordinate1.0, y:coordinate1.1))
        aPath.addLine(to: CGPoint(x: coordinate2.0, y: coordinate2.1))
        aPath.close()
        switch aspect {
        case .Trine:
            UIColor.blue.set()
        case .Sextile:
            UIColor.cyan.set()
        case .Square, .Opposition:
            UIColor.red.set()
        default:
            UIColor.black.set()
        }
        
        aPath.lineWidth = CGFloat(thickness)
        aPath.stroke()
#else
        let aPath = NSBezierPath.init()
        aPath.move(to: CGPoint(x:coordinate1.0, y:coordinate1.1))
        aPath.line(to: CGPoint(x: coordinate2.0, y: coordinate2.1))
        aPath.close()
        switch aspect {
        case .Trine:
            NSColor.blue.set()
        case .Sextile:
            NSColor.cyan.set()
        case .Square, .Opposition:
            NSColor.red.set()
        default:
            NSColor.black.set()
        }
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
        

        let radius = rad - strokeWidth / 2.0
        for sign in Signs.allCases.reversed() {
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
        for sign in Signs.allCases {
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
        var endAngleRadian =   startAngleRadian - 30.0
        let strokeWidth = viewModel.getArcStrokeWidth()
        let radius = rad - strokeWidth / 2.0
        for sign in Signs.allCases.reversed() {
            if sign == .None {
                continue
            }
            var offSet: Double = 0
            offSet = 15.0
            printSign(viewModel.getXYFromPolar(radius, endAngleRadian + offSet), sign.getAstroDotCharacter(), endAngleRadian + offSet)
            startAngleRadian = endAngleRadian
            endAngleRadian -= 30.0
        }
    }

    func printSign(_ coordinates: (Int, Int), _ character: Character, _ degree: Double, colorChoice: Colors = .black, printInfo: PrintSize = .regular) {
        var coordinate = coordinates
        var size = 21.0
#if os(iOS)
        if idiom != .pad {
            size = 14.0
            if printInfo == .large {
                size += 6
            }
        } else if printInfo == .large {
            size = 24
            size += 10
        }
#else
        if printInfo == .large {
            size += 6
        }
#endif
        
        let radians = degree * ( .pi / 180.0 )
        coordinate = viewModel.justifyCoordinate(inputCoordinate: coordinate, radians: radians, size: size)
        
#if os(iOS)
        guard let font = UIFont(name: "AstroDotBasic", size: size) else {
            return
        }
#else
        guard let font = NSFont(name: "AstroDotBasic", size: size) else {
            return
        }
#endif
        let textPoint = CGPoint(x: coordinate.0, y: coordinate.1)
        switch colorChoice {
        case .red:
            String(character).draw(at: textPoint, withAttributes:[NSAttributedString.Key.font:font, NSAttributedString.Key.foregroundColor: UIColor.red])
        case .orange:
            String(character).draw(at: textPoint, withAttributes:[NSAttributedString.Key.font:font, NSAttributedString.Key.foregroundColor: UIColor.orange])
        case .black:
            String(character).draw(at: textPoint, withAttributes:[NSAttributedString.Key.font:font])
        }
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

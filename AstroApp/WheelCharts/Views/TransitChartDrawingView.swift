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
        if viewModel.manager?.chartWheelColorType ?? .Light == .Light {
            backgroundColor = NSColor.white
        } else {
            backgroundColor = NSColor.black
        }
        drawTransitChart()
    }
#else
    override func draw(_ dirtyRect: NSRect) {
        wantsLayer = true
        if viewModel.manager?.chartWheelColorType ?? .Light == ChartWheelColorType.Light {
            layer?.backgroundColor = NSColor.white.cgColor
        } else {
            layer?.backgroundColor = NSColor.black.cgColor
        }
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
        printSigns(CGPoint(x: viewModel.center.x, y: viewModel.center.y), rad: viewModel.radius)
        drawCircle(viewModel.center, radius: viewModel.interiorRadius)
        if viewModel.chart == .Synastry {
            drawCircle(viewModel.center, radius: viewModel.interiorRadius - viewModel.innerHouseThickness)
        }
        drawCircle(viewModel.center, radius: viewModel.innerRadius)
        drawSpoke()
        drawTwoPlanetSets()
    }
    
    func drawTwoPlanetSets() {
        guard let manager = viewModel.manager else {
            return
        }
        viewModel.computePrintingQueues()
        
        for a in 0...359 {
            let trueDegree =  viewModel.getChartStartDegree()  + Double(a)
            let thickness = 2
            if let planetArray = viewModel.secondaryPlanetsDictionary[a] {
                let usersPlanets = planetArray.filter { manager.bodiesToShow.contains($0.planet) }
                if !usersPlanets.isEmpty {
                    if !usersPlanets.filter({($0.planet != .Ascendant) && ($0.planet != .MC)}).isEmpty {
                        drawLine(degree: trueDegree, radius: viewModel.radius - viewModel.getArcStrokeWidth(), length: 8, thickness: thickness, useRed: true)
                        drawLine(degree: trueDegree, radius: viewModel.interiorRadius + 5 , length: 5, thickness: thickness, useRed: true)
                        drawUpperPlanetListing(usersPlanets, trueDegree)
                    }
                    drawAspects(usersPlanets, trueDegree, a)
                    
                    
                }
            }
            
            if let planetArray = viewModel.planetsDictionary[a] {
                let usersPlanets = planetArray.filter { manager.bodiesToShow.contains($0.planet) }
                if !usersPlanets.isEmpty {
                    if !usersPlanets.filter({($0.planet != .Ascendant || viewModel.showAscendant()) && ($0.planet != .MC || viewModel.showMC())}).isEmpty {
                        drawLine(degree: trueDegree, radius: viewModel.interiorRadius - viewModel.innerHouseThickness, length: 8, thickness: thickness)
                        drawLine(degree: trueDegree, radius: viewModel.innerRadius + 5, length: 5, thickness: thickness)
                        drawLowerPlanetListing(usersPlanets, trueDegree)
                    }
                }
            }
        }
    }
    
    func drawUpperPlanetListing(_ planetArray: [PlanetCell], _ trueDegree: Double) {
        let sortedArray = planetArray.sorted(by: {$0.numericDegree > $1.numericDegree })
        var fontSize = 12.0
        let spreadInfo = viewModel.getUpperWheelSpread()
        let spread = spreadInfo.0
        let firstSpread = spreadInfo.1
#if os(iOS)
        if idiom != .pad {
            fontSize = 10.0
        }
#endif
        
        var i = 0
        for planet in sortedArray {
            if (planet.planet == .Ascendant) || (planet.planet == .MC) {
                continue
            }
            
            let printInfo = viewModel.getUpperPrintingDegree()
            let printDegree = printInfo.0
            let colorChoice = Colors.red

            if planet.planet != .Pholus {
                printSign(viewModel.getXYFromPolar(viewModel.radius - viewModel.getArcStrokeWidth() - spread, printDegree), planet.planet.getAstroDotCharacter(), trueDegree, colorChoice: colorChoice, printInfo: printInfo.1)
            } else {
                printText(viewModel.getXYFromPolar(viewModel.radius - viewModel.getArcStrokeWidth() - spread, printDegree), "Ph", trueDegree, false, fontSize, outerPlanet: true)
            }
            printText(viewModel.getXYFromPolar(viewModel.radius - viewModel.getArcStrokeWidth() - spread * firstSpread, printDegree), planet.numericDegree.getAstroDegreeOnly(), trueDegree, false, fontSize)
            if planet.retrograde {
#if os(macOS)
                printSign(viewModel.getXYFromPolar(viewModel.radius - viewModel.getArcStrokeWidth() - spread * 2.3, printDegree), "R", trueDegree, colorChoice: colorChoice, printInfo: .small)
#else
                printSign(viewModel.getXYFromPolar(viewModel.radius - viewModel.getArcStrokeWidth() - spread * 2.2, printDegree), "R", trueDegree, colorChoice: colorChoice, printInfo: .small)
#endif
    
                
            }
            i += 1
            
        }
        
    }
    
    
    
    func drawLowerPlanetListing(_ planetArray: [PlanetCell], _ trueDegree: Double) {
        let sortedArray = planetArray.sorted(by: {$0.numericDegree > $1.numericDegree })
        var fontSize = 12.0
        let spreadInfo = viewModel.getLowerWheelSpread()
        let spread = spreadInfo.0
        let firstSpread = spreadInfo.1
#if os(iOS)
        if idiom != .pad {
            fontSize = 10.0
        }
#endif
        var i = 0
        for planet in sortedArray {
            if (planet.planet == .Ascendant && !viewModel.showAscendant()) || (planet.planet == .MC && !viewModel.showMC()) {
                continue
            }
            let printInfo = viewModel.getLowerPrintingDegree()
            let printDegree = printInfo.0
            let colorChoice = planet.planet == .Sun ? Colors.orange : Colors.black
            let placement = viewModel.interiorRadius - (viewModel.innerHouseThickness / 2)

            if planet.planet != .Pholus {
                printSign(viewModel.getXYFromPolar(placement - spread - 2, printDegree), planet.planet.getAstroDotCharacter(), trueDegree, colorChoice: colorChoice, printInfo: printInfo.1)
            } else {
                printText(viewModel.getXYFromPolar(placement - spread - 2, printDegree), "Ph", trueDegree, false, fontSize)
            }
            
            printText(viewModel.getXYFromPolar(placement - spread * firstSpread, printDegree), planet.numericDegree.getAstroDegreeOnly(), trueDegree, false, fontSize)
            if planet.retrograde {
                printSign(viewModel.getXYFromPolar(placement - spread * 3.2, printDegree), "R", trueDegree, colorChoice: colorChoice, printInfo: .small)
            }
            
            i += 1
            
        }
        
    }
}

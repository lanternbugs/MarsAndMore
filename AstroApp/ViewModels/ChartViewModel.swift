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
//  Created by Michael Adams on 11/30/23.
//

import Foundation
#if os(iOS)
import UIKit
private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
#endif
enum PrintSize { case small, regular, large}

class ChartViewModel {
    let chartName: String
    var manager: BirthDataManager?
    var houseData = [HouseCell]()
    var planetData = [PlanetCell]()
    var secondaryPlanetData = [PlanetCell]()
    var aspectsData = [TransitCell]()
    var houseDictionary = [Int: (Int, Signs)]()
    var planetsDictionary = [Int: [PlanetCell]]()
    var secondaryPlanetsDictionary = [Int: [PlanetCell]]()
    var planetToDegreeMap = [Planets: Int]()
    var secondaryPlanetToDegreeMap = [Planets: Int]()
    var width: Double = 2
    var height: Double = 2
    let chart: Charts
    var secondaryLastPrintingDegree = -Int.max
    var secondaryPrintingStack = [Int]()
    var lastPrintingDegree = -Int.max
    var printingStack = [Int]()
    var upperPrintingQueue = [(Double, PrintSize)]()
    var lowerPrintingQueue = [(Double, PrintSize)]()
    
    
    init(chartName: String, chartType: Charts) {
        self.chartName = chartName
        self.chart = chartType
    }
    func populateData() {
        if !planetsDictionary.isEmpty {
            return
        }
        // we dont currently have a font image for Pholus
        planetData = planetData.filter( { $0.planet != .Pholus })
        aspectsData = aspectsData.filter( { $0.planet != .Pholus && $0.planet2 != .Pholus })
        if houseData.count > 0 {
            for i in 0...houseData.count - 1 {
                var a = i
                if a == 0 {
                    a = 12
                }
                houseDictionary[Int(houseData[a - 1].numericDegree)] = (a, houseData[a - 1].sign)
            }
        }
        if planetData.count > 0 {
            for i in 0...planetData.count - 1 {
                
                if planetsDictionary[Int(planetData[i].numericDegree)] == nil {
                    var planetArray = [PlanetCell]()
                    planetArray.append(planetData[i])
                    planetsDictionary[Int(planetData[i].numericDegree)] = planetArray
                    
                } else {
                    planetsDictionary[Int(planetData[i].numericDegree)]?.append(planetData[i])
                }
                planetToDegreeMap[planetData[i].planet] = Int(planetData[i].numericDegree)
            }
            
            if secondaryPlanetData.count > 0 {
                for i in 0...secondaryPlanetData.count - 1 {
                    
                    if secondaryPlanetsDictionary[Int(secondaryPlanetData[i].numericDegree)] == nil {
                        var planetArray = [PlanetCell]()
                        planetArray.append(secondaryPlanetData[i])
                        secondaryPlanetsDictionary[Int(secondaryPlanetData[i].numericDegree)] = planetArray
                        
                    } else {
                        secondaryPlanetsDictionary[Int(secondaryPlanetData[i].numericDegree)]?.append(secondaryPlanetData[i])
                    }
                    secondaryPlanetToDegreeMap[secondaryPlanetData[i].planet] = Int(secondaryPlanetData[i].numericDegree)
                }
            }
        }
    }
    var radius: Double {
        var value = width < height ? width / 2.0 - 34.0 : height / 2.0 - 34.0
        if chart == .Natal {
            if houseData.isEmpty {
                value += 30
            }
    #if os(iOS)
            let idiom : UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
            if !houseData.isEmpty  && idiom != .pad {
                value += 7
            }
    #endif
        } else {
            value += 33
#if os(iOS)
            value -= 12
#endif
        }

        return value
    }
    
    var interiorRadius: Double {
#if os(iOS)
        (radius - getArcStrokeWidth() + innerRadius) / 2 * 1.11
#else
        (radius - getArcStrokeWidth() + innerRadius) / 2 * 1.06
#endif
        
        
    }
    var innerRadius: Double {
#if os(iOS)
        let idiom : UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        if idiom == .pad {
            return radius  * 0.40
        }
        return radius * 0.29
#else
        return radius * 0.40
#endif
        
    }
    
    var center: (x: Double, y: Double) {
        (width / 2.0, width / 2 -  ((width - height) / 2.0))
    }
    
    func setWidth(_ w: Double) {
        width = w
    }
    
    func setHeight(_ h: Double) {
        height = h
    }
    
    func getChartStartDegree() -> Double {
        if houseData.count > 0 {
            let houseDegree = houseData[0].numericDegree
            return 180.0 - houseDegree
        }
        return 180.0
    }
    
    func justifyCoordinate(inputCoordinate: (Int, Int), radians: Double, size: Double) -> (Int, Int) {
        var coordinate = inputCoordinate
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

        
        
        
        return coordinate
    }
    func justifyTextCoordinatePlus(inputCoordinate: (Int, Int), radians: Double, size: Double, multiplier: Int) -> (Int, Int) {
        var coordinate = inputCoordinate
        var xJustification = Int(cos(radians) * size / 2)

        if xJustification < 0 {
#if os(iOS)
            coordinate.0 += Int(Double(xJustification) * 1.5)
#else
            coordinate.0 += xJustification  * multiplier
#endif
            
        } else {
           
#if os(iOS)
            coordinate.0 -= xJustification
#else
            // coordinate.0 += xJustification
#endif
        }

        let yJustification = Int(sin(radians) * size / 2) // sin positive subtract sin negative add

        if yJustification < 0 {
            coordinate.1 += yJustification
        } else {
            coordinate.1 -= yJustification
        }

        
        
        
        return coordinate
    }
    func getXYFromPolar(_ radius: Double, _ degree: Double) -> (Int, Int) {
        let radians = degree * ( .pi / 180.0 )
        var coordinate = ((Int(center.x + radius * cos(radians))), Int(center.y + radius * sin(radians)))
#if os(iOS)
        coordinate.1 = Int(height) - coordinate.1
#endif
        return coordinate
    }
    
    func getArcStrokeWidth() -> Double {
#if os(iOS)
        if idiom != .pad {
            return 10
        }
        return 25
        
#else
        return 30
#endif
    }
    
    func computeUpperSeperation(_ planetArray: [PlanetCell], _ trueDegree: Double) {
        let sortedArray = planetArray.sorted(by: {$0.numericDegree > $1.numericDegree })
        var i = 0
        for planet in sortedArray {
            if planet.planet == .Ascendent || planet.planet == .MC {
                continue
            }
            var printDegree = trueDegree
            var seperation = 3.0
#if os(iOS)
            if idiom != .pad {
                seperation = 4.0
            }
            
#endif
            
            if lastPrintingDegree != -Int.max && abs((lastPrintingDegree - Int(printDegree))) < Int(seperation) {
                if i == 1 && printingStack.count < 2 {
                    printDegree = Double((lastPrintingDegree - Int(seperation)))
                } else if i == 1 && abs(printingStack[printingStack.count - 2] - (lastPrintingDegree + Int(seperation))) > 2  {
                    printDegree = Double((lastPrintingDegree - Int(seperation)))
                } else {
                    printDegree = Double((lastPrintingDegree + Int(seperation + 1.0)))
                }
                
            } else {
                printDegree = trueDegree
            }
            lastPrintingDegree = Int(printDegree)
            printingStack.append(lastPrintingDegree)
            upperPrintingQueue.append((printDegree, .regular))
            i += 1
            
        }
    }
    
    func computeLowerSeperation(_ planetArray: [PlanetCell], _ trueDegree: Double) {
        let sortedArray = planetArray.sorted(by: {$0.numericDegree > $1.numericDegree })
        var i = 0
        for planet in sortedArray {
            if planet.planet == .Ascendent || planet.planet == .MC {
                continue
            }
            var printDegree = trueDegree
            var seperation = 3.0
#if os(iOS)
            if idiom != .pad {
                seperation = 5
            }
            
#endif
            
            if secondaryLastPrintingDegree != -Int.max && abs((secondaryLastPrintingDegree - Int(printDegree))) < Int(seperation) {
                if i == 1 && secondaryPrintingStack.count < 2 {
                    printDegree = Double((secondaryLastPrintingDegree - Int(seperation)))
                } else if i == 1 && abs(secondaryPrintingStack[secondaryPrintingStack.count - 2] - (secondaryLastPrintingDegree + Int(seperation))) > 2  {
                    printDegree = Double((secondaryLastPrintingDegree - Int(seperation)))
                } else {
                    printDegree = Double((secondaryLastPrintingDegree + Int(seperation + 1.5)))
                }
                
            } else {
                printDegree = trueDegree
            }
            secondaryLastPrintingDegree = Int(printDegree)
            secondaryPrintingStack.append(secondaryLastPrintingDegree)
            lowerPrintingQueue.append((printDegree, .regular))
            i += 1
        }
        
    }
    
    func computePrintingQueues() {
        guard let manager = manager else {
            return
        }
        secondaryLastPrintingDegree = -Int.max
        secondaryPrintingStack.removeAll()
        lastPrintingDegree = -Int.max
        printingStack.removeAll()
        for a in 0...359 {
            let trueDegree =  getChartStartDegree()  + Double(a)
            if let planetArray = secondaryPlanetsDictionary[a] {
                let usersPlanets = planetArray.filter { manager.bodiesToShow.contains($0.planet) }
                if !usersPlanets.isEmpty {
                    if !usersPlanets.filter({$0.planet != .Ascendent && $0.planet != .MC}).isEmpty {
                        computeUpperSeperation(usersPlanets, trueDegree)
                    }
                }
            }
            
            if let planetArray =  planetsDictionary[a] {
                let usersPlanets = planetArray.filter { manager.bodiesToShow.contains($0.planet) }
                if !usersPlanets.isEmpty {
                    if !usersPlanets.filter({$0.planet != .Ascendent && $0.planet != .MC}).isEmpty {
                        computeLowerSeperation(usersPlanets, trueDegree)
                    }
                }
            }
        }
        
        upperPrintingQueue = computePrintingSizes(queue: upperPrintingQueue)
        lowerPrintingQueue = computePrintingSizes(queue: lowerPrintingQueue)
        
    }
    
    func getUpperPrintingDegree() -> (Double, PrintSize) {
        if upperPrintingQueue.isEmpty {
            return (0, .regular)
        }
        return upperPrintingQueue.remove(at: 0)
        
        
    }
    func getLowerPrintingDegree() -> (Double, PrintSize) {
        if lowerPrintingQueue.isEmpty {
            return (0, .regular)
        }
        return lowerPrintingQueue.remove(at: 0)
    }
    
    func computePrintingSizes(queue: [(Double, PrintSize)]) -> [(Double, PrintSize)] {
        var outputQueue = queue
        if outputQueue.isEmpty {
            return [(Double, PrintSize)]()
        }
        var targetSpread = 3.0
        
#if os(iOS)
        if idiom != .pad {
            targetSpread = 6.5
        }
#endif
        for i in 0...outputQueue.count - 1 {
            if i == 0 {
                if outputQueue.count > 1 {
                    if outputQueue[1].0 - outputQueue[0].0 > targetSpread {
                        outputQueue[0].1 = .large
                    }
                }
            } else if i == outputQueue.count - 1 {
                if outputQueue.count > 1 {
                    if outputQueue[outputQueue.count - 1].0 - outputQueue[outputQueue.count - 2].0 > targetSpread {
                        outputQueue[outputQueue.count - 1].1 = .large
                    }
                }
            } else {
                if i < outputQueue.count - 1 && i > 0 {
                    if outputQueue[i + 1].0 - outputQueue[i].0 > targetSpread {
                        if outputQueue[i].0 - outputQueue[i - 1].0 > targetSpread {
                            
                            if i > 1 {
                                if outputQueue[i].0 - outputQueue[i - 2].0 > targetSpread {
                                    outputQueue[i].1 = .large
                                }
                            }
                            else {
                                outputQueue[i].1 = .large
                            }
                        }
                    }
                }
            }
        }
        
        return outputQueue
    }
    
}

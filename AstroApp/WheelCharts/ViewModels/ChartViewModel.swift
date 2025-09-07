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
var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
#endif
enum PrintSize { case small, regular, large}

class ChartViewModel {
    let model: WheelChartModel
    var secondaryLastPrintingDegree = -Int.max
    var secondaryPrintingStack = [Int]()
    var lastPrintingDegree = -Int.max
    var printingStack = [Int]()
    
    var chartName: String {
        model.chartName
    }
    var houseSystemName: String {
        get {
            model.houseSystemName
        }
        set(newValue) {
            model.houseSystemName = newValue
        }
    }
    var tropical: Bool {
        get {
            model.tropical
        }
        set(newValue) {
            model.tropical = newValue
        }
    }
    var showIndividualCompositeData: Bool {
        get {
            model.showIndividualCompositeData
        }
        set(newValue) {
            model.showIndividualCompositeData = newValue
        }
    }
    var name1: String  {
        get {
            model.name1
        }
        set(newValue) {
            model.name1 = newValue
        }
    }
    var name2: String {
        get {
            model.name2
        }
        set(newValue) {
            model.name2 = newValue
        }
    }
    var manager: BirthDataManager? {
        model.manager
    }
    var houseData: [HouseCell] {
        get {
            model.houseData
        }
        set(newValue) {
            model.houseData = newValue
        }
    }
    var personOneHouseData: [HouseCell] {
        get {
            model.personOneHouseData
        }
        set(newValue) {
            model.personOneHouseData = newValue
        }
    }
    var personTwoHouseData: [HouseCell] {
        get {
            model.personTwoHouseData
        }
        set(newValue) {
            model.personTwoHouseData = newValue
        }
    }
    var secondaryHouseData: [HouseCell] {
        get {
            model.secondaryHouseData
        }
        set(newValue) {
            model.secondaryHouseData = newValue
        }
    }
    var planetData: [PlanetCell] {
        get {
            model.planetData
        }
        set(newValue) {
            model.planetData = newValue
        }
    }
    var personOnePlanetData: [PlanetCell] {
        get {
            model.personOnePlanetData
        }
        set(newValue) {
            model.personOnePlanetData = newValue
        }
    }
    var personTwoPlanetData: [PlanetCell] {
        get {
            model.personTwoPlanetData
        }
        set(newValue) {
            model.personTwoPlanetData = newValue
        }
    }
    var secondaryPlanetData: [PlanetCell] {
        get {
            model.secondaryPlanetData
        }
        set(newValue) {
            model.secondaryPlanetData = newValue
        }
    }
    var aspectsData: [TransitCell] {
        get {
            model.aspectsData
        }
        set(newValue) {
            model.aspectsData = newValue
        }
    }
    var personOneAspectsData: [TransitCell] {
        get {
            model.personOneAspectsData
        }
        set(newValue) {
            model.personOneAspectsData = newValue
        }
    }
    var personTwoAspectsData: [TransitCell] {
        get {
            model.personTwoAspectsData
        }
        set(newValue) {
            model.personTwoAspectsData = newValue
        }
    }
    var houseDictionary: [Int: (Int, Signs)] {
        get {
            model.houseDictionary
        }
        set(newValue) {
            model.houseDictionary = newValue
        }
    }
    var secondaryHouseDictionary: [Int: (Int, Signs)] {
        get {
            model.secondaryHouseDictionary
        }
        set(newValue) {
            model.secondaryHouseDictionary = newValue
        }
    }
    var planetsDictionary: [Int: [PlanetCell]] {
        get {
            model.planetsDictionary
        } set(newValue) {
            model.planetsDictionary = newValue
        }
    }
    var secondaryPlanetsDictionary: [Int: [PlanetCell]] {
        get {
            model.secondaryPlanetsDictionary
        }
        set(newValue) {
            model.secondaryPlanetsDictionary = newValue
        }
    }
    var planetToDegreeMap: [Planets: Int] {
        get {
            model.planetToDegreeMap
        }
        set(newValue) {
            model.planetToDegreeMap = newValue
        }
    }
    var secondaryPlanetToDegreeMap: [Planets: Int] {
        get {
            model.secondaryPlanetToDegreeMap
        }
        set(newValue) {
            model.secondaryPlanetToDegreeMap = newValue
        }
    }
    var width: Double  {
        get {
            model.width
        }
        set(newValue) {
            model.width = newValue
        }
    }
    var height: Double {
        get {
            model.height
        }
        set(newValue) {
            model.height = newValue
        }
    }
    var chart: Charts {
        model.chart
    }
    
    var upperPrintingQueue = [((Double, Int), PrintSize)]()
    var lowerPrintingQueue = [((Double, Int), PrintSize)]()
    var natalPrintingQueue = [((Double, Int), PrintSize)]()
    
    
    init(model: WheelChartModel) {
        self.model = model
    }
    func populateData() {
        if !planetsDictionary.isEmpty {
            return
        }
        
        if houseData.count > 0 {
            for i in 0...houseData.count - 1 {
                var a = i
                if a == 0 {
                    a = 12
                }
                houseDictionary[Int(houseData[a - 1].numericDegree)] = (a, houseData[a - 1].sign)
            }
        }
        if secondaryHouseData.count > 0 {
            for i in 0...secondaryHouseData.count - 1 {
                var a = i
                if a == 0 {
                    a = 12
                }
                secondaryHouseDictionary[Int(secondaryHouseData[a - 1].numericDegree)] = (a, secondaryHouseData[a - 1].sign)
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
            } else {
                
     #if os(iOS)
                value += 10
    #endif
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
    var innerHouseThickness: Double {
        if chart != .Synastry {
            return 0
        }
#if os(iOS)
        let idiom : UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        if idiom == .pad {
            return 15
        }
        return 10
        
#else
        return 15
#endif
    }
    var interiorRadius: Double {
#if os(iOS)
        let idiom : UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        if idiom == .pad {
            return (radius - getArcStrokeWidth() + innerRadius) / 2
        }
        return (radius - getArcStrokeWidth() + innerRadius) / 2 
        
#else
        (radius - getArcStrokeWidth() + innerRadius) / 2
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
    
    func showAscendant() -> Bool {
        if houseData.isEmpty {
            return false
        }
        let ascendentDegree = planetData.filter( { $0.planet == .Ascendant} )
        if !ascendentDegree.isEmpty {
            if ascendentDegree[0].numericDegree != houseData[0].numericDegree {
                return true
            }
        }
        return false
    }
    func showMC() -> Bool {
        if houseData.isEmpty {
            return false
        }
        let mcDegree = planetData.filter( { $0.planet == .MC} )
        if !mcDegree.isEmpty {
            if mcDegree[0].numericDegree != houseData[9].numericDegree {
                return true
            }
        }
        return false
    }
    
    func computeUpperSeperation(_ planetArray: [PlanetCell], _ trueDegree: Double) {
        let sortedArray = planetArray.sorted(by: {$0.numericDegree > $1.numericDegree })
        var i = 0
        for planet in sortedArray {
            if (planet.planet == .Ascendant) || (planet.planet == .MC) {
                continue
            }
            var printDegree = trueDegree
            var seperation = 4.5
#if os(iOS)
            if idiom != .pad {
                seperation = 5.6
            }
            
#endif
            printDegree = trueDegree
            lastPrintingDegree = Int(printDegree)
            printingStack.append(lastPrintingDegree)
            upperPrintingQueue.append(((printDegree, upperPrintingQueue.count), .regular))
            justifyUpperPrintingQueue(seperation: seperation)
            i += 1
            
        }
    }
    
    func justifyUpperPrintingQueue(seperation: Double) {
        if upperPrintingQueue.count < 2 {
            return
        }
        for i in 0..<upperPrintingQueue.count - 1 {
            let j = upperPrintingQueue.count - 2 - i
            if (upperPrintingQueue[j].0.0 + seperation) > upperPrintingQueue[j + 1].0.0 {
                upperPrintingQueue[j].0.0 = upperPrintingQueue[j + 1].0.0 - seperation
            } else {
                break
            }
        }
    }
    
    func computeLowerSeperation(_ planetArray: [PlanetCell], _ trueDegree: Double) {
        let sortedArray = planetArray.sorted(by: {$0.numericDegree > $1.numericDegree })
        var i = 0
        for planet in sortedArray {
            if (planet.planet == .Ascendant && !showAscendant()) || (planet.planet == .MC && !showMC()) {
                continue
            }
            var printDegree = trueDegree
            var seperation = 4.5
#if os(iOS)
            if idiom != .pad {
                seperation = 5.6
            }
            
#endif
            printDegree = trueDegree
            secondaryLastPrintingDegree = Int(printDegree)
            secondaryPrintingStack.append(secondaryLastPrintingDegree)
            lowerPrintingQueue.append(((printDegree, lowerPrintingQueue.count), .regular))
            i += 1
            justifyLowerPrintingQueue(seperation: seperation)
        }
        
    }
    
    func justifyLowerPrintingQueue(seperation: Double) {
        if lowerPrintingQueue.count < 2 {
            return
        }
        for i in 0..<lowerPrintingQueue.count - 1 {
            let j = lowerPrintingQueue.count - 2 - i
            if (lowerPrintingQueue[j].0.0 + seperation) > lowerPrintingQueue[j + 1].0.0 {
                lowerPrintingQueue[j].0.0 = lowerPrintingQueue[j + 1].0.0 - seperation
            } else {
                break
            }
        }
    }
    
    
    
    func computeNatalSeperation(_ planetArray: [PlanetCell], _ trueDegree: Double) {
        let sortedArray = planetArray.sorted(by: {$0.numericDegree > $1.numericDegree })
        var i = 0
        for planet in sortedArray {
            if (planet.planet == .Ascendant && !showAscendant()) || (planet.planet == .MC && !showMC())  {
                continue
            }
            var printDegree = trueDegree
            var seperation = 4.5
#if os(iOS)
            if idiom != .pad {
                seperation = 5.6
            }
            
#endif
            printDegree = trueDegree
            lastPrintingDegree = Int(printDegree)
            printingStack.append(lastPrintingDegree)
            natalPrintingQueue.append(((printDegree, natalPrintingQueue.count), .regular))
            justifyNatalPrintingQueue(seperation: seperation)
            
            i += 1
        }
        
    }
    
    func justifyNatalPrintingQueue(seperation: Double) {
        if natalPrintingQueue.count < 2 {
            return
        }
        for i in 0..<natalPrintingQueue.count - 1 {
            let j = natalPrintingQueue.count - 2 - i
            if (natalPrintingQueue[j].0.0 + seperation) > natalPrintingQueue[j + 1].0.0 {
                natalPrintingQueue[j].0.0 = natalPrintingQueue[j + 1].0.0 - seperation
            } else {
                break
            }
        }
    }
    
    func computeNatalPrintingQueue() {
        guard let manager = manager else {
            return
        }
        lastPrintingDegree = -Int.max
        printingStack.removeAll()
        natalPrintingQueue.removeAll()
        for a in 0...359 {
            let trueDegree =  getChartStartDegree()  + Double(a)
            if let planetArray = planetsDictionary[a] {
                let usersPlanets = planetArray.filter { manager.bodiesToShow.contains($0.planet) }
                if !usersPlanets.isEmpty {
                    if !usersPlanets.filter({($0.planet != .Ascendant || showAscendant()) && ($0.planet != .MC || showMC())}).isEmpty {
                        computeNatalSeperation(usersPlanets, trueDegree)
                    }
                }
            }
        }
        natalPrintingQueue = fixPiscesAriesSeperation(queue: natalPrintingQueue)
        natalPrintingQueue = fixPrintDegreeSeperation(inputQueue: natalPrintingQueue)
        natalPrintingQueue = computePrintingSizes(queue: natalPrintingQueue)
        //natalPrintingQueue = enforceMinimumSeperation(inputQueue: natalPrintingQueue)
    }
    
    func computePrintingQueues() {
        guard let manager = manager else {
            return
        }
        secondaryLastPrintingDegree = -Int.max
        secondaryPrintingStack.removeAll()
        lastPrintingDegree = -Int.max
        printingStack.removeAll()
        lowerPrintingQueue.removeAll()
        upperPrintingQueue.removeAll()
        for a in 0...359 {
            let trueDegree =  getChartStartDegree()  + Double(a)
            if let planetArray = secondaryPlanetsDictionary[a] {
                let usersPlanets = planetArray.filter { manager.bodiesToShow.contains($0.planet) }
                if !usersPlanets.isEmpty {
                    if !usersPlanets.filter({($0.planet != .Ascendant) && ($0.planet != .MC)}).isEmpty {
                        computeUpperSeperation(usersPlanets, trueDegree)
                    }
                }
            }
            
            if let planetArray =  planetsDictionary[a] {
                let usersPlanets = planetArray.filter { manager.bodiesToShow.contains($0.planet) }
                if !usersPlanets.isEmpty {
                    if !usersPlanets.filter({($0.planet != .Ascendant || showAscendant()) && ($0.planet != .MC || showMC())}).isEmpty {
                        computeLowerSeperation(usersPlanets, trueDegree)
                    }
                }
            }
        }
        upperPrintingQueue = fixPiscesAriesSeperation(queue: upperPrintingQueue)
        lowerPrintingQueue = fixPiscesAriesSeperation(queue: lowerPrintingQueue)
        upperPrintingQueue = fixPrintDegreeSeperation(inputQueue: upperPrintingQueue)
        lowerPrintingQueue = fixPrintDegreeSeperation(inputQueue: lowerPrintingQueue)
        upperPrintingQueue = computePrintingSizes(queue: upperPrintingQueue)
        lowerPrintingQueue = computePrintingSizes(queue: lowerPrintingQueue)
        //lowerPrintingQueue = enforceMinimumSeperation(inputQueue: lowerPrintingQueue)
        //upperPrintingQueue = enforceMinimumSeperation(inputQueue: upperPrintingQueue)
        
    }
    
    func getUpperPrintingDegree() -> (Double, PrintSize) {
        if upperPrintingQueue.isEmpty {
            return (0, .regular)
        }
        let val = upperPrintingQueue.remove(at: 0)
        return (val.0.0, val.1)
        
        
    }
    func getLowerPrintingDegree() -> (Double, PrintSize) {
        if lowerPrintingQueue.isEmpty {
            return (0, .regular)
        }
        let val = lowerPrintingQueue.remove(at: 0)
        return (val.0.0, val.1)
    }
    
    func getNatalPrintingDegree() -> (Double, PrintSize) {
        if natalPrintingQueue.isEmpty {
            return (0, .regular)
        }
        let val = natalPrintingQueue.remove(at: 0)
        return (val.0.0, val.1)
    }
    
    func fixPiscesAriesSeperation(queue: [((Double, Int), PrintSize)]) -> [((Double, Int), PrintSize)]  {
        if queue.count < 3 {
            return queue
        }
        var max = -999.9
        var i = 0
        var greatest = (0, 0.0)
        var least = (0, 0.0)
        
        for val in queue {
            if val.0.0 > max {
                max = val.0.0
                greatest = (i, max)
            }
            i += 1
        }
        i = 0
        var min = 9999.9
        for val in queue {
            if val.0.0 < min {
                min = val.0.0
                least = (i, min)
            }
            i += 1
        }
        
        let diff =  least.1 + 360.0 - greatest.1
        if diff < 5.0 {
            var queue1 = queue
            queue1[least.0].0.0 +=  5.0 - diff
            
            i = 0
            var least2 = (0, 0.0)
            var min = 9999.9
            for val in queue {
                if val.0.0 < min && i != least.0 {
                    min = val.0.0
                    least2 = (i, min)
                }
                i += 1
            }
            if least2.1 <= least.1  {
                let diff = least.1 - least2.1 + 5.0
                queue1[least2.0].0.0 += diff
            } else if least2.1 - least.1 < 5.0 {
                let diff = 5.0 - (least2.1 - least.1)
                queue1[least2.0].0.0 += diff
            }
            
            
            return queue1
        }
        
        return queue
    }
    
    func computePrintingSizes(queue: [((Double, Int), PrintSize)]) -> [((Double, Int), PrintSize)] {
        var outputQueue = queue
        if outputQueue.isEmpty {
            return [((Double, Int), PrintSize)]()
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
                    if outputQueue[1].0.0 - outputQueue[0].0.0 > targetSpread {
                        outputQueue[0].1 = .large
                    }
                }
            } else if i == outputQueue.count - 1 {
                if outputQueue.count > 1 {
                    if outputQueue[outputQueue.count - 1].0.0 - outputQueue[outputQueue.count - 2].0.0 > targetSpread {
                        outputQueue[outputQueue.count - 1].1 = .large
                    }
                }
            } else {
                if i < outputQueue.count - 1 && i > 0 {
                    if outputQueue[i + 1].0.0 - outputQueue[i].0.0 > targetSpread {
                        if outputQueue[i].0.0 - outputQueue[i - 1].0.0 > targetSpread {
                            
                            if i > 1 {
                                if outputQueue[i].0.0 - outputQueue[i - 2].0.0 > targetSpread {
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
    
    func fixPrintDegreeSeperation(inputQueue: [((Double, Int), PrintSize)]) -> [((Double, Int), PrintSize)] {
        var queue = inputQueue
        if queue.count > 1 {
            var desiredSpace = 5.5
            
#if os(iOS)
            if idiom != .pad {
                desiredSpace = 6.5
            }
            
#endif
            for i in 0...queue.count-2 {
                if queue[i + 1].0.0 - queue[i].0.0 < desiredSpace {
                    let offset = desiredSpace - abs(queue[i + 1].0.0 - queue[i].0.0)
                    if queue[i + 1].0.0 - queue[i].0.0 > 0 {
                        if i > 0 && queue[i].0.0 - queue[i - 1].0.0 > desiredSpace * 2 {
                            queue[i].0.0 -= offset
                        } else if i == 0 {
                            queue[i].0.0 -= offset
                        }
                    }
                } else if i > 0 {
                    if abs(queue[i + 1].0.0 - queue[i - 1].0.0) < desiredSpace {
                        let offset = desiredSpace - abs(queue[i + 1].0.0 - queue[i - 1].0.0)
                        if queue[i + 1].0.0 - queue[i - 1].0.0 > 0 {
                            if i + 2 < queue.count {
                                if queue[i + 2].0.0 - queue[i + 1].0.0 > desiredSpace * 2 {
                                    queue[i + 1].0.0 += offset
                                }
                            } else if i + 2 == queue.count {
                                queue[i + 1].0.0 += offset
                            }
                            
                        }
                    }
                    
                    if queue[i].0 < queue[i - 1].0 {
                        if queue[i - 1].0.0 - queue[i].0.0 < desiredSpace {
                            let offset = desiredSpace - abs(queue[i - 1].0.0 - queue[i].0.0)
                            if i + 1 < queue.count {
                                if queue[i + 1].0.0 - queue[i - 1].0.0 > desiredSpace * 2 {
                                    queue[i - 1].0.0 += offset
                                }
                            } else if i + 1 == queue.count {
                                queue[i - 1].0.0 += offset
                            }
                            
                        }
                    }
                }
            }
        }
        return queue
    }
    
    func enforceMinimumSeperation(inputQueue: [((Double, Int), PrintSize)]) -> [((Double, Int), PrintSize)] {
        if inputQueue.count > 1 {
            var desiredSpace = 4.5
#if os(iOS)
            if idiom != .pad {
                desiredSpace = 5.6
            }
#endif
            var fixes = 0
            var queue1 = inputQueue.sorted(by: { $0.0.0 < $1.0.0 })
            for i in 0...inputQueue.count - 2 {
                if queue1[i + 1].0.0 - queue1[i].0.0 < desiredSpace {
                    queue1[i + 1].0.0 += desiredSpace - (queue1[i + 1].0.0 - queue1[i].0.0)
                    fixes += 1
                }
            }
            
            queue1 = queue1.sorted(by: { $0.0.1 < $1.0.1 })
            /*var qFirst = queue1[0].0.0
            var qLast = queue1[queue1.count - 1].0.0
            if qLast > qFirst + 360.0 {
                qFirst += 360.0
                if qLast - qFirst < desiredSpace && qLast - qFirst > 0 {
                    let space = desiredSpace - (qFirst - qLast)
                    queue1[0].0.0 += space
                    queue1 = queue1.sorted(by: { $0.0.1 < $1.0.1 })
                }
            }
            */
            return queue1
        }
        return inputQueue
        
    }
    
    func getUpperWheelSpread() -> (Double, Double) {
        var spread = radius * 0.083
        var firstSpread = 1.8
#if os(iOS)
        if idiom != .pad {
            spread = spread * 1.4
            firstSpread = 1.8
        } else {
            firstSpread = 1.7
        }
        
#else
        spread = spread * 1.1
#endif
        return (spread, firstSpread)
    }
    
    func getLowerWheelSpread() -> (Double, Double) {
        var spread = interiorRadius * 0.065
        var firstSpread = 2.5
#if os(iOS)
        if idiom != .pad {
            spread = spread * 1.7
            firstSpread = 2.3
        }
#else
        spread = spread * 1.5
#endif
        return (spread,firstSpread)
    }
    
    func getNatalWheelSpread() -> (Double, Double) {
        var spread = radius * 0.115
        var firstSpread = 1.7
#if os(iOS)
        if idiom != .pad {
            spread = spread * 1.45
            firstSpread = 1.5
        }
#else
        spread = spread * 1.1
#endif
        return (spread, firstSpread)
    }
}

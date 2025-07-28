/*
*  Copyright (C) 2022-2024 Michael R Adams.
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
//  Created by Michael Adams on 4/15/24.
//

import Foundation
import SwiftUI
class SynastryChooserViewModel: AstrobotInterface {
    @AppStorage("synastrynameone") var name1: String = ""
    @AppStorage("synastrynametwo") var name2: String = ""
    let manager: BirthDataManager
    
    init(manager: BirthDataManager) {
        self.manager = manager
    }
    func getSynastryChart(selectedNameOne: String, selectedNameTwo: String) -> ChartViewModel? {
        if selectedNameOne.isEmpty || selectedNameTwo.isEmpty {
            return nil
        }
        guard let data1 = manager.birthDates.first(where:  { $0.name == selectedNameOne })
        else {
            return nil
        }
        guard let data2 = manager.birthDates.first(where:  { $0.name == selectedNameTwo })
        else {
            return nil
        }
        
        let viewModel = ChartViewModel(model: WheelChartModel(chartName: data1.name + " + " + data2.name, chart: .Synastry, manager: manager))
        viewModel.name1 = selectedNameOne
        viewModel.name2 = selectedNameTwo
        viewModel.planetData = getPlanetData(data: data1)
        viewModel.aspectsData = getAspectsData(data: data1, data2: data2)
        viewModel.personOneAspectsData = populateAspectsData(data1.getAstroTime(), data1.location)
        viewModel.personTwoAspectsData = populateAspectsData(data2.getAstroTime(), data2.location)
        viewModel.houseData = getHouseData(data: data1)
        
        viewModel.secondaryPlanetData = getPlanetData(data: data2)
        viewModel.secondaryHouseData = getHouseData(data: data2)
        viewModel.houseSystemName = manager.houseSystem.rawValue
        viewModel.tropical = manager.tropical
        name1 = selectedNameOne
        name2 = selectedNameTwo
        return viewModel
    }
    
    func getCompositePlusDateChart(selectedNameOne: String, selectedNameTwo: String, transitDate: Date = Date()) -> ChartViewModel? {
        if selectedNameOne.isEmpty || selectedNameTwo.isEmpty {
            return nil
        }
        guard let data1 = manager.birthDates.first(where:  { $0.name == selectedNameOne })
        else {
            return nil
        }
        guard let data2 = manager.birthDates.first(where:  { $0.name == selectedNameTwo })
        else {
            return nil
        }
        let dateFormater = DateFormatter()
        dateFormater.locale   = Locale(identifier: "en_US_POSIX")
        dateFormater.dateFormat = "YY/MM/dd h:m"
        let viewModel = ChartViewModel(model: WheelChartModel(chartName: data1.name + " + " + data2.name + " + " + dateFormater.string(from: transitDate), chart: .Transit, manager: manager))
        viewModel.name2 = dateFormater.string(from: transitDate)
        viewModel.name1 = selectedNameOne + " + " + selectedNameTwo
        guard let compositeModel = getCompositeChart(selectedNameOne: selectedNameOne, selectedNameTwo: selectedNameTwo) else {
            return nil
        }
        
        let aspectsRow = getAspectsFromPlanets(compositeModel.planetData, with: transitDate.getAstroTime(), type: manager.transitOrbSelection)
        if let aspects = aspectsRow.planets as? [TransitCell] {
            viewModel.aspectsData = aspects
        } else {
            viewModel.aspectsData = [TransitCell]()
        }
        viewModel.houseData = compositeModel.houseData
        viewModel.houseSystemName = manager.houseSystem.rawValue
        viewModel.tropical = manager.tropical
        viewModel.planetData = compositeModel.planetData
        viewModel.secondaryPlanetData = populatePlanetsData(transitDate.getAstroTime(), nil)
        viewModel.personOneAspectsData = compositeModel.aspectsData
        viewModel.personTwoAspectsData = populateAspectsData(transitDate.getAstroTime(), nil)
        return viewModel
        
    }
    
    func populatePlanetsData(_ date: Double, _ location: LocationData?) -> [PlanetCell] {
        let row = getPlanets(time: date, location: location, calculationSettings: manager.calculationSettings)
        if let planets = row.planets as? [PlanetCell] {
            return planets
        }
        return [PlanetCell]()
    }
    
    func populateAspectsData(_ date: Double, _ location: LocationData?, secondTime: Double? = nil) -> [TransitCell] {
        let orbSelection = secondTime != nil ? manager.transitOrbSelection : manager.orbSelection
        let aspectsRow = getAspects(time: date, with: secondTime, and: location, type: orbSelection, calculationSettings: manager.calculationSettings)
        
        if let aspects = aspectsRow.planets as? [TransitCell] {
             return aspects
        }
        return [TransitCell]()
    }
    
    func getCompositeChart(selectedNameOne: String, selectedNameTwo: String) -> ChartViewModel? {
        if selectedNameOne.isEmpty || selectedNameTwo.isEmpty {
            return nil
        }
        guard let data1 = manager.birthDates.first(where:  { $0.name == selectedNameOne })
        else {
            return nil
        }
        guard let data2 = manager.birthDates.first(where:  { $0.name == selectedNameTwo })
        else {
            return nil
        }
        
        let viewModel = ChartViewModel(model: WheelChartModel(chartName: data1.name + " + " + data2.name, chart: .Natal, manager: manager))
        viewModel.name1 = selectedNameOne
        viewModel.name2 = selectedNameTwo
        viewModel.showIndividualCompositeData = true
        let planetDataOne = getPlanetData(data: data1)
        let planetDataTwo = getPlanetData(data: data2)
        viewModel.personOnePlanetData = planetDataOne
        viewModel.personTwoPlanetData = planetDataTwo
        viewModel.personOneAspectsData = populateAspectsData(data1.getAstroTime(), data1.location)
        viewModel.personTwoAspectsData = populateAspectsData(data2.getAstroTime(), data2.location)
        viewModel.planetData = getMidPointPlanetData(dataOne: planetDataOne, dataTwo: planetDataTwo)
        
        let aspectsRow = getAspectsFromPlanets(viewModel.planetData, with: nil, type: manager.orbSelection)
        if let aspects = aspectsRow.planets as? [TransitCell] {
            viewModel.aspectsData = aspects
        } else {
            viewModel.aspectsData = [TransitCell]()
        }
        
        let houseDataOne = getHouseData(data: data1)
        let houseDataTwo = getHouseData(data: data2)
        viewModel.houseSystemName = manager.houseSystem.rawValue
        viewModel.tropical = manager.tropical
        viewModel.personOneHouseData = houseDataOne
        viewModel.personTwoHouseData = houseDataTwo
        viewModel.houseData = getMidPointHouseData(dataOne: houseDataOne, dataTwo: houseDataTwo)
        name1 = selectedNameOne
        name2 = selectedNameTwo
        return viewModel
    }

    func getPlanetData(data: BirthData) -> [PlanetCell] {
        let row = getPlanets(time: data.getAstroTime(), location: data.location, calculationSettings: manager.calculationSettings)
        
        if let planets = row.planets as? [PlanetCell] {
            return planets
        }
        return [PlanetCell]()
    }
    
    func getAspectsData(data: BirthData, data2: BirthData) -> [TransitCell] {
        let aspectsRow = getAspects(time: data.getAstroTime(), with: data2.getAstroTime(), and: data.location, location2: data2.location, type: manager.synastryOrbSelection, calculationSettings: manager.calculationSettings)
        
        if let aspects = aspectsRow.planets as? [TransitCell] {
            return aspects
        }
        return [TransitCell]()
    }
    
    func getHouseData(data: BirthData) -> [HouseCell] {
        if let location = data.location {
            let housesRow = getHouses(time: data.getAstroTime(), location: location, system: manager.houseSystem.getHouseCode(), calculationSettings:  manager.calculationSettings)
            if let planets = housesRow.planets as? [HouseCell] {
                return planets
            }
        }
        return [HouseCell]()
    }
    
    func getMidPointPlanetData(dataOne: [PlanetCell], dataTwo: [PlanetCell]) -> [PlanetCell] {
        var newData = [PlanetCell]()
        for planet in Planets.allCases {
            let planet1 = dataOne.first { $0.planet == planet }
            let planet2 = dataTwo.first { $0.planet == planet }
            if planet1 == nil ||  planet2 == nil {
                continue
            }
            let degree = getMidPointDegreee(planet1!.numericDegree, planet2!.numericDegree)
            let planetCell = PlanetCell(planet: planet1!.planet, degree: degree.getAstroDegree(), sign: degree.getAstroSign(), retrograde: false, numericDegree: degree)
            newData.append(planetCell)
        }
        return newData
    }
    
    func getMidPointHouseData(dataOne: [HouseCell], dataTwo: [HouseCell]) -> [HouseCell] {
        if dataOne.isEmpty || dataTwo.isEmpty {
            return [HouseCell]()
        }
        var newData = [HouseCell]()
        for i in 0..<dataOne.count {
            
            let degree = getMidPointDegreee(dataOne[i].numericDegree, dataTwo[i].numericDegree)
            let houseCell = HouseCell(degree: degree.getAstroDegree(), sign: degree.getAstroSign(), house: dataOne[i].house, numericDegree: degree, type: dataOne[i].type)
            if houseCell.type == .House {
                newData.append(houseCell)
            }
        }
        return newData
    }
    
    func getMidPointDegreee(_ degreeOne: Double, _ degreeTwo: Double) -> Double {
        var degree1 = degreeOne
        var degree2 = degreeTwo
        if degree1 < 180.0 && degree2 > 180.0 {
            if degree2 > degree1 + 180 {
                degree2 = degree2 - 360
            }
        } else if degree2 < 180.0 && degree1 > 180.0 {
            if degree1 > degree2 + 180 {
               degree1 = degree1 - 360
            }
        }
        var degree = (degree1 + degree2) / 2
        if degree < 0 {
            degree = 360 + degree
        }
        
        return degree
    }
}

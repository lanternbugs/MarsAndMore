//
//  SynastryChooserViewModel.swift
//  MarsAndMore
//
//  Created by Michael Adams on 4/15/24.
//

import Foundation
import SwiftUI
class SynastryChooserViewModel: AstrobotInterface {
    @AppStorage("synastrynameone") var name1: String = ""
    @AppStorage("synastrynametwo") var name2: String = ""
    func getChart(selectedNameOne: String, selectedNameTwo: String, manager: BirthDataManager) -> ChartViewModel? {
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
        
        let viewModel = ChartViewModel(chartName: data1.name + " + " + data2.name, chartType: .Synastry)
        viewModel.manager = manager
        viewModel.name1 = selectedNameOne
        viewModel.name2 = selectedNameTwo
        viewModel.planetData = getPlanetData(data: data1, manager: manager)
        viewModel.aspectsData = getAspectsData(data: data1, data2: data2, manager: manager)
        viewModel.houseData = getHouseData(data: data1, manager: manager)
        
        viewModel.secondaryPlanetData = getPlanetData(data: data2, manager: manager)
        viewModel.secondaryHouseData = getHouseData(data: data2, manager: manager)
        name1 = selectedNameOne
        name2 = selectedNameTwo
        return viewModel
    }

    func getPlanetData(data: BirthData, manager: BirthDataManager) -> [PlanetCell] {
        let row = getPlanets(time: data.getAstroTime(), location: data.location, calculationSettings: manager.calculationSettings)
        
        if let planets = row.planets as? [PlanetCell] {
            return planets
        }
        return [PlanetCell]()
    }
    
    func getAspectsData(data: BirthData, data2: BirthData, manager: BirthDataManager) -> [TransitCell] {
        let aspectsRow = getAspects(time: data.getAstroTime(), with: data2.getAstroTime(), and: data.location, location2: data2.location, type: manager.synastryOrbSelection, calculationSettings: manager.calculationSettings)
        
        if let aspects = aspectsRow.planets as? [TransitCell] {
            return aspects
        }
        return [TransitCell]()
    }
    
    func getHouseData(data: BirthData, manager: BirthDataManager) -> [HouseCell] {
        if let location = data.location {
            let housesRow = getHouses(time: data.getAstroTime(), location: location, system: manager.houseSystem.getHouseCode(), calculationSettings:  manager.calculationSettings)
            if let planets = housesRow.planets as? [HouseCell] {
                return planets
            }
        }
        return [HouseCell]()
    }
}

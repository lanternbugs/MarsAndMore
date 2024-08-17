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
    func getChart(selectedNameOne: String, selectedNameTwo: String) -> ChartViewModel? {
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
        viewModel.planetData = getPlanetData(data: data1)
        viewModel.aspectsData = getAspectsData(data: data1, data2: data2)
        viewModel.houseData = getHouseData(data: data1)
        
        viewModel.secondaryPlanetData = getPlanetData(data: data2)
        viewModel.secondaryHouseData = getHouseData(data: data2)
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
}

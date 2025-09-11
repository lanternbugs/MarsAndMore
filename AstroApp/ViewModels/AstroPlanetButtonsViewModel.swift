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
class AstroPlanetButtonsViewModel: ObservableObject, AstrobotInterface {
    var buttonsEnabled = true
    let manager: BirthDataManager
    var data: Binding<[DisplayPlanetRow]>
    
    
    init(data: Binding<[DisplayPlanetRow]>, manager: BirthDataManager) {
        self.data = data
        self.manager = manager
    }
    
    func temporaryDisableButtons()->Void
    {
        buttonsEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.buttonsEnabled = true
        }
    }
    
    func populateHouseData(_ date: Double, _ location: LocationData?, housesOnly: Bool = true) -> [HouseCell] {
        if let location = location {
            let houseRow = getHouses(time: date, location: location, system: manager.houseSystem.getHouseCode(), calculationSettings:  manager.calculationSettings)
            if let houses = houseRow.planets as? [HouseCell] {
                if housesOnly {
                    return reduceHouses(houses)
                }
                return houses
            }
        }
        return [HouseCell]()
    }
    
    func reduceHouses(_ houseArray: [HouseCell]) -> [HouseCell] {
        return houseArray.filter( { $0.type == HouseCellType.House })
    }
    
    func populateAspectsData(_ date: Double, _ location: LocationData?, secondTime: Double? = nil) -> [TransitCell] {
        let orbSelection = secondTime != nil ? manager.transitOrbSelection : manager.orbSelection
        let aspectsRow = getAspects(time: date, with: secondTime, and: location, type: orbSelection, calculationSettings: manager.calculationSettings)
        
        if let aspects = aspectsRow.planets as? [TransitCell] {
             return aspects
        }
        return [TransitCell]()
    }
    
    func populatePlanetsData(_ date: Double, _ location: LocationData?) -> [PlanetCell] {
        let row = getPlanets(time: date, location: location, calculationSettings: manager.calculationSettings)
        if let planets = row.planets as? [PlanetCell] {
            return planets
        }
        return [PlanetCell]()
    }
    
    func planets(savedDate: PlanetsDate)
    {
        guard buttonsEnabled else {
            return
        }
        temporaryDisableButtons()
        
        let viewModel = ChartViewModel(model: WheelChartModel(chartName: savedDate.planetsDateChoice.description, chart: .Natal, manager: manager))
        viewModel.model.selectedTime = savedDate.planetsDateChoice
        viewModel.model.originalSelectedTime = savedDate.planetsDateChoice
        viewModel.model.selectedLocation = manager.planetsLocationData
        viewModel.model.calculationSettings = manager.calculationSettings
        viewModel.model.tab = .PlanetsTab
        viewModel.planetData = populatePlanetsData(savedDate.planetsDateChoice.getAstroTime(), manager.planetsLocationData)
        viewModel.aspectsData = populateAspectsData(savedDate.planetsDateChoice.getAstroTime(), manager.planetsLocationData)
        viewModel.houseData = populateHouseData(savedDate.planetsDateChoice.getAstroTime(), manager.planetsLocationData)
        viewModel.houseSystemName = manager.houseSystem.rawValue
        viewModel.tropical = manager.tropical
        
        
        let displayRow = DisplayPlanetRow(planets: viewModel.planetData, id: data.wrappedValue.count, type: .Planets(viewModel: viewModel), name: getStringDate(savedDate: savedDate), calculationSettings: manager.calculationSettings)
        data.wrappedValue.append(displayRow)
    }
    
    func aspects(savedDate: PlanetsDate)
    {
        guard buttonsEnabled else {
            return
        }
        temporaryDisableButtons()
        let aspects = populateAspectsData(savedDate.planetsDateChoice.getAstroTime(), manager.planetsLocationData)
        let displayRow = DisplayPlanetRow(planets: aspects, id: data.wrappedValue.count, type: .Aspects(orbs: manager.orbSelection.getShortName()), name: getStringDate(savedDate: savedDate), calculationSettings: manager.calculationSettings)
        data.wrappedValue.append(displayRow)
    }
    
    func clearData()
    {
        data.wrappedValue.removeAll()
    }
    
    func getStringDate(savedDate: PlanetsDate)->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        if savedDate.exactPlanetsTime {
            dateFormatter.dateFormat = "YY-MM-dd HH:mm Z"
        }
        return dateFormatter.string(from: savedDate.planetsDateChoice)
    }
    
    func getChartViewModel(name: String, type: Charts) -> ChartViewModel {
        let viewModel = ChartViewModel(model: WheelChartModel(chartName: name, chart: type, manager: manager))
        return viewModel
    }
    
    func astroPlanets()
    {
        guard buttonsEnabled else {
            return
        }
        temporaryDisableButtons()

        let viewModel = getChartViewModel(name: manager.getCurrentName(), type: .Natal)
        viewModel.model.selectedTime = manager.getSelectionTimeAsDate()
        viewModel.model.originalSelectedTime = manager.getSelectionTimeAsDate()
        viewModel.model.selectedLocation = manager.getSelectionLocation()
        viewModel.model.calculationSettings = manager.calculationSettings
        viewModel.planetData = populatePlanetsData(manager.getSelectionTime(), manager.getSelectionLocation())
        viewModel.houseData = populateHouseData(manager.getSelectionTime(), manager.getSelectionLocation())
        viewModel.houseSystemName = manager.houseSystem.rawValue
        viewModel.tropical = manager.tropical
        viewModel.aspectsData = populateAspectsData(manager.getSelectionTime(), manager.getSelectionLocation())
        
        let displayRow = DisplayPlanetRow(planets: viewModel.planetData, id: data.wrappedValue.count, type: .Planets(viewModel: viewModel), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
        data.wrappedValue.append(displayRow)
    }
    
    func astroAspects()
    {
        guard buttonsEnabled else {
            return
        }
        temporaryDisableButtons()
        let aspects = populateAspectsData(manager.getSelectionTime(), manager.getSelectionLocation())
        let displayRow = DisplayPlanetRow(planets: aspects, id: data.wrappedValue.count, type: .Aspects(orbs: manager.orbSelection.getShortName()), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
        data.wrappedValue.append(displayRow)
    }
    
    func houses() -> ChartViewModel?
    {
        guard buttonsEnabled else {
            return nil
        }
        temporaryDisableButtons()
        if let location = manager.getSelectionLocation() {
            let viewModel = getChartViewModel(name: manager.getCurrentName(), type: .Natal)
            viewModel.model.selectedTime = manager.getSelectionTimeAsDate()
            viewModel.model.originalSelectedTime = manager.getSelectionTimeAsDate()
            viewModel.model.selectedLocation = manager.getSelectionLocation()
            viewModel.model.calculationSettings = manager.calculationSettings

            viewModel.houseData = populateHouseData(manager.getSelectionTime(), location, housesOnly: false)
            viewModel.houseSystemName = manager.houseSystem.rawValue
            viewModel.tropical = manager.tropical
            viewModel.planetData = populatePlanetsData(manager.getSelectionTime(), location)
            viewModel.aspectsData = populateAspectsData(manager.getSelectionTime(), location)
            let displayHouseData = viewModel.houseData
            viewModel.houseData = reduceHouses(viewModel.houseData)
            let displayRow = DisplayPlanetRow(planets: displayHouseData, id: data.wrappedValue.count, type: .Houses(system: manager.houseSystem, viewModel: viewModel), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
            data.wrappedValue.append(displayRow)
            return viewModel
        }
        return nil
        
    }
    
    func transits(transitDate: Date)
    {
        guard buttonsEnabled else {
            return
        }
        temporaryDisableButtons()
        
        
        let dateFormater = DateFormatter()
        dateFormater.locale   = Locale(identifier: "en_US_POSIX")
        dateFormater.dateFormat = "YY/MM/dd h:mm"
        let transitData = TransitTimeData(calculationSettings: manager.calculationSettings, time: manager.getSelectionTime(), transitTime: transitDate, location: manager.getSelectionLocation())
        let viewModel = getChartViewModel(name: "\(manager.getCurrentName()) + \(dateFormater.string(from: transitDate))", type: .Transit)
        viewModel.model.transitTime = transitDate
        viewModel.model.originalTransitTime = transitDate
        viewModel.model.selectedTime = manager.getSelectionTimeAsDate()
        viewModel.model.originalSelectedTime = manager.getSelectionTimeAsDate()
        viewModel.model.selectedLocation = manager.getSelectionLocation()
        viewModel.model.calculationSettings = manager.calculationSettings
        viewModel.name2 = dateFormater.string(from: transitDate)
        viewModel.name1 = manager.getCurrentName()
        viewModel.aspectsData = populateAspectsData(manager.getSelectionTime(), manager.getSelectionLocation(), secondTime: transitDate.getAstroTime())
        viewModel.personOneAspectsData = populateAspectsData(manager.getSelectionTime(), manager.getSelectionLocation())
        viewModel.personTwoAspectsData = populateAspectsData(transitDate.getAstroTime(), nil)
        viewModel.houseData = populateHouseData(manager.getSelectionTime(), manager.getSelectionLocation())
        viewModel.houseSystemName = manager.houseSystem.rawValue
        viewModel.tropical = manager.tropical
        viewModel.planetData = populatePlanetsData(manager.getSelectionTime(), manager.getSelectionLocation())
        viewModel.secondaryPlanetData = populatePlanetsData(transitDate.getAstroTime(), nil)
        
        let displayRow = DisplayPlanetRow(planets: viewModel.aspectsData, id: data.wrappedValue.count, type: .Transits(date: dateFormater.string(from: transitDate), orbs: manager.transitOrbSelection.getShortName(), transitData: transitData, chartName: manager.getCurrentName(), viewModel: viewModel), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
        data.wrappedValue.append(displayRow)
    }
}

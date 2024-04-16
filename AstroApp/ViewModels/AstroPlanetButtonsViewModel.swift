//
//  AstroPlanetButtonsViewModel.swift
//  MarsAndMore
//
//  Created by Michael Adams on 4/15/24.
//

import Foundation
import SwiftUI
class AstroPlanetButtonsViewModel: ObservableObject, AstrobotInterface {
    @Published var buttonsEnabled = true
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
    
    func populateHouseData(_ date: Double, _ location: LocationData?) -> [HouseCell] {
        if let location = location {
            let housesRow = getHouses(time: date, location: location, system: manager.houseSystem.getHouseCode(), calculationSettings:  manager.calculationSettings)
            if let houses = housesRow.planets as? [HouseCell] {
                return houses
            }
        }
        return [HouseCell]()
    }
    
    func populateAspectsData(_ date: Double, _ location: LocationData?) -> [TransitCell] {
        let aspectsRow = getAspects(time: date, with: nil, and: location, type: manager.orbSelection, calculationSettings: manager.calculationSettings)
        
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
        
        let viewModel = ChartViewModel(chartName: savedDate.planetsDateChoice.description, chartType: .Natal)
        viewModel.manager = manager
        
        viewModel.planetData = populatePlanetsData(savedDate.planetsDateChoice.getAstroTime(), manager.planetsLocationData)
        viewModel.aspectsData = populateAspectsData(savedDate.planetsDateChoice.getAstroTime(), manager.planetsLocationData)
        viewModel.houseData = populateHouseData(savedDate.planetsDateChoice.getAstroTime(), manager.planetsLocationData)
        
        
        let displayRow = DisplayPlanetRow(planets: viewModel.planetData, id: data.wrappedValue.count, type: .Planets(chartModel: viewModel), name: getStringDate(savedDate: savedDate), calculationSettings: manager.calculationSettings)
        data.wrappedValue.append(displayRow)
    }
    
    func aspects(savedDate: PlanetsDate)
    {
        guard buttonsEnabled else {
            return
        }
        temporaryDisableButtons()
        let row = getAspects(time: savedDate.planetsDateChoice.getAstroTime(), with: nil, and: nil, type: manager.orbSelection, calculationSettings: manager.calculationSettings)
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.wrappedValue.count, type: .Aspects(orbs: manager.orbSelection.getShortName()), name: getStringDate(savedDate: savedDate), calculationSettings: manager.calculationSettings)
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
        let viewModel = ChartViewModel(chartName: name, chartType: type)
        viewModel.manager = manager
        return viewModel
    }
    
    func astroPlanets()
    {
        guard buttonsEnabled else {
            return
        }
        temporaryDisableButtons()

        let viewModel = getChartViewModel(name: manager.getCurrentName(), type: .Natal)
        
        viewModel.planetData = populatePlanetsData(manager.getSelectionTime(), manager.getSelectionLocation())
        viewModel.houseData = populateHouseData(manager.getSelectionTime(), manager.getSelectionLocation())
        viewModel.aspectsData = populateAspectsData(manager.getSelectionTime(), manager.getSelectionLocation())
        
        let displayRow = DisplayPlanetRow(planets: viewModel.planetData, id: data.wrappedValue.count, type: .Planets(chartModel: viewModel), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
        data.wrappedValue.append(displayRow)
    }
    
    func astroAspects()
    {
        guard buttonsEnabled else {
            return
        }
        temporaryDisableButtons()
        let row = getAspects(time: manager.getSelectionTime(), with: nil, and: manager.getSelectionLocation(), type: manager.orbSelection, calculationSettings: manager.calculationSettings)
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.wrappedValue.count, type: .Aspects(orbs: manager.orbSelection.getShortName()), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
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

            viewModel.houseData = populateHouseData(manager.getSelectionTime(), location)
            viewModel.planetData = populatePlanetsData(manager.getSelectionTime(), location)
            viewModel.aspectsData = populateAspectsData(manager.getSelectionTime(), location)
            
            let displayRow = DisplayPlanetRow(planets: viewModel.houseData, id: data.wrappedValue.count, type: .Houses(system: manager.houseSystem, chartModel: viewModel), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
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
        
        let row = getAspects(time: manager.getSelectionTime(), with: transitDate.getAstroTime(), and: manager.getSelectionLocation(), type: manager.transitOrbSelection, calculationSettings: manager.calculationSettings)
        let dateFormater = DateFormatter()
        dateFormater.locale   = Locale(identifier: "en_US_POSIX")
        dateFormater.dateFormat = "YY/MM/dd h:m"
        let transitData = TransitTimeData(calculationSettings: manager.calculationSettings, time: manager.getSelectionTime(), transitTime: transitDate, location: manager.getSelectionLocation())
        let viewModel = getChartViewModel(name: "\(manager.getCurrentName()) + \(dateFormater.string(from: transitDate))", type: .Transit)
        viewModel.houseData = populateHouseData(manager.getSelectionTime(), manager.getSelectionLocation())
        viewModel.planetData = populatePlanetsData(manager.getSelectionTime(), manager.getSelectionLocation())
        viewModel.secondaryPlanetData = populatePlanetsData(transitDate.getAstroTime(), nil)
        
        
        if let aspects = row.planets as? [TransitCell] {
            viewModel.aspectsData = aspects
        }
        
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.wrappedValue.count, type: .Transits(date: dateFormater.string(from: transitDate), orbs: manager.transitOrbSelection.getShortName(), transitData: transitData, chartName: manager.getCurrentName(), chartModel: viewModel), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
        data.wrappedValue.append(displayRow)
    }
}

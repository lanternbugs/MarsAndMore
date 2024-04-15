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
   var data: Binding<[DisplayPlanetRow]>
    
    
    init(data: Binding<[DisplayPlanetRow]>) {
        self.data = data
    }
    func temporaryDisableButtons()->Void
    {
        buttonsEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.buttonsEnabled = true
        }
    }
    func planets(savedDate: PlanetsDate, manager: BirthDataManager)
    {
        guard buttonsEnabled else {
            return
        }
        temporaryDisableButtons()
        
        let row = getPlanets(time: savedDate.planetsDateChoice.getAstroTime(), location: manager.planetsLocationData, calculationSettings: manager.calculationSettings)
        let viewModel = ChartViewModel(chartName: savedDate.planetsDateChoice.description, chartType: .Natal)
        viewModel.manager = manager
        if let planets = row.planets as? [PlanetCell] {
            viewModel.planetData = planets
        }
        let aspectsRow = getAspects(time: savedDate.planetsDateChoice.getAstroTime(), with: nil, and: manager.planetsLocationData, type: manager.orbSelection, calculationSettings: manager.calculationSettings)
        
        if let aspects = aspectsRow.planets as? [TransitCell] {
            viewModel.aspectsData = aspects
        }
        if let location = manager.planetsLocationData {
            let housesRow = getHouses(time: savedDate.planetsDateChoice.getAstroTime(), location: location, system: manager.houseSystem.getHouseCode(), calculationSettings:  manager.calculationSettings)
            if let planets = housesRow.planets as? [HouseCell] {
                viewModel.houseData = planets
            }
        }
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.wrappedValue.count, type: .Planets(chartModel: viewModel), name: getStringDate(savedDate: savedDate), calculationSettings: manager.calculationSettings)
        data.wrappedValue.append(displayRow)
    }
    
    func aspects(savedDate: PlanetsDate, manager: BirthDataManager)
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
    
    func astroPlanets(manager: BirthDataManager)
    {
        guard buttonsEnabled else {
            return
        }
        temporaryDisableButtons()
        
        let row = getPlanets(time: manager.getSelectionTime(), location: manager.getSelectionLocation(), calculationSettings: manager.calculationSettings)
        let viewModel = ChartViewModel(chartName: manager.getCurrentName(), chartType: .Natal)
        viewModel.manager = manager
        if let planets = row.planets as? [PlanetCell] {
            viewModel.planetData = planets
        }
        if let location = manager.getSelectionLocation() {
            let housesRow = getHouses(time: manager.getSelectionTime(), location: location, system: manager.houseSystem.getHouseCode(), calculationSettings:  manager.calculationSettings)
            if let planets = housesRow.planets as? [HouseCell] {
                viewModel.houseData = planets
            }
        }
        
        let aspectsRow = getAspects(time: manager.getSelectionTime(), with: nil, and: manager.getSelectionLocation(), type: manager.orbSelection, calculationSettings: manager.calculationSettings)
        
        if let aspects = aspectsRow.planets as? [TransitCell] {
            viewModel.aspectsData = aspects
        }
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.wrappedValue.count, type: .Planets(chartModel: viewModel), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
        data.wrappedValue.append(displayRow)
    }
    
    func astroAspects(manager: BirthDataManager)
    {
        guard buttonsEnabled else {
            return
        }
        temporaryDisableButtons()
        let row = getAspects(time: manager.getSelectionTime(), with: nil, and: manager.getSelectionLocation(), type: manager.orbSelection, calculationSettings: manager.calculationSettings)
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.wrappedValue.count, type: .Aspects(orbs: manager.orbSelection.getShortName()), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
        data.wrappedValue.append(displayRow)
    }
    
    func houses(manager: BirthDataManager) -> ChartViewModel?
    {
        guard buttonsEnabled else {
            return nil
        }
        temporaryDisableButtons()
        if let location = manager.getSelectionLocation() {
            let row = getHouses(time: manager.getSelectionTime(), location: location, system: manager.houseSystem.getHouseCode(), calculationSettings:  manager.calculationSettings)
            let viewModel = ChartViewModel(chartName: manager.getCurrentName(), chartType: .Natal)
            viewModel.manager = manager
            if let planets = row.planets as? [HouseCell] {
                viewModel.houseData = planets
            }
            let planetsRow = getPlanets(time: manager.getSelectionTime(), location: location, calculationSettings: manager.calculationSettings)
            if let planets = planetsRow.planets as? [PlanetCell] {
                viewModel.planetData = planets
            }
            
            let aspectsRow = getAspects(time: manager.getSelectionTime(), with: nil, and: location, type: manager.orbSelection, calculationSettings: manager.calculationSettings)
            
            if let aspects = aspectsRow.planets as? [TransitCell] {
                viewModel.aspectsData = aspects
            }
            
            let displayRow = DisplayPlanetRow(planets: row.planets, id: data.wrappedValue.count, type: .Houses(system: manager.houseSystem, chartModel: viewModel), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
            data.wrappedValue.append(displayRow)
            return viewModel
        }
        return nil
        
    }
    
    func transits(manager: BirthDataManager, transitDate: Date)
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
        
        let viewModel = ChartViewModel(chartName: "\(manager.getCurrentName()) + \(dateFormater.string(from: transitDate))", chartType: .Transit)
        viewModel.manager = manager
        
        if let location = manager.getSelectionLocation() {
            let row = getHouses(time: manager.getSelectionTime(), location: location, system: manager.houseSystem.getHouseCode(), calculationSettings:  manager.calculationSettings)
            
            if let planets = row.planets as? [HouseCell] {
                viewModel.houseData = planets
            }
        }
        
        let planetsRow = getPlanets(time: manager.getSelectionTime(), location: manager.getSelectionLocation(), calculationSettings: manager.calculationSettings)
        if let planets = planetsRow.planets as? [PlanetCell] {
            viewModel.planetData = planets
        }
        
        let planetsRowTwo = getPlanets(time: transitDate.getAstroTime(), location: nil, calculationSettings: manager.calculationSettings)
        if let planets = planetsRowTwo.planets as? [PlanetCell] {
            viewModel.secondaryPlanetData = planets
        }
        
        
        if let aspects = row.planets as? [TransitCell] {
            viewModel.aspectsData = aspects
        }
        
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.wrappedValue.count, type: .Transits(date: dateFormater.string(from: transitDate), orbs: manager.transitOrbSelection.getShortName(), transitData: transitData, chartName: manager.getCurrentName(), chartModel: viewModel), name: manager.getCurrentName(), calculationSettings: manager.calculationSettings)
        data.wrappedValue.append(displayRow)
    }
}

/*
*  Copyright (C) 2022 Michael R Adams.
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
//  Created by Michael Adams on 3/18/24.

import SwiftUI

struct SynastryChooserView: View, AstrobotInterface {
    @EnvironmentObject private var manager: BirthDataManager
    @Environment(\.roomState) private var roomState
    @State var selectedNameOne: String
    @State var selectedNameTwo: String
    var body: some View {
        if manager.birthDates.isEmpty {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("Input Birth Data for two People to do Synastry.")
                    HStack() {
                        Spacer()
                        Text("Name").font(Font.headline.weight(.semibold))
                        Spacer()
                        Button(action: addName) {
                            Text("+").font(Font.title.weight(.bold))
                        }
                        Spacer()
                        
                    }
                    Spacer()
                }
                Spacer()
            }
        } else if manager.birthDates.count == 1 {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("One person's Birth Data has been entered. Enter a second to do Snyastry.")
                    HStack() {
                        Spacer()
                        Text("Name").font(Font.headline.weight(.semibold))
                        Spacer()
                        Button(action: addName) {
                            Text("+").font(Font.title.weight(.bold))
                        }
                        Spacer()
                        
                    }
                    Spacer()
                }
                Spacer()
            }
            
        } else {
            HStack {
                Spacer()
                VStack {
                    Text("Select Person One and Two for a synastry chart")
                    Picker("Person one", selection: $selectedNameOne) {
                        ForEach(manager.birthDates, id: \.self) {
                            Text($0.name).tag($0.name)
                                    }
                    }
                    Picker("Person two", selection: $selectedNameTwo) {
                        ForEach(manager.birthDates, id: \.self) {
                            Text($0.name).tag($0.name)
                                    }
                    }
                    Button(action: getChart) {
                        Text("Get Chart").font(Font.title.weight(.bold))
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        
    }
}

extension SynastryChooserView {
    func addName() {
        roomState.wrappedValue = .Names(onDismiss: .SynastryChooser)
    }
    
    func getChart() {
        guard let data1 = manager.birthDates.first(where:  { $0.name == selectedNameOne })
        else {
            return
        }
        guard let data2 = manager.birthDates.first(where:  { $0.name == selectedNameTwo })
        else {
            return
        }
        
        let viewModel = ChartViewModel(chartName: "Snastry", chartType: .Natal)
        viewModel.manager = manager
        viewModel.planetData = getPlanetData(data: data1)
        //TODO: change aspects to transit data
        viewModel.aspectsData = getAspectsData(data: data1)
        viewModel.houseData = getHouseData(data: data1)
        
        viewModel.secondaryPlanetData = getPlanetData(data: data2)
        viewModel.secondaryHouseData = getHouseData(data: data2)
    }

    func getPlanetData(data: BirthData) -> [PlanetCell] {
        let row = getPlanets(time: data.getAstroTime(), location: manager.planetsLocationData, calculationSettings: manager.calculationSettings)
        
        if let planets = row.planets as? [PlanetCell] {
            return planets
        }
        return [PlanetCell]()
    }
    
    func getAspectsData(data: BirthData) -> [TransitCell] {
        let aspectsRow = getAspects(time: data.getAstroTime(), with: nil, and: manager.planetsLocationData, type: manager.orbSelection, calculationSettings: manager.calculationSettings)
        
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

#Preview {
    SynastryChooserView(selectedNameOne: "mike", selectedNameTwo: "jane")
}

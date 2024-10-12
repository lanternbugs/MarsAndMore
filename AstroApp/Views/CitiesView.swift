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

import SwiftUI

struct CitiesView: View {
    @EnvironmentObject var manager:BirthDataManager
    @State private var city = ""
    @Environment(\.roomState) private var roomState
    var dismissView: RoomState = .Chart
    var displayCities: [City] {
        if city == "" {
            if !manager.subCityInfo.isEmpty
            {
                return manager.subCityInfo[0].cities
            }
        }
        let input = city.lowercased()
        var i = 0
        if input.starts(with: "c") || input.starts(with: "d") {
            i = 1
        } else if input.starts(with: "e") || input.starts(with: "f") {
            i = 2
        } else if input.starts(with: "g") || input.starts(with: "h") {
            i = 3
        } else if input.starts(with: "i") || input.starts(with: "j") {
            i = 4
        } else if input.starts(with: "k") || input.starts(with: "l") {
            i = 5
        } else if input.starts(with: "m") || input.starts(with: "n") {
            i = 6
        } else if input.starts(with: "o") || input.starts(with: "p") {
            i = 7
        } else if input.starts(with: "q") || input.starts(with: "r") {
            i = 8
        } else if input.starts(with: "s") || input.starts(with: "t") {
            i = 9
        } else if input.starts(with: "u") || input.starts(with: "v") {
            i = 10
        } else if input.starts(with: "w") || input.starts(with: "x") {
            i = 11
        } else if input.starts(with: "y") || input.starts(with: "z") {
            i = 12
        } else {
            i = 0
        }
        if manager.subCityInfo.count > i
        {
            let  cities = manager.subCityInfo[i].cities
            let data = cities.filter {
                if cities.isEmpty {
                    return true
                }
                return $0.city.lowercased().hasPrefix(city.lowercased())
            }
            return data
        }
        return [City]()
         
    }
    var body: some View {
        VStack(alignment: .leading) {
            // text could be in search bar with searchable but this is to work in ios 14 too
            Text("Cities & Places").font(.title.weight(.bold))
            /*
            if roomState.wrappedValue != .PlanetsCity {
                Text("Can't find it? Latitude and Longitude can be edited after a city is chosen.*")
            }
             */
            TextField("City", text: $city)
            List(displayCities, id: \.id) {
                city in
                HStack {
                    Spacer()
                    Text("\(city.city)").frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Text("\(city.country)").frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                }.gesture(TapGesture().onEnded {
                    withAnimation(.easeIn, {
                        switch(roomState.wrappedValue) {
                        case .PlanetsCity:
                            manager.planetsLocationData = LocationData(latitude: city.latitude, longitude: city.longitude)
                        default:
                            manager.builder.addCity(city)
                            manager.userLocationData = nil
                        }
                        
                        switch(roomState.wrappedValue) {
                        case .UpdateCity:
                            roomState.wrappedValue = .EditName(onDismiss: .Chart)
                        case .PlanetsCity:
                            roomState.wrappedValue = .Planets
                        default:
                            roomState.wrappedValue = .Names(onDismiss: dismissView)
                        }
                    })}
                )
            }
            /*
            if roomState.wrappedValue != .PlanetsCity {
                Text("*City may be under a local name. For example Welsh cities are under their Welsh names.")
            }
             */
        }
        
    }
}



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
struct MarsTab: View, AstrobotReadingInterface {
    @State private var birthdate = Date()
    @State private var planetChoice: Planets = Planets.Mars
    @State private var marsData: RoomState = .Entry
    @State private var venusData: RoomState = .Entry
    @State private var sunData: RoomState = .Entry
    @State private var moonData: RoomState = .Entry
    @State private var mercuryData: RoomState = .Entry
    @State private var readingInitialized = false
    @State private var roomState: RoomState = .Mars
    @ViewBuilder
    var body: some View {
        switch roomState {
        case .About:
            VStack {
                DoneView(newRoomState: .Mars).environment(\.roomState, $roomState)
                ReadingView(state: $roomState)
            }
        default:
            VStack {
                HStack {
                    
                    Button(action:  { $roomState.wrappedValue = .About }) {
                        Text("About")
                    }
                    Spacer()
                    DatePicker(
                      "Birthdate",
                      selection: $birthdate,
                      displayedComponents: .date
                    ).datePickerStyle(DefaultDatePickerStyle())
                    Button(action: pickedDate) {
                        Text("Go").font(.title)
                    }
                }
                if case .Reading(let planet, let sign) = sunData
                {
                    Text("\(planet.getName()) in \(sign.getName())").font(.headline)
                } else {
                    Text("Sun").font(.headline)
                }
                Picker(selection: $planetChoice, label: Text("Choice")) {
                    Text("Sun").tag(Planets.Sun)

                    Text("Moon").tag(Planets.Moon)
                    Text("Mercury").tag(Planets.Mercury)
                    Text("Venus").tag(Planets.Venus)

                    Text("Mars").tag(Planets.Mars)

                    

                }.pickerStyle(SegmentedPickerStyle())
                if readingInitialized {
                    switch(planetChoice) {
                    case .Sun:
                        ReadingView(state: $sunData)
                    case .Moon:
                        ReadingView(state: $moonData)
                    case .Mercury:
                        ReadingView(state: $mercuryData)
                    case .Venus:
                        ReadingView(state: $venusData)
                    case .Mars:
                        ReadingView(state: $marsData)
                    default:
                        Text("Error, there is no reading for this planet ")
                    }
                } else {
                    DefaultReadingContent()
                    
                }
                Spacer()
                
            }
        }
        
    }
}

extension MarsTab {
   private func pickedDate()  {
        marsData = getPlanet(type: .Mars, time: birthdate.getAstroTime(), calculationSettings: CalculationSettings())
        venusData = getPlanet(type: .Venus, time: birthdate.getAstroTime(), calculationSettings: CalculationSettings())
        sunData = getPlanet(type: .Sun, time: birthdate.getAstroTime(), calculationSettings: CalculationSettings())
       moonData = getPlanet(type: .Moon, time: birthdate.getAstroTime(), calculationSettings: CalculationSettings())
       mercuryData = getPlanet(type: .Mercury, time: birthdate.getAstroTime(), calculationSettings: CalculationSettings())
       readingInitialized = true
    }
}

struct MarsTab_Previews: PreviewProvider {
    static var previews: some View {
        MarsTab()
    }
}

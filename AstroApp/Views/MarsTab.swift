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
    @State private var readingInitialized = false
    
    @ViewBuilder
    var body: some View {
        
        VStack {
            HStack {
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
                Text("Mars").tag(Planets.Mars)

                Text("Venus").tag(Planets.Venus)

            }.background(Color.white).pickerStyle(SegmentedPickerStyle())
            if readingInitialized {
                switch(planetChoice) {
                case .Mars:
                    ReadingView(state: $marsData)
                case .Venus:
                    ReadingView(state: $venusData)
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

extension MarsTab {
   private func pickedDate()  {
        marsData = getPlanet(type: .Mars, time: birthdate.getAstroTime())
        venusData = getPlanet(type: .Venus, time: birthdate.getAstroTime())
        sunData = getPlanet(type: .Sun, time: birthdate.getAstroTime())
       readingInitialized = true
    }
}

struct MarsTab_Previews: PreviewProvider {
    static var previews: some View {
        MarsTab()
    }
}

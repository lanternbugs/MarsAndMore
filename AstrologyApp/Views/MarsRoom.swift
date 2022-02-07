//
//  MarsRoom.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

import SwiftUI
struct MarsRoom: View, AstrobotReadingInterface {
    
    @State private var birthdate = Date(timeIntervalSince1970: 0)
    @State var planetChoice: Planets = Planets.Mars
    @State private var marsData: ReadingState = .Entry
    @State private var venusData: ReadingState = .Entry
    @State private var sunData: ReadingState = .Entry
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

extension MarsRoom {
   private func pickedDate()  {
        marsData = getPlanet(type: .Mars, time: birthdate.getAstroTime())
        venusData = getPlanet(type: .Venus, time: birthdate.getAstroTime())
        sunData = getPlanet(type: .Sun, time: birthdate.getAstroTime())
       readingInitialized = true
    }
}

struct MarsRoom_Previews: PreviewProvider {
    static var previews: some View {
        MarsRoom()
    }
}

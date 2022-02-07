//
//  MarsRoom.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

import SwiftUI
struct MarsRoom: View, AstrobotReadingInterface {
    
    @State private var birthdate = Date(timeIntervalSince1970: 0)
    @State private var planetChoice = 0
    @State private var marsData: ReadingState = .Entry
    @State private var venusData: ReadingState = .Entry
    @State private var readingInitialized = false
    let defaultReadingMessage = "Pick a date and select go for an Evengeline Adams Mars Reading"
    
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
            Picker(selection: $planetChoice, label: Text("Choice")) {
                Text("Mars").tag(0)

                Text("Venus").tag(1)

            }.background(Color.white).pickerStyle(SegmentedPickerStyle())
            if readingInitialized {
                if planetChoice == 0 {
                    ReadingView(state: $marsData)
                } else {
                    ReadingView(state: $venusData)
                }
            } else {
                Text(defaultReadingMessage)
            }
            Spacer()
            
        }
    }
}

extension MarsRoom {
   private func pickedDate()  {
        marsData = getPlanet(type: .Mars, time: birthdate.getAstroTime())
        venusData = getPlanet(type: .Venus, time: birthdate.getAstroTime())
       readingInitialized = true
    }
}

struct MarsRoom_Previews: PreviewProvider {
    static var previews: some View {
        MarsRoom()
    }
}

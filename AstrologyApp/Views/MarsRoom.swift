//
//  MarsRoom.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

import SwiftUI

struct MarsRoom: View, AstrobotReadingInterface {
    
    @State var birthdate = Date(timeIntervalSince1970: 0)
    @State var marsData = [ReadingEntry(text: "Pick a date and select go for an Evengeline Adams Mars Reading", id: 0)]
    @State var venusData = [ReadingEntry(text: "Pick a date and select go for an Evengeline Adams Venus Reading", id: 0)]
    @State var planetChoice: Planets = .Mars
    var activeReading: [ReadingEntry] {
        switch(planetChoice) {
        case .Mars:
            return marsData
        case .Venus:
            return venusData
        default:
            return [ReadingEntry(text: "Invalid State", id: 0)]
        }
    }
    var body: some View {
        
        List {
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
            ForEach(activeReading, id: \.id) {
                paragraph in
                Text("\(paragraph.text)")
                
            }
            
        }
    }
}

extension MarsRoom {
    func pickedDate()  {
        marsData = getPlanet(type: .Mars, time: birthdate.getAstroTime()).getReading()
        venusData = getPlanet(type: .Venus, time: birthdate.getAstroTime()).getReading()
    }
}

struct MarsRoom_Previews: PreviewProvider {
    static var previews: some View {
        MarsRoom()
    }
}

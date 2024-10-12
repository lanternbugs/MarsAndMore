//
//  EditLocationDataView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 10/7/24.
//

import SwiftUI

struct EditLocationDataView: View {
    @State var latDegree = 100
    @State var latMinute = 1000
    @State var latSecond = 10000
    @State var longDegree = 200
    @State var longMinute = 2000
    @State var longSecond = 20000
    @State var latitudeDirection = "N"
    @State var longitudeDirection = "E"
    
    let viewModel = EditLocationDataViewModel()
    var body: some View {
        VStack {
            Text("Latitude")
            Picker(selection: $latitudeDirection, label: Text("Direction")) {
                ForEach(viewModel.latitudeDirection, id: \.self) { choice in
                        Text(choice)
                    }
            }
            Picker(selection: $latDegree, label: Text("Degree")) {
                ForEach(viewModel.latDegreeChoices, id: \.self.1) {
                    choice in
                    Text(String(choice.0))
                }
            }
            Picker(selection: $latMinute, label: Text("Minute")) {
                ForEach(viewModel.latMinuteChoices, id: \.self.1) {
                    choice in
                    Text(String(choice.0))
                }
            }
            Picker(selection: $latSecond, label: Text("Second")) {
                ForEach(viewModel.latSecondChoices, id: \.self.1) {
                    choice in
                    Text(String(choice.0))
                }
            }
            
            Text("Longitude")
            Picker(selection: $longitudeDirection, label: Text("Direction")) {
                ForEach(viewModel.longitudeDirection, id: \.self) { choice in
                        Text(choice)
                    }
            }
            Picker(selection: $longDegree, label: Text("Degree")) {
                ForEach(viewModel.longDegreeChoices, id: \.self.1) {
                    choice in
                    Text(String(choice.0))
                }
            }
            Picker(selection: $longMinute, label: Text("Minute")) {
                ForEach(viewModel.longMinuteChoices, id: \.self.1) {
                    choice in
                    Text(String(choice.0))
                }
            }
            Picker(selection: $longSecond, label: Text("Second")) {
                ForEach(viewModel.longSecondChoices, id: \.self.1) {
                    choice in
                    Text(String(choice.0))
                }
            }
            Spacer()
        }
        
    }
}


#Preview {
    EditLocationDataView()
}

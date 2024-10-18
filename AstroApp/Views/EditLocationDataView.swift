//
//  EditLocationDataView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 10/7/24.
//

import SwiftUI

struct EditLocationDataView: View {
    @EnvironmentObject private var manager: BirthDataManager
    @Environment(\.roomState) private var roomState
    @State var latDegree = 100
    @State var latMinute = 1000
    @State var latSecond = 10000
    @State var longDegree = 500
    @State var longMinute = 2000
    @State var longSecond = 20000
    @State var latitudeDirection = "N"
    @State var longitudeDirection = "E"
    let editingUserData: Bool
    
    let viewModel: EditLocationDataViewModel
    var body: some View {
        VStack {
            Text("Latitude")
            Picker(selection: $latitudeDirection, label: Text("Direction")) {
                ForEach(viewModel.latitudeDirections, id: \.self) { choice in
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
                ForEach(viewModel.longitudeDirections, id: \.self) { choice in
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
            Button(action: {
                submitChanges()
            }) {
                Text("Submit Changes")
            }.padding(.top)
            Spacer()
        }.onAppear() {
            viewModel.setMode(editMode: editingUserData)
            latitudeDirection = viewModel.latitudeDirection
            longitudeDirection = viewModel.longitudeDirection
            latDegree = viewModel.latitudeDegree
            longDegree = viewModel.longitudeDegree
            latMinute = viewModel.latitudeMinute
            longMinute = viewModel.longitudeMinute
            latSecond = viewModel.latitudeSecond
            longSecond = viewModel.longitudeSecond
        }
        
    }
    
    func submitChanges() {
        viewModel.submit(latDirection: latitudeDirection, latDegree: latDegree, latMinute: latMinute, latSecond: latSecond, longDirection: longitudeDirection, longDegree: longDegree, longMinute: longMinute, longSecond: longSecond)
        roomState.wrappedValue = viewModel.dismissState
    }
}


#Preview {
    EditLocationDataView(editingUserData: false, viewModel: EditLocationDataViewModel(manager: BirthDataManager()))
}

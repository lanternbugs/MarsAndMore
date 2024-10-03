/*
*  Copyright (C) 2022-2024 Michael R Adams.
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

struct SynastryChooserView: View {
    @Environment(\.roomState) private var roomState
    @EnvironmentObject private var manager: BirthDataManager
    @State var selectedNameOne: String
    @State var selectedNameTwo: String
    let viewModel: SynastryChooserViewModel
    var body: some View {
        if viewModel.manager.birthDates.isEmpty {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("Input Birth Data for two People to do Synastry or Composite Charts.")
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
        } else if viewModel.manager.birthDates.count == 1 {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("One person's Birth Data has been entered. Enter a second to do Snyastry or Composite Charts.")
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
                    Text("Select Person One and Two for a synastry or composite chart")
                    Picker("Person one", selection: $selectedNameOne) {
                        ForEach(viewModel.manager.birthDates, id: \.self) {
                            Text($0.name).tag($0.name)
                                    }
                    }
                    Picker("Person two", selection: $selectedNameTwo) {
                        ForEach(viewModel.manager.birthDates, id: \.self) {
                            Text($0.name).tag($0.name)
                                    }
                    }
                    Button(action: getSynastryChart) {
                        Text("Synastry Chart").font(Font.title)
                    }.padding(.top)
                    
                    Button(action: getCompositeChart) {
                        Text("Composite Chart").font(Font.title)
                    }.padding(.top)
                    
                    Button(action: {
                        getCompositePlusDateChart(transitDate: Date())})
                    {
                        Text("Composite + Now").font(Font.title)
                    }.padding(.top)
                    Button(action: {
                        getCompositePlusDateChart(transitDate: manager.compositeDate)})
                    {
                        Text("Composite + Date").font(Font.title)
                    }.padding(.top)
                    HStack(alignment: .top) {
                        Spacer()
                        DatePicker(
                          "Date",
                          selection: $manager.compositeDate,
                          displayedComponents: [.date, .hourAndMinute]
                        ).datePickerStyle(DefaultDatePickerStyle())
                        Spacer()
                    }
                    Spacer()
                }
                Spacer()
            }.onAppear() {
                if viewModel.manager.birthDates.first(where: { $0.name == viewModel.name1 }) != nil {
                    selectedNameOne = viewModel.name1
                }
                if viewModel.manager.birthDates.first(where: { $0.name == viewModel.name2 }) != nil {
                    selectedNameTwo = viewModel.name2
                }
            }
        }
        
    }
}

extension SynastryChooserView {
    func addName() {
        roomState.wrappedValue = .Names(onDismiss: .SynastryChooser)
    }
    
    func getSynastryChart() {
        if let vModel = viewModel.getSynastryChart(selectedNameOne: selectedNameOne, selectedNameTwo: selectedNameTwo) {
            roomState.wrappedValue = .NatalView(onDismiss: .SynastryChooser, viewModel: vModel)
        }
    }
    
    func getCompositeChart() {
        if let vModel = viewModel.getCompositeChart(selectedNameOne: selectedNameOne, selectedNameTwo: selectedNameTwo) {
            roomState.wrappedValue = .NatalView(onDismiss: .SynastryChooser, viewModel: vModel)
        }
    }
    
    func getCompositePlusDateChart(transitDate: Date) {
        if let vModel = viewModel.getCompositePlusDateChart(selectedNameOne: selectedNameOne, selectedNameTwo: selectedNameTwo, transitDate: transitDate) {
            roomState.wrappedValue = .NatalView(onDismiss: .SynastryChooser, viewModel: vModel)
        }
    }
}

#Preview {
    SynastryChooserView(selectedNameOne: "mike", selectedNameTwo: "jane", viewModel: SynastryChooserViewModel(manager: BirthDataManager()))
}

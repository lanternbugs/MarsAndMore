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
    @EnvironmentObject private var manager: BirthDataManager
    @Environment(\.roomState) private var roomState
    @State var selectedNameOne: String
    @State var selectedNameTwo: String
    let viewModel = SynastryChooserViewModel()
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
            }.onAppear() {
                if manager.birthDates.first(where: { $0.name == viewModel.name1 }) != nil {
                    selectedNameOne = viewModel.name1
                }
                if manager.birthDates.first(where: { $0.name == viewModel.name2 }) != nil {
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
    
    func getChart() {
        if let vModel = viewModel.getChart(selectedNameOne: selectedNameOne, selectedNameTwo: selectedNameTwo, manager: manager) {
            roomState.wrappedValue = .NatalView(onDismiss: .SynastryChooser, viewModel: vModel)
        }
    }
}

#Preview {
    SynastryChooserView(selectedNameOne: "mike", selectedNameTwo: "jane")
}

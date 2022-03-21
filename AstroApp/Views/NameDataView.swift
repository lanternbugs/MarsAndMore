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

struct NameDataView: View {
    @EnvironmentObject private var manager: BirthDataManager
    @Environment(\.roomState) private var roomState
    @State var birthDataError: String?
    @State private var showRemovalAlert = false
    @ViewBuilder
    var body: some View {
        VStack {
            if roomState.wrappedValue == .EditName {
                HStack {
                    Text("Edit \(manager.userNameSelection)").font(.title)
                    Spacer()
                }
            } else {
                HStack {
                    Text("Input Name:").font(.headline)
                    TextField("Name", text: $manager.userNameSelection)
                }
            }
            
            if roomState.wrappedValue == .EditName {
                if showRemovalAlert {
                    HStack {
                        Spacer()
                        Button(action: { showRemovalAlert = false }) {
                            Text("Cancel")
                        }
                        Button(action: {
                            manager.removeUserBirthData(selection: manager.selectedName)
                            manager.resetSpecificUserData()
                            manager.selectedName = nil
                            roomState.wrappedValue = .Chart
                        }) {
                            HStack {
                                Text("Remove \(manager.userNameSelection)?").foregroundColor(Color.red)
                            }
                        }
                    }
                } else {
                    HStack {
                        Button(action: {
                            showRemovalAlert = true
                        }) {
                            HStack {
                                Text("Remove \(manager.userNameSelection)")
                            }
                        }
                        Spacer()
                    }
                    
                }
                
            }
            if !manager.userExactTimeSelection {
                DatePicker(
                  "Birthdate",
                  selection: $manager.userDateSelection,
                  displayedComponents: .date
                ).datePickerStyle(DefaultDatePickerStyle())
            } else {
                DatePicker(
                  "Birthdate",
                  selection: $manager.userDateSelection,
                  displayedComponents: [.date, .hourAndMinute]
                ).datePickerStyle(DefaultDatePickerStyle())
            }
            Toggle("Exact Time", isOn: $manager.userExactTimeSelection)
            if manager.userExactTimeSelection {
                Text("Local time used. Adjust time as needed.").font(.headline)
                HStack {
                    Text("Add a birth city to calculate Acendent").font(.subheadline)
                    Button(action: {
                        switch(roomState.wrappedValue) {
                        case .EditName:
                            roomState.wrappedValue = .UpdateCity
                        default:
                            roomState.wrappedValue = .Cities
                        }
                        
                    }) {
                        Text("+City")
                    }
                }
            }
            if manager.userExactTimeSelection  {
                if let city = manager.builder.cityData {
                    HStack {
                        Text("\(city.name)").padding()
                        Spacer()
                    }
                }
            }
            if let error = birthDataError {
                HStack {
                    Text(error)
                    Spacer()
                }
            }
            
            Button(action: {
                submitBirthData()
            }) {
                Text("Submit Birth Data")
            }
            
            Spacer()
        }
    }
}

extension NameDataView {
    func submitBirthData()->Void {
        if let location = manager.userLocationData {
            manager.builder.addLocation(location)
        }
               manager.builder.addNameDate(manager.userNameSelection, birthdate: CalendarDate(birthDate: manager.userDateSelection, exactTime: manager.userExactTimeSelection))

                do {
                    let birthData = try manager.builder.build(mode: roomState.wrappedValue)
                    switch(roomState.wrappedValue) {
                    case .EditName:
                        manager.updateBirthData(data: birthData)
                    default:
                        manager.addBirthData(data: birthData)
                    }
                    manager.userNameSelection = ""
                    manager.userLocationData = nil
                    manager.selectedName = birthData.id
                    roomState.wrappedValue = .Chart
                } catch BuildErrors.NoName(let mes) {
                    birthDataError = mes
                } catch BuildErrors.DuplicateName(let mes) {
                    birthDataError = mes
                } catch BuildErrors.MissingDependency(let mes) {
                    birthDataError = mes
                } catch {
                    birthDataError = "there was an unknown error"
                }
    }
}

struct NameDataView_Previews: PreviewProvider {
    static var previews: some View {
        NameDataView()
    }
}

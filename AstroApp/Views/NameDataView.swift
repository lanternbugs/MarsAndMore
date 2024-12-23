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
import MapKit

struct NameDataView: View {
    @EnvironmentObject private var manager: BirthDataManager
    @Environment(\.roomState) private var roomState
    @State var birthDataError: String?
    @State private var showRemovalAlert = false
    var dismissView: RoomState = .Chart
    @ViewBuilder
    var body: some View {
        VStack {
            if roomState.wrappedValue == .EditName(onDismiss: .Chart) {
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
            
            if roomState.wrappedValue == .EditName(onDismiss: .Chart) {
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
                            roomState.wrappedValue = dismissView
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
                if manager.userUTCTimeSelection {
                    DatePicker(
                      "Birthdate",
                      selection: $manager.userDateSelection,
                      displayedComponents: [.date, .hourAndMinute]
                    ).datePickerStyle(DefaultDatePickerStyle())
                        .environment(\.timeZone, TimeZone(secondsFromGMT: 0)!)
                } else {
                    DatePicker(
                      "Birthdate",
                      selection: $manager.userDateSelection,
                      displayedComponents: [.date, .hourAndMinute]
                    ).datePickerStyle(DefaultDatePickerStyle())
                }
                
            }
            Toggle("Exact Time", isOn: $manager.userExactTimeSelection)
            if manager.userExactTimeSelection {
                if manager.userUTCTimeSelection {
                    Text("UTC time used.").font(.headline)
                } else {
                    Text("Local time used. Adjust time as needed.").font(.headline)
                }
                
                Toggle("UTC Time", isOn: $manager.userUTCTimeSelection)
                
                HStack {
                    if let locationData = manager.userLocationData {
                        VStack {
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text("Location set to \(locationData.latitude) latitude and \(locationData.longitude) longitude").textSelection(.enabled).font(.subheadline).padding(.top)
            }
            else {
                Text("Location set to \(locationData.latitude) latitude and \(locationData.longitude) longitude").font(.subheadline).padding(.top)
                }
#else
            if #available(iOS 15.0, *) {
                Text("Location set to \(locationData.latitude) latitude and \(locationData.longitude) longitude").textSelection(.enabled).font(.subheadline).padding(.top)
            }
            else {
                Text("Location set to \(locationData.latitude) latitude and \(locationData.longitude) longitude").font(.subheadline).padding(.top)
                }
#endif
                            Button(action: {
                                manager.builder.removeLocation()
                                manager.userLocationData = nil
                                
                            }) {
                                Text("Remove Location")
                            }.padding(.bottom)
                            HStack {
                                Text("Advanced").font(.headline).padding(.leading)
                                Button(action: {
                                    roomState.wrappedValue = .EditLocation(onDismiss: roomState.wrappedValue, editingUserData: true)
                                }) {
                                    Text("Edit Coordinates")
                                }
                            }
                            Text("Edit changes user data not global city data")
                            
                        }
                        
                    } else {
                        if let _ = manager.builder.cityData {
                            Text("Change City").font(.subheadline)
                        } else {
                            Text("Add a birth city to calculate Ascendant and Houses").font(.subheadline)
                        }
                        
                        Button(action: {
                            switch(roomState.wrappedValue) {
                            case .EditName:
                                roomState.wrappedValue = .UpdateCity
                            default:
                                roomState.wrappedValue = .Cities(onDismiss: dismissView)
                            }
                            
                        }) {
                            Text("+City")
                        }
                    }
                    
                }
            }
            if manager.userExactTimeSelection  {
                if let city = manager.builder.cityData {
                    HStack {
                        Spacer()
                        Text("\(city.city)").font(.headline).padding()
                        Text("Advanced").font(.headline).padding(.leading)
                        Button(action: {
                            roomState.wrappedValue = .EditLocation(onDismiss: roomState.wrappedValue, editingUserData: false)
                        }) {
                            Text("Edit Coordinates")
                        }
                        Spacer()
                    }
                    Text("Edit changes user data not global city data")
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
            }.padding(.top)
            
            Spacer()
        }.onAppear {
            /*
            if let city = manager.builder.cityData {
                DispatchQueue.global().async {
                    let location = CLLocation(latitude: city.latitude.getLatLongAsDouble(), longitude: city.longitude.getLatLongAsDouble())
                    let geoCoder = CLGeocoder()
                    geoCoder.reverseGeocodeLocation(location) { (placemarks, err) in
                         if let placemark = placemarks?[0] {
                            print(placemark.timeZone?.abbreviation() ?? "unknown time zone")
                         }
                    }
                }
            }
            */
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
                    roomState.wrappedValue = dismissView
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

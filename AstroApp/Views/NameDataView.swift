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
            if let data = manager.cityUtcOffset, manager.useSelectedUTCOffset {
                DatePicker(
                  "Birthdate",
                  selection: $manager.userDateSelection,
                  displayedComponents: [.date, .hourAndMinute]
                ).datePickerStyle(DefaultDatePickerStyle())
                    .environment(\.timeZone, TimeZone(secondsFromGMT: Int(data.0))!)
            }
            else if manager.userUTCTimeSelection {
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
            if let utcInfo = manager.cityUtcOffset {
                if manager.useSelectedUTCOffset {
                    if utcInfo.0 >= 0 {
                        Text("UTC offset of +\(utcInfo.1.0) used").font(Font.headline.weight(.bold))
                    } else {
                            Text("UTC offset of \(utcInfo.1.0) used").font(Font.headline.weight(.bold))
                    }
                    if let _ = manager.builder.cityData {
                        Text("offset calculated for \(utcInfo.1.1)")
                        Text("Re-pick city to update offset")
                    }
                }
                else if manager.userUTCTimeSelection {
                    Text("UTC time used.").font(.headline)
                } else {
                    Text("Your local time used. Adjust time as needed.").font(.headline)
                }
                if utcInfo.0 >= 0 {
                    Toggle("Use offset +\(utcInfo.1.0)", isOn: $manager.useSelectedUTCOffset)
                } else {
                    Toggle("Use offset \(utcInfo.1.0)", isOn: $manager.useSelectedUTCOffset)
                }
                if !manager.useSelectedUTCOffset {
                    Toggle("UTC Time", isOn: $manager.userUTCTimeSelection)
                }
                
            } else {
                if manager.userUTCTimeSelection {
                    Text("UTC time used.").font(.headline)
                } else {
                    Text("Your local time used. Adjust time as needed.").font(.headline)
                }
                
                
                Toggle("UTC Time", isOn: $manager.userUTCTimeSelection)
            }
            
            
            
            
            if let error = birthDataError {
                HStack {
                    Text(error)
                    Spacer()
                }
            }
            NameDataLocationView(dismissView: dismissView)
            Button(action: {
                submitBirthData()
            }) {
                Text("Submit Birth Data")
            }.padding(.top)
            
            Spacer()
        }.onAppear {
            if manager.builder.cityData == nil && roomState.wrappedValue == .Names(onDismiss: .Chart) {
                manager.userDateSelection = Date(timeIntervalSince1970: manager.defaultBirthInterval)
            }
            var lat: Double?
            var long: Double?
            if let locationData = manager.userLocationData {
                lat = locationData.latitude.getLatLongAsDouble()
                long = locationData.longitude.getLatLongAsDouble()
            } else if let city = manager.builder.cityData {
                lat = city.latitude.getLatLongAsDouble()
                long = city.longitude.getLatLongAsDouble()
            }
            if let latitude = lat, let longitude = long {
                DispatchQueue.global().async {
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    let geoCoder = CLGeocoder()
                    geoCoder.reverseGeocodeLocation(location) { (placemarks, err) in
                         if let placemark = placemarks?[0] {
                            //print(placemark.timeZone?.abbreviation() ?? "unknown time zone")
                             if let zone = placemark.timeZone {
                                 manager.setCityUtcOffset(zone)
                                 manager.useSelectedUTCOffset = false
                                 if let offset = manager.cityUtcOffset {
                                     //print("city utc offset is \(offset.0) and tz is \(offset.1)")
                                 }
                             }
                         }
                    }
                }
            } else {
                manager.cityUtcOffset = nil
            }
        }
    }
}

extension NameDataView {
    func submitBirthData()->Void {
        if let location = manager.userLocationData {
            manager.builder.addLocation(location)
        }
        manager.builder.addNameDate(manager.userNameSelection, birthdate: CalendarDate(birthDate: manager.userDateSelection, exactTime: true))

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

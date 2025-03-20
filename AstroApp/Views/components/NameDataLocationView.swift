//
//  NameDataLocationView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 3/20/25.
//

import SwiftUI

struct NameDataLocationView: View {
    @EnvironmentObject private var manager: BirthDataManager
    @Environment(\.roomState) private var roomState
    let dismissView: RoomState
    
    init(dismissView: RoomState) {
        self.dismissView = dismissView
    }
    var body: some View {
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
            Text("Edit changes user data not global city data").padding(.bottom)
            if let data = manager.builder.cityData, let tz = manager.cityUtcOffset {
                Text("Time Zone info for \(data.city)")
                if tz.0 >= 0 {
                    Text("Time Zone \(tz.1), Suggested GMT Offset: +\(tz.0 / 3600)")
                } else {
                    Text("Time Zone \(tz.1), Suggested GMT Offset: \(tz.0 / 3600)")
                }
            }
        }
    }
}

#Preview {
    NameDataLocationView(dismissView: .Chart)
}

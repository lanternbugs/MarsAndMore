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

struct ChartSettings: View {
    @EnvironmentObject private var manager: BirthDataManager
    @State var toggleValues = [Bool]()
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Toggle("Show Planet Reading Buttons", isOn: $manager.showPlanetReadingButtons)
                Toggle("Tropical", isOn: $manager.tropical)
                Text("Turn off for Sidereal. Sign readings intended for Tropical.")
                if !manager.tropical {
#if os(macOS)
                        Spacer()
                        Picker(selection: manager.$siderealSystem, label: Text("Sidereal System")) {
                            ForEach(SiderealSystem.allCases, id: \.rawValue) {
                                system in
                                Text(system.getName()).tag(system)
                            }
                        }.pickerStyle(RadioGroupPickerStyle())
                        
                        
#else
                    Text("Sidereal System")
                    Spacer()
                    Picker(selection: manager.$siderealSystem, label: Text("Sidereal System")) {
                        ForEach(SiderealSystem.allCases, id: \.rawValue) {
                            system in
                            Text(system.getName()).tag(system)
                        }
                    }
                        
                        
#endif
                }
                Toggle("Show Minor Aspects", isOn: $manager.showMinorAspects)
                Section {
                    HStack {
                        Spacer()
                        Text("Bodies to Show").font(.title)
                        Spacer()
                    }
                    ForEach(Planets.allCases, id: \.rawValue) {
                        planet in
                        HStack() {
                            if toggleValues.count > planet.getIndex() {
                                Toggle("Show", isOn: $toggleValues[planet.getIndex()]).onChange(of: toggleValues[planet.getIndex()]) { _ in
                                    if manager.bodiesToShow.contains(planet) {
                                        manager.bodiesToShow.remove(planet)
                                        manager.removeBodyFromPersistentStorage(body: planet)
                                    } else {
                                        manager.bodiesToShow.insert(planet)
                                        manager.addBodyToPersistentStorage(body: planet)
                                    }
                                }.namesStyle()
                                    .padding([.trailing, .leading])
                            }
                            Text("\(planet.getName())").namesStyle().padding([.trailing,.leading])
                        }
                        
                        
                    }
                }
                
            }.padding()
                .border(.gray, width: 1)
            
            Section {
                VStack {
                    HStack {
                        
#if os(macOS)
                        Spacer()
                        Picker(selection: manager.$houseSystem, label: Text("Choose House System")) {
                            ForEach(HouseSystem.allCases, id: \.rawValue) {
                                system in
                                Text(system.rawValue).tag(system)
                            }
                        }.pickerStyle(RadioGroupPickerStyle())
                        Spacer()
                        Picker(selection: manager.$orbSelection, label: Text("Choose Aspects Orbs Type")) {
                            ForEach(OrbType.allCases, id: \.rawValue) {
                                orbs in
                                Text(orbs.rawValue).tag(orbs)
                            }
                        }.pickerStyle(RadioGroupPickerStyle())
                        Spacer()
                        Picker(selection: manager.$transitOrbSelection, label: Text("Transits Orbs Type")) {
                            ForEach(OrbType.allCases, id: \.rawValue) {
                                orbs in
                                Text(orbs.rawValue).tag(orbs)
                            }
                        }.pickerStyle(RadioGroupPickerStyle())
                        Spacer()
                        
#else
                        VStack {
                            Spacer()
                            Text("Choose House System")
                            Spacer()
                            Picker(selection: manager.$houseSystem, label: Text("Choose House System")) {
                                ForEach(HouseSystem.allCases, id: \.rawValue) {
                                    system in
                                    Text(system.rawValue).tag(system)
                                }
                            }
                            
                            Text("Choose Aspects Orbs Type")
                            Spacer()
                            Picker(selection: manager.$orbSelection, label: Text("Choose Aspects Orbs Type")) {
                                ForEach(OrbType.allCases, id: \.rawValue) {
                                    orbs in
                                    Text(orbs.rawValue).tag(orbs)
                                }
                            }
                            Text("Transits Orbs Type")
                            Spacer()
                            Picker(selection: manager.$transitOrbSelection, label: Text("Transits Orbs Type")) {
                                ForEach(OrbType.allCases, id: \.rawValue) {
                                    orbs in
                                    Text(orbs.rawValue).tag(orbs)
                                }
                            }
                        }
                        
#endif
                        
                        
                        Spacer()
                    }
                    
                    
                }
                
            }.padding()
                .border(.gray, width: 1)
            
        }.onAppear {
            updateToggles()
        }
    }
}

extension ChartSettings {
    func updateToggles() {
        for val in Planets.allCases {
            if manager.bodiesToShow.contains(val) {
                toggleValues.append(true)
            } else {
                toggleValues.append(false)
            }
        }
    }
}

struct ChartSettings_Previews: PreviewProvider {
    static var previews: some View {
        ChartSettings()
    }
}

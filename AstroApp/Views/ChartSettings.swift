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
    @Environment(\.roomState) private var roomState
    @State var toggleValues = [Bool]()
    @State var aspectsToggleValues = [Bool]()
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
#if os(macOS)
                Button(action:  { roomState.wrappedValue = .About }) {
                    Text("About App")
                }
#elseif os(iOS)
                Button(action:  { roomState.wrappedValue = .About }) {
                    Text("About App")
                }.padding(.top)

#endif
                //Toggle("Show Planet Reading Buttons", isOn: $manager.showPlanetReadingButtons)
                Toggle("Tropical", isOn: $manager.tropical)
                Text("Turn off for Sidereal options")
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
                if !manager.showMinorAspects {
                    HStack {
                        Text("More Options when Enabled")
                        Spacer()
                    }
                } else
                {
                    Toggle("Show in Transit Times", isOn: $manager.showMinorAspectTransitTimes).padding(.leading)
                    HStack {
                        Text("Aspects to Show")
                        Spacer()
                    }
                    ForEach(Aspects.allCases, id: \.rawValue) {
                        aspect in
                        if !aspect.isMajor() {
                            HStack() {
                                if aspectsToggleValues.count > aspect.getIndex() {
                                    Toggle("Show", isOn: $aspectsToggleValues[aspect.getIndex()]).onChange(of: aspectsToggleValues[aspect.getIndex()]) { _ in
                                        if manager.aspectsToShow.contains(aspect) {
                                            manager.aspectsToShow.remove(aspect)
                                            manager.removeAspectFromPersistentStorage(aspect: aspect)
                                        } else {
                                            manager.aspectsToShow.insert(aspect)
                                            manager.addAspectToPersistentStorage(aspect: aspect)
                                        }
                                    }.namesStyle()
                                        .padding([.trailing, .leading])
                                }
                                Text("\(aspect.getName()) \(Int(aspect.rawValue))").namesStyle().padding([.trailing, .leading])
                            }
                        }
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Text("Things to Show").font(.title)
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
                            Text("\(planet.getLongName())").namesStyle().padding([.trailing,.leading])
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
                        Picker(selection: manager.$orbSelection, label: Text("Choose Aspects Orbs")) {
                            ForEach(OrbType.allCases, id: \.rawValue) {
                                orbs in
                                Text(orbs.rawValue).tag(orbs)
                            }
                        }.pickerStyle(RadioGroupPickerStyle())
                        Spacer()
                        Picker(selection: manager.$transitOrbSelection, label: Text("Transits Orbs")) {
                            ForEach(OrbType.allCases, id: \.rawValue) {
                                orbs in
                                Text(orbs.rawValue).tag(orbs)
                            }
                        }.pickerStyle(RadioGroupPickerStyle())
                        Spacer()
                        Picker(selection: manager.$synastryOrbSelection, label: Text("Synastry Orbs")) {
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
                            Picker(selection: manager.$orbSelection, label: Text("Choose Aspects Orbs")) {
                                ForEach(OrbType.allCases, id: \.rawValue) {
                                    orbs in
                                    Text(orbs.rawValue).tag(orbs)
                                }
                            }
                            Text("Transits Orbs")
                            Spacer()
                            Picker(selection: manager.$transitOrbSelection, label: Text("Transits Orbs Type")) {
                                ForEach(OrbType.allCases, id: \.rawValue) {
                                    orbs in
                                    Text(orbs.rawValue).tag(orbs)
                                }
                            }
                            Text("Synastry Orbs")
                            Spacer()
                            Picker(selection: manager.$synastryOrbSelection, label: Text("Synastry Orbs")) {
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
            updateAspectsToggles()
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
    
    func updateAspectsToggles() {
        for val in Aspects.allCases {
            if manager.aspectsToShow.contains(val) {
                aspectsToggleValues.append(true)
            } else {
                aspectsToggleValues.append(false)
            }
        }
    }
}

struct ChartSettings_Previews: PreviewProvider {
    static var previews: some View {
        ChartSettings()
    }
}

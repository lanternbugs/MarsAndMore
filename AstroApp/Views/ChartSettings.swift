//
//  ChartSettings.swift
//  MarsAndMore
//
//  Created by Michael Adams on 3/3/22.
//

import SwiftUI

struct ChartSettings: View {
    @EnvironmentObject private var manager: BirthDataManager
    @State var toggleValues = [Bool]()
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
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

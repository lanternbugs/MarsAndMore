//
//  WheelChartPlanetListing.swift
//  MarsAndMore
//
//  Created by Michael Adams on 4/10/24.
//

import SwiftUI

struct WheelChartPlanetListing: View {
    let planetData: [PlanetCell]
    let houseData: [HouseCell]
    let chartTitle: String
    @EnvironmentObject var manager:BirthDataManager
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(chartTitle).font(.title2)
                Spacer()
            }
            ForEach(planetData.sorted(by: { if $0.planet == .MC && $1.planet == .Ascendent {
                return false
            } else if $0.planet == .Ascendent && $1.planet == .MC {
                return true
            }
               return $0.planet.rawValue < $1.planet.rawValue }), id: \.id) {
                data in
                HStack {
                    if manager.bodiesToShow.contains(data.planet) {
                        if data.planet != .MC && data.planet != .Ascendent {
                            Text(getPlanetRow(data))
                            Spacer()
                        }
                        
                    }
                    
                }
            }
        }
    }
}

extension WheelChartPlanetListing {
    func getPlanetRow(_ data: PlanetCell) -> String {
        var text =  data.planet.getName().uppercased() + " " + data.sign.getName() + " " + data.degree
        if data.retrograde {
            text = text + " " + "R"
        }
        return text
    }
    
    
}

#Preview {
    WheelChartPlanetListing(planetData: [PlanetCell](), houseData: [HouseCell](), chartTitle: "none")
}

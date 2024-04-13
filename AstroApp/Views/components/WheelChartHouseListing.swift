//
//  WheelChartHouseListing.swift
//  MarsAndMore
//
//  Created by Michael Adams on 4/13/24.
//

import SwiftUI

struct WheelChartHouseListing: View {
    let houseData: [HouseCell]
    let planetData: [PlanetCell]
    let chartTitle: String
    var body: some View {
        VStack {
            if !chartTitle.isEmpty {
                HStack {
                    Spacer()
                    Text(chartTitle).font(.title2)
                    Spacer()
                }
            }
            if let asc = planetData.first(where: { $0.planet == .Ascendent }) {
                if asc.numericDegree != houseData[0].numericDegree {
                    HStack {
                        Text("Asc " + asc.degree + " " + asc.sign.getName())
                        Spacer()
                    }
                }
            }
            if let mc = planetData.first(where: { $0.planet == .MC }) {
                if mc.numericDegree != houseData[9].numericDegree {
                    HStack {
                        Text("MC  " + mc.degree + " " + mc.sign.getName())
                        Spacer()
                    }
                }  
            }
            ForEach(houseData, id: \.id) {
                data in
                HStack {
                    Text(getHouseRow(data))
                    Spacer()
                    
                        
                    
                    
                }
            }
        }
    }
}

extension WheelChartHouseListing {
    func getHouseRow(_ data: HouseCell) -> String {
        if let asc = planetData.first(where: { $0.planet == .Ascendent }) {
            if asc.numericDegree != houseData[0].numericDegree {
                return data.house.getHouseNumericName() + "  " + data.degree + " " + data.sign.getName()
                
            }
        }
        if let asc = planetData.first(where: { $0.planet == .MC }) {
            if asc.numericDegree != houseData[9].numericDegree {
                if data.house.getHouseShortName() == houseData[0].house.getHouseShortName() {
                    return data.house.getHouseShortName() + " " + data.degree + " " + data.sign.getName()
                }
                return data.house.getHouseNumericName() + "  " + data.degree + " " + data.sign.getName()
                
            }
        }
        if data.house.getHouseShortName().count == 3 {
            return data.house.getHouseShortName() + " " + data.degree + " " + data.sign.getName()
        } else {
            return data.house.getHouseShortName() + "  " + data.degree + " " + data.sign.getName()
        }
        
    }
}

#Preview {
    WheelChartHouseListing(houseData: [HouseCell](), planetData: [PlanetCell](), chartTitle: "chart")
}

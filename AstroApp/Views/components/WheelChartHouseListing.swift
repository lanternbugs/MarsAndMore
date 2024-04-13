//
//  WheelChartHouseListing.swift
//  MarsAndMore
//
//  Created by Michael Adams on 4/13/24.
//

import SwiftUI

struct WheelChartHouseListing: View {
    var houseData: [HouseCell]
    var chartTitle: String
    var body: some View {
        VStack {
            if !chartTitle.isEmpty {
                HStack {
                    Spacer()
                    Text(chartTitle).font(.title2)
                    Spacer()
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
        if data.house.getHouseShortName().count == 3 {
            return data.house.getHouseShortName() + " " + data.degree + " " + data.sign.getName()
        } else {
            return data.house.getHouseShortName() + "  " + data.degree + " " + data.sign.getName()
        }
        
    }
}

#Preview {
    WheelChartHouseListing(houseData: [HouseCell](), chartTitle: "chart")
}

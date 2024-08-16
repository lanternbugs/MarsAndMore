/*
*  Copyright (C) 2022-24 Michael R Adams.
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
//  Created by Michael Adams on 4/13/24.
//

import SwiftUI

struct WheelChartHouseListing: View {
    let viewModel: WheelChartDataViewModel
    var body: some View {
        VStack {
            if !viewModel.chartTitle.isEmpty {
                HStack {
                    Spacer()
                    Text(viewModel.chartTitle).font(.title2)
                    Spacer()
                }
            }
            if let asc = viewModel.planetData.first(where: { $0.planet == .Ascendant }) {
                if asc.numericDegree != viewModel.houseData[0].numericDegree {
                    HStack {
                        Text("Asc " + asc.degree + " " + asc.sign.getName())
                        Spacer()
                    }
                }
            }
            if let mc = viewModel.planetData.first(where: { $0.planet == .MC }) {
                if mc.numericDegree != viewModel.houseData[9].numericDegree {
                    HStack {
                        Text("MC  " + mc.degree + " " + mc.sign.getName())
                        Spacer()
                    }
                }  
            }
            ForEach(viewModel.houseData, id: \.id) {
                data in
                HStack {
                    Text(viewModel.getHouseRow(data))
                    Spacer()
                    
                        
                    
                    
                }
            }
        }
    }
}

#Preview {
    WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: [PlanetCell](), aspects: [TransitCell](), houses: [HouseCell](), chart: .Natal, title: "chart", houseSystem: HouseSystem.Whole))
}

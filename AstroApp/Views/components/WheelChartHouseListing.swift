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
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text("Asc " + asc.degree + " " + asc.sign.getName()).textSelection(.enabled).padding(.leading)
            }
            else {
                Text("Asc " + asc.degree + " " + asc.sign.getName()).padding(.leading)
                }
#else
            if #available(iOS 15.0, *) {
                Text("Asc " + asc.degree + " " + asc.sign.getName()).textSelection(.enabled).padding(.leading)
            }
            else {
                Text("Asc " + asc.degree + " " + asc.sign.getName()).padding(.leading)
                }
#endif
                        Spacer()
                    }
                }
            }
            if let mc = viewModel.planetData.first(where: { $0.planet == .MC }) {
                if mc.numericDegree != viewModel.houseData[9].numericDegree {
                    HStack {
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text("MC  " + mc.degree + " " + mc.sign.getName()).textSelection(.enabled).padding(.leading)
            }
            else {
                Text("MC  " + mc.degree + " " + mc.sign.getName()).padding(.leading)
                }
#else
            if #available(iOS 15.0, *) {
                Text("MC  " + mc.degree + " " + mc.sign.getName()).textSelection(.enabled).padding(.leading)
            }
            else {
                Text("MC  " + mc.degree + " " + mc.sign.getName()).padding(.leading)
                }
#endif
                        Spacer()
                    }
                }  
            }
            ForEach(viewModel.houseData, id: \.id) {
                data in
                HStack {
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text(viewModel.getHouseRow(data)).textSelection(.enabled).padding(.leading)
            }
            else {
                Text(viewModel.getHouseRow(data)).padding(.leading)
                }
#else
            if #available(iOS 15.0, *) {
                Text(viewModel.getHouseRow(data)).textSelection(.enabled).padding(.leading)
            }
            else {
                Text(viewModel.getHouseRow(data)).padding(.leading)
                }
#endif
                    Spacer()
                    
                        
                    
                    
                }
            }
            if let vertex = viewModel.planetData.first(where: { $0.planet == .Vertex }) {
                if vertex.numericDegree != viewModel.houseData[0].numericDegree {
                    HStack {
#if os(macOS)
            if #available(macOS 12.0, *) {
                Text("\(vertex.planet.getLongName()) " + vertex.degree + " " + vertex.sign.getName()).textSelection(.enabled).padding(.leading)
            }
            else {
                Text("\(vertex.planet.getLongName()) " + vertex.degree + " " + vertex.sign.getName()).padding(.leading)
                }
#else
            if #available(iOS 15.0, *) {
                Text("\(vertex.planet.getLongName()) " + vertex.degree + " " + vertex.sign.getName()).textSelection(.enabled).padding(.leading)
            }
            else {
                Text("\(vertex.planet.getLongName()) " + vertex.degree + " " + vertex.sign.getName()).padding(.leading)
                }
#endif
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    WheelChartHouseListing(viewModel: WheelChartDataViewModel(planets: [PlanetCell](), aspects: [TransitCell](), houses: [HouseCell](), chart: .Natal, title: "chart", houseSystem: HouseSystem.Whole))
}

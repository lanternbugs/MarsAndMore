//
//  EphemerisView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/3/24.
//

import SwiftUI

struct EphemerisView: View {
    @ObservedObject var viewModel: EphemerisViewModel
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Text("Ephemeris")
                }
                ScrollView(.horizontal) {
                    ForEach($viewModel.planetCells , id:\.id)
                    { $planetRow in
                        HStack {
                            Text(viewModel.getPlanetRow(planets: planetRow)).lineLimit(1)
                            Spacer()
                        }
                        
                    }
                }
                
            }
        }
    }
}

#Preview {
    EphemerisView(viewModel: EphemerisViewModel(date :Date(), calculationSettings: CalculationSettings()))
}

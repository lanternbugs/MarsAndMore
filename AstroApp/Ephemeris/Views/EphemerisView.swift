//
//  EphemerisView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/3/24.
//

import SwiftUI

struct EphemerisView: View {
    @ObservedObject var viewModel: EphemerisViewModel
    let rows: [GridItem] =
                 Array(repeating: .init(.flexible()), count: 1)
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                HStack {
                    Button(action: { viewModel.previousMonth() }) {
                        Text("Prev Month").font(Font.subheadline).padding(.leading)
                    }
                    Spacer()
                    Text(viewModel.date.getMonthYearDisplayDate())
                    Spacer()
                    Button(action: { viewModel.nextMonth() }) {
                        Text("Next Month").font(Font.subheadline).padding(.trailing)
                    }
                }
                ScrollView(.horizontal) {
                    VStack (alignment: .leading) {
                        ForEach($viewModel.planetCells , id:\.id)
                        { $planetRow in
                            let count = viewModel.getPlanetsArray(planets: planetRow).count
                            LazyHGrid(rows: rows) {
                                ForEach(0 ..< count, id: \.self) { i in
                                    HStack {
                                        Text(viewModel.getPlanetString(cell: viewModel.getPlanetsArray(planets: planetRow)[i]))
                                    }
                                }
                            }
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

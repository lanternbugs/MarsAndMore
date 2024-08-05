//
//  EphemerisView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 8/3/24.
//

import SwiftUI

struct EphemerisView: View {
    let viewModel: EphemerisViewModel
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Text("Ephemeris")
                }
            }
        }
    }
}

#Preview {
    EphemerisView(viewModel: EphemerisViewModel(date :Date(), calculationSettings: CalculationSettings()))
}

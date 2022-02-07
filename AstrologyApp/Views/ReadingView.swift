//
//  ReadingView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/3/22.
//

import SwiftUI

struct ReadingView: View {
    @Binding var state: ReadingState
    @ViewBuilder
    var body: some View {
        let reading = state.getReading()
        ScrollView() {
            VStack {
                if case .Reading(let planet, let sign) = state
                {
                    Text("\(planet.getName()) in \(sign.getName())").padding()
                }
                
                ForEach(reading, id: \.id) { entry in
                    Text("\(entry.text)")
                }
                ReadingCreditsView()
            }
        }.padding(.vertical)
    }
}

struct ReadingView_Previews: PreviewProvider {
    @State static var reading = ReadingState.Chart
    static var previews: some View {
        ReadingView(state: $reading)
    }
}

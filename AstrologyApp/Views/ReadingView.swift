//
//  ReadingView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/3/22.
//

import SwiftUI

struct ReadingView: View {
    @Binding var state: ReadingState
    var body: some View {
        let reading = state.getReading()
        ScrollView() {
            VStack {
                ForEach(reading, id: \.id) { entry in
                    Text("\(entry.text)")
                }
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

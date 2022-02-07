//
//  ChartRoom.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

import SwiftUI

struct ChartRoom: View {
    @State var readingState: ReadingState = .Chart
    @State var planetData: [DisplayPlanetRow] = Array<DisplayPlanetRow>()
    @ViewBuilder
    var body: some View {
        switch(readingState) {
        case .Reading:
            VStack {
                Button(action: {
                    readingState = .Chart
                }) {
                    Text("Done").font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ReadingView(state: $readingState)
            }
            
        default:
            HStack {
                ChartView(data: $planetData, state: $readingState)
                Divider()
                       .padding([.leading, .trailing], 3)
                NamesView()
            }.background(Image("night-sky", bundle: nil)
                            .resizable()
                            .aspectRatio(1 / 1, contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)
                            .saturation(0.5)
                            .opacity(0.2))
        }
    }
}

struct ChartRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChartRoom()
    }
}

//
//  ChartRoom.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

import SwiftUI

struct ChartRoom: View {
    @State var readingState: ReadingState = .Chart
    @State var planetData: [PlanetRow] = Array<PlanetRow>()
    @ViewBuilder
    var body: some View {
        switch(readingState) {
        case .Reading:
            ReadingView(state: $readingState)
        default:
            HStack {
                ChartView(data: $planetData, state: $readingState)
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Name").font(Font.headline.weight(.semibold))
                            Spacer()
                            Button(action: addName) {
                                Text("+").font(Font.title.weight(.bold))
                            }
                            Spacer()
                            
                        }
                        VStack() {
                            Text("Now").padding(0).lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            
                        }
                    }
#if os(iOS)
                    .frame(width: UIScreen.main.bounds.size.width / 3.7)
#elseif os(macOS)
        
#endif
                       
                    
                }
            }
        }
    }
    
    func addName() {
        
    }
}

struct ChartRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChartRoom()
    }
}

//
//  DoneView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/7/22.
//

import SwiftUI

struct DoneView: View {
    @Binding var readingState: RoomState
    let newReadingState: RoomState
    var body: some View {
        Button(action: {
            readingState = newReadingState
        }) {
            HStack(alignment: .center) {
                Text("<\(newReadingState.getName())")
                    .font(.title2)
                    .frame(minWidth: 20, alignment: .bottom).padding(0)
                Spacer()
            }.padding(.vertical)
            
        }
    }
}

struct DoneView_Previews: PreviewProvider {
    @State static var readingState:RoomState = .Chart
    static var previews: some View {
        DoneView(readingState: $readingState, newReadingState: .Chart)
    }
}

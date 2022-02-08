//
//  NameDataView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/7/22.
//

import SwiftUI

struct NameDataView: View {
    @Binding var state: RoomState
    var body: some View {
        Button(action: {
            state = .Cities
        }) {
            Text("Cities").font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct NameDataView_Previews: PreviewProvider {
    @State static var state: RoomState = .Cities
    static var previews: some View {
        NameDataView(state: $state)
    }
}

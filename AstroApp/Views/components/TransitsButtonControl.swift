//
//  TransitsButtonControl.swift
//  MarsAndMore
//
//  Created by Michael Adams on 3/2/22.
//

import SwiftUI

struct TransitsButtonControl: View, AstrobotInterface {
    @EnvironmentObject private var manager: BirthDataManager
    var body: some View {
        HStack {
            Spacer()
            Button(action: transits) {
                Text("Transits")
            }
            Spacer()
        }
    }
}

extension TransitsButtonControl {
    func transits()
    {
    }
}

struct TransitsButtonControl_Previews: PreviewProvider {
    static var previews: some View {
        TransitsButtonControl()
    }
}

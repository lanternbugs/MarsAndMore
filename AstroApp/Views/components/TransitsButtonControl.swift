//
//  TransitsButtonControl.swift
//  MarsAndMore
//
//  Created by Michael Adams on 3/2/22.
//

import SwiftUI

struct TransitsButtonControl: View, AstrobotInterface {
    
    @EnvironmentObject private var manager: BirthDataManager
    @State private var birthdate: Date = Date(timeIntervalSince1970: 0)
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: transits) {
                    Text("Transits")
                }
                Spacer()
                if let name = manager.getCurrentName() {
                    Text("\(name)")
                    Spacer()
                }
            }
            DatePicker(
              "On",
              selection: $birthdate,
              displayedComponents: [.date, .hourAndMinute]
            ).datePickerStyle(DefaultDatePickerStyle())
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

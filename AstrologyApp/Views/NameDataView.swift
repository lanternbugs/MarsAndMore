/*
*  Copyright (C) 2022 Michael R Adams.
*  All rights reserved.
*
* This program can be redistributed and/or modified under
* the terms of the GNU General Public License; either
* version 2 of the License, or (at your option) any later version.
*
*  This code is distributed in the hope that it will
*  be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/

import SwiftUI

struct NameDataView: View {
    @Binding var state: RoomState
    @State var name = ""
    @State var exactTime = false
    @State private var birthdate = Date(timeIntervalSince1970: 0)
    @ViewBuilder
    var body: some View {
        VStack {
            HStack {
                Text("Input Name:").font(.headline)
                TextField("Name", text: $name)
            }
            if !exactTime {
                DatePicker(
                  "Birthdate",
                  selection: $birthdate,
                  displayedComponents: .date
                ).datePickerStyle(DefaultDatePickerStyle())
            } else {
                DatePicker(
                  "Birthdate",
                  selection: $birthdate,
                  displayedComponents: [.date, .hourAndMinute]
                ).datePickerStyle(DefaultDatePickerStyle())
            }
            Toggle("Exact Time", isOn: $exactTime)
            if exactTime {
                Text("Local time used. Adjust time as needed.").font(.headline)
                HStack {
                    Text("Add a birth city to calculate Acendent").font(.subheadline)
                    Button(action: {
                        state = .Cities
                    }) {
                        Text("+City")
                    }
                }
            }
            Spacer()
        }
    }
}

struct NameDataView_Previews: PreviewProvider {
    @State static var state: RoomState = .Cities
    static var previews: some View {
        NameDataView(state: $state)
    }
}

//
//  TransitsButtonControl.swift
//  MarsAndMore
//
//  Created by Michael Adams on 3/2/22.
//

import SwiftUI

struct TransitsButtonControl: View, AstrobotInterface {
    
    @EnvironmentObject private var manager: BirthDataManager
    @State private var transitDate: Date = Date()
    @Binding var data: [DisplayPlanetRow]
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
              selection: $transitDate,
              displayedComponents: [.date, .hourAndMinute]
            ).datePickerStyle(DefaultDatePickerStyle())
        }
        
    }
}

extension TransitsButtonControl {
    func transits()
    {
        let row = getAspects(time: manager.getSelectionTime(), with: transitDate.getAstroTime())
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YY/MM/dd h:m"
        let displayRow = DisplayPlanetRow(planets: row.planets, id: data.count, type: .Transits(date: dateFormater.string(from: transitDate)), name: manager.getCurrentName())
        data.append(displayRow)
    }
}

struct TransitsButtonControl_Previews: PreviewProvider {
    @State static var row = [DisplayPlanetRow(planets: [], id: 0, type: PlanetFetchType.Planets, name: "Mike")]
    static var previews: some View {
        TransitsButtonControl(data: $row)
    }
}

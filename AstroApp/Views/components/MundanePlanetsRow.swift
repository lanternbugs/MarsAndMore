//
//  MundanePlanetsRow.swift
//  MarsAndMore
//
//  Created by Michael Adams on 11/19/23.
//

import SwiftUI

struct MundanePlanetsRow: View, AstrobotInterface {
    @Environment(\.roomState) private var roomState
    @EnvironmentObject private var savedDate: PlanetsDate
    var body: some View {
        HStack(alignment: .top) {
            Spacer()
            Button(action: mundane) {
                Text("Mundane")
            }
            Spacer()
        }
    }
}

extension MundanePlanetsRow {
    func mundane() {
        var start = savedDate.planetsDateChoice
        let calendar = Calendar.current
        start = calendar.startOfDay(for: start)
        let end = calendar.date(byAdding: .day, value: 1, to: start)
        if let end = end {
            roomState.wrappedValue = .Mundane(transits: getTransitTimes(start_time: start.getAstroTime(), end_time: end.getAstroTime()), date: start)
        }
    }
}

struct MundanePlanetsRow_Previews: PreviewProvider {
    static var previews: some View {
        MundanePlanetsRow()
    }
}
 
 /*
#Preview {
 MundanePlanetsRow()
 }
  */
 

/*
*  Copyright (C) 2022-23 Michael R Adams.
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
//  Created by Michael Adams on 11/21/23.
//

import SwiftUI

struct TransitTimesView: View {
    @Binding var transits: [TransitTime]
    let viewModel: TransitTimesViewModel
    var body: some View {
        VStack {
            ForEach(transits.sorted(), id: \.time) {
                transit in
                HStack {
                    printTransit(transit)
                }
            }
        }
    }
}
extension TransitTimesView {
    @ViewBuilder
    func printTransit(_ transit: TransitTime) -> some View {
        if viewModel.shouldShowTransit(transit) {
            let displayTime = viewModel.getDisplayTime(transit: transit)
            
                if let sign = transit.sign {
#if os(macOS)

    if #available(macOS 12.0, *) {
        Text("\(transit.planet.getName()) Enters \(sign.getName()) \(displayTime)").textSelection(.enabled)

    } else {
        Text("\(transit.planet.getName()) Enters \(sign.getName()) \(displayTime)")
    }

#else

    if #available(iOS 15.0, *) {
        Text("\(transit.planet.getName()) Enters \(sign.getName()) \(displayTime)").textSelection(.enabled)
    } else {
        Text("\(transit.planet.getName()) Enters \(sign.getName()) \(displayTime)")
    }

#endif
                } else {
#if os(macOS)

    if #available(macOS 12.0, *) {
        Text("\(transit.planet.getName()) \(transit.aspect.getName()) \(transit.planet2.getName()) \(displayTime)").textSelection(.enabled)

    } else {
        Text("\(transit.planet.getName()) \(transit.aspect.getName()) \(transit.planet2.getName()) \(displayTime)")
    }

#else

    if #available(iOS 15.0, *) {
        Text("\(transit.planet.getName()) \(transit.aspect.getName()) \(transit.planet2.getName()) \(displayTime)").textSelection(.enabled)
    } else {
        Text("\(transit.planet.getName()) \(transit.aspect.getName()) \(transit.planet2.getName()) \(displayTime)")
    }

#endif
                }

                Spacer()
            }
        }
}
extension TransitTimesView {
    
    
}

struct TransitTimesView_Previews: PreviewProvider {
    @State static var row: [TransitTime] = []
    static var previews: some View {
        TransitTimesView(transits: $row, viewModel: TransitTimesViewModel(transitToShow: TransitsToShow.All))
    }
}

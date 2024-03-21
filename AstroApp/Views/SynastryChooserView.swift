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
//  Created by Michael Adams on 3/18/24.

import SwiftUI

struct SynastryChooserView: View {
    @EnvironmentObject private var manager: BirthDataManager
    @Environment(\.roomState) private var roomState
    var body: some View {
        if manager.birthDates.isEmpty {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("Input Birth Data for two People to do Synastry.")
                    HStack() {
                        Spacer()
                        Text("Name").font(Font.headline.weight(.semibold))
                        Spacer()
                        Button(action: addName) {
                            Text("+").font(Font.title.weight(.bold))
                        }
                        Spacer()
                        
                    }
                    Spacer()
                }
                Spacer()
            }
        } else if manager.birthDates.count == 1 {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("One person's Birth Data has been entered. Enter a second to do Snyastry.")
                    HStack() {
                        Spacer()
                        Text("Name").font(Font.headline.weight(.semibold))
                        Spacer()
                        Button(action: addName) {
                            Text("+").font(Font.title.weight(.bold))
                        }
                        Spacer()
                        
                    }
                    Spacer()
                }
                Spacer()
            }
            
        } else {
            Text("Lets go")
        }
        
    }
}

extension SynastryChooserView {
    func addName() {
        // need .Names to have a back value
        roomState.wrappedValue = .Names(onDismiss: .SynastryChooser)
    }
}

#Preview {
    SynastryChooserView()
}

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

struct NamesView: View {
    @Binding var state: RoomState
    var body: some View {
        
            VStack {
                HStack() {
                    Spacer()
                    Text("Name").font(Font.headline.weight(.semibold))
                    Spacer()
                    Button(action: addName) {
                        Text("+").font(Font.title.weight(.bold))
                    }
                    Spacer()
                    
                }
                Divider()
                       .padding([.top, .bottom], 3)
                ScrollView {
                VStack() {
                    Text("Time Now").padding(0).lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                }
            }

            
            
        }.padding(.vertical)
#if os(iOS)
            .frame(width: UIScreen.main.bounds.size.width / 3.7)
#elseif os(macOS)
            
#endif
        
    }
    
    func addName() {
        state = .Names
    }
}

struct NamesView_Previews: PreviewProvider {
    @State static var state: RoomState = .Chart
    static var previews: some View {
        NamesView(state: $state)
    }
}

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
    @EnvironmentObject var manager: BirthDataManager
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
                    if manager.selectedName == nil{
                        Text("Time Now").padding(0).lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color.black)
                            .background(Color.green)
                    } else {
                        Text("Time Now").padding(0).lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    ForEach(manager.birthDates, id: \.id) {
                        nameDateInfo in
                        if manager.selectedName == nameDateInfo.id {
                            Text(nameDateInfo.name).foregroundColor(Color.black)
                                .background(Color.green)
                                .gesture(TapGesture().onEnded({
                                tappedName(with: nameDateInfo.id)
                            }))
                        } else {
                            Text(nameDateInfo.name).gesture(TapGesture().onEnded({
                                tappedName(with: nameDateInfo.id)
                            }))
                        }
                        
                    }
                    
                    
                }
            }

            
            
        }.padding(.vertical)
#if os(iOS)
            .frame(width: UIScreen.main.bounds.size.width / 3.7)
#elseif os(macOS)
            
#endif
        
    }
    
}

extension NamesView {
    func tappedName(with id: Int)->Void {
        if let currentSelection = manager.selectedName  {
            manager.selectedName = currentSelection == id ? nil : id
        } else {
            manager.selectedName = id

        }
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

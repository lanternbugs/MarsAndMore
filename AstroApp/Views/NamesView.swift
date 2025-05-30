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
    @Environment(\.roomState) private var roomState
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
                Button(action: { roomState.wrappedValue = .ChartSettings }) {
                    Text("Chart Settings").font(Font.subheadline)
                }
                Divider()
                Button(action: { roomState.wrappedValue = .SynastryChooser }) {
                    Text("Partner").font(Font.headline)
                }
                
                Divider()
                       .padding([.top, .bottom], 3)
                Button(action: { roomState.wrappedValue = .Resources }) {
                    Text("Resources").font(Font.subheadline)
                }
                ScrollView {
                VStack() {
                    if manager.selectedName == nil{
                        Text("Time Now").padding([.trailing, .leading]).lineLimit(1)
                            .selectedNameColor()
                            .padding(.bottom)
                    } else {
                        Text("Time Now").padding(.bottom).lineLimit(1)
                            .gesture(TapGesture().onEnded({
                                manager.selectedName = nil
                        }))
                    }
                    ScrollView {
                        ForEach(manager.birthDates, id: \.id) {
                            nameDateInfo in
                            if manager.selectedName == nameDateInfo.id {
                                SelectedNameView()
                            } else {
                                Text(nameDateInfo.name).namesStyle().gesture(TapGesture().onEnded({
                                    tappedName(with: nameDateInfo.id)
                                }))
                            }
                        }
                    }
                }
            }

            
            
        }.padding(.vertical)
#if os(iOS)
            .frame(width: getScreenWidth() / 3.7)
#elseif os(macOS)
            .frame(width: getScreenWidth() / 9)
#endif
        
    }
    
}

extension NamesView {
    func getScreenWidth()->Double
    {
#if os(macOS)
        guard let mainScreen = NSScreen.main else {
            return 200.0
        }
        return mainScreen.visibleFrame.size.width
#elseif os(iOS)
    return UIScreen.main.bounds.size.width
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
        manager.userDateSelection = Date(timeIntervalSince1970: manager.defaultBirthInterval)
        roomState.wrappedValue = .Names(onDismiss: .Chart)
    }
}


struct NamesView_Previews: PreviewProvider {
    static var previews: some View {
        NamesView()
    }
}

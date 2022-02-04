//
//  NamesView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/4/22.
//

import SwiftUI

struct NamesView: View {
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
        
    }
}

struct NamesView_Previews: PreviewProvider {
    static var previews: some View {
        NamesView()
    }
}

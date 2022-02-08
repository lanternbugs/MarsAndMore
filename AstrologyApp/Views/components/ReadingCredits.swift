//
//  ReadingCreditsView.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/6/22.
//

import SwiftUI

struct ReadingCreditsView: View {
    var body: some View {
        VStack {
            Text("- Evangeline Adams").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color.white)
            Text("with ghost writer Aleister Crowley").frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(Color.white)
            Text("Your Place in the Stars 1933").foregroundColor(Color.white)
            Button(action: openWikipediaLink) {
                Text("https://en.wikipedia.org/wiki/Evangeline_Adams").padding()
            }
        }.background(Color.black).padding()
    }
}

extension ReadingCreditsView {
    func openWikipediaLink()->Void {
        if let url = URL(string: "https://en.wikipedia.org/wiki/Evangeline_Adams") {
#if os(iOS)
            UIApplication.shared.open(url)
#elseif os(macOS)
            
#endif
           
        }
    }
}
struct ReadingCreditsView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingCreditsView()
    }
}

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

struct ReadingCreditsView: View {
    let wikiLink = "https://en.wikipedia.org/wiki/Evangeline_Adams"
    var body: some View {
        VStack {
            Text("- Evangeline Adams").frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color.white)
            Text("with ghost writer Aleister Crowley").frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(Color.white)
            Text("Your Place in the Stars 1933").foregroundColor(Color.white)
            Button(action: openWikipediaLink) {
                Text(wikiLink)
#if os(iOS)
                    .padding()
#endif
                    .foregroundColor(Color.blue)
            }
        }.background(Color.black).padding()
    }
}

extension ReadingCreditsView {
    func openWikipediaLink()->Void {
        openLink(link: wikiLink)
        
    }
}
struct ReadingCreditsView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingCreditsView()
    }
}

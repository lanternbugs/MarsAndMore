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

struct ResourcesView: View {
    let astrologyKingAspects = "https://astrologyking.com/aspects/"
    let astrologyKingTransits = "https://astrologyking.com/transits/"
    let cafeAstrology = "https://cafeastrology.com/siteindex.html"
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("For those new to Astrological Charts and wondering what does it mean, this page hopes to offer a few resources and tips").font(.headline)
                Text("First enter a name with a birth date in chart room by tapping + button to begin.")
                Text("Planets button used with that name selected gives the signs the planets were in at birth or what is called the Natal Chart.").padding([.bottom])
                Text("Signs are shortened to first three letters so Sco is Scorpio. If it says Jupiter is in Scorpio then users can Google natal jupiter scorpio").font(.headline)
                Text("Also two sites that come up near top of Google I've noticed for general info on all aspects or transits are astrologyking.com and cafeastrology.com. MarsAndMore has no affiliation with them.")
                Text("Users can find text descriptions of Planets, Aspects and Transits that are shown in Chart Room at these three links below, versus just searching in a search engine.")
                Button(action: {
                    self.openLink(link: cafeAstrology)
                }) {
                    Text(cafeAstrology).foregroundColor(Color.blue)
                }.padding()
                Button(action: {
                    self.openLink(link: astrologyKingAspects)
                }) {
                    Text(astrologyKingAspects).foregroundColor(Color.blue)
                }.padding()
                Button(action: {
                    self.openLink(link: astrologyKingTransits)
                }) {
                    Text(astrologyKingTransits).foregroundColor(Color.blue)
                }.padding()
            }.padding([.trailing, .leading])
        }
        
    }
}

struct ResourcesView_Previews: PreviewProvider {
    static var previews: some View {
        ResourcesView()
    }
}

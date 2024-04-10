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

struct DefaultReadingContent: View {
    let defaultReadingMessage = "Pick a date and select go for an Evengeline Adams(ghostwriter Crowley) Sun, Moon, Mercury, Venus and Mars Reading"
    let defaultReadingSecondaryMessage = "When reading the planet/sign interpretations, be aware as stated by Adams, \"Of course, the usual modifications caused by aspects are always to be considered.\"."
    let defaultReadingThirdMessage =  "These interpretations were written in the 1930s. An older mindset was involved, though progressive for its time using Astrology"
    var body: some View {
        VStack(alignment: .leading) {
            Text(defaultReadingMessage)
                .padding()
            Text(defaultReadingSecondaryMessage)
                .padding(.bottom)
            Text(defaultReadingThirdMessage)
                .padding(.bottom)
            ReadingCreditsView(book: .YourPlaceStars)
        }.font(.headline)
    }
}

struct DefaultReadingContent_Previews: PreviewProvider {
    static var previews: some View {
        DefaultReadingContent()
    }
}

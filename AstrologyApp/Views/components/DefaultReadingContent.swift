//
//  DefaultReadingContent.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/6/22.
//

import SwiftUI

struct DefaultReadingContent: View {
    let defaultReadingMessage = "Pick a date and select go for an Evengeline Adams Mars and Venus Reading"
    let defaultReadingSecondaryMessage = "When reading the planet/sign interpetations, be aware as stated by Adams, \"Of course, the usual modifications caused by aspects are always to be considered.\"."
    let defaultReadingThirdMessage =  "These interpetations were written in the 1930s. An older mindset was involved, though progressive for its time using Astrology"
    var body: some View {
        VStack(alignment: .leading) {
            Text(defaultReadingMessage)
                .padding()
            Text(defaultReadingSecondaryMessage)
                .padding(.bottom)
            Text(defaultReadingThirdMessage)
                .padding(.bottom)
            ReadingCreditsView()
        }.font(.headline)
    }
}

struct DefaultReadingContent_Previews: PreviewProvider {
    static var previews: some View {
        DefaultReadingContent()
    }
}

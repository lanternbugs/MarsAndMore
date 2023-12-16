/*
*  Copyright (C) 2022-23 Michael R Adams.
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
//  Created by Michael Adams on 11/30/23.
//

import SwiftUI

struct NatalChartView: View {
    let viewModel: NatalChartViewModel
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Text(viewModel.chartName)
                    Spacer()
                }
#if os(macOS)
                NatalViewRepresentable(model: viewModel).frame(maxWidth: .infinity, idealHeight: getScreenWidth() * 0.6)
#elseif os(iOS)
                NatalViewRepresentable(model: viewModel).frame(width: getScreenWidth(), height: getScreenWidth())
#endif
                
            }
        }
    }
}

extension NatalChartView {
    func getScreenWidth()->Double
    {
#if os(macOS)
        guard let mainScreen = NSScreen.main else {
            return 200.0
        }
        return mainScreen.visibleFrame.size.width / 2.0
#elseif os(iOS)
        if UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height {
            return UIScreen.main.bounds.size.width
        }
        return UIScreen.main.bounds.size.height * 0.75
    
#endif
    
    }
}

#Preview {
    NatalChartView(viewModel: NatalChartViewModel(chartName: "mike"))
}

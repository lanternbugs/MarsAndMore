//
//  NatalChartView.swift
//  MarsAndMore
//
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
                    Text("Natal Chart")
                    Spacer()
                }
                NatalViewRepresentable(model: viewModel).frame(maxWidth: .infinity, idealHeight: getScreenWidth() * 0.6)
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
    return UIScreen.main.bounds.size.width
#endif
    
    }
}

#Preview {
    NatalChartView(viewModel: NatalChartViewModel())
}

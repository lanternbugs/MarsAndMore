/*
*  Copyright (C) 2022-24 Michael R Adams.
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
//  Created by Michael Adams on 8/4/24.
//

import Foundation
import SwiftUI
class EphemerisModel {
#if os(iOS)
    let symbolFontSize = UIDevice.current.userInterfaceIdiom == .pad ? 24.0 : 18.0
#else
    let symbolFontSize = 20.0
#endif
    var date: Date
    let calculationSettings: CalculationSettings
    @AppStorage("showEphemerisSymbols") var showEphemerisSymbols: Bool = true
    @AppStorage("showModernEphemeris")  var showModernEphemeris: Bool = true
    var numbersOfDays: Int = 30
    var showEphemerisKey: Bool = false
    
    init(date: Date, calculationSettings: CalculationSettings) {
        self.date = date
        self.calculationSettings = calculationSettings
    }
}

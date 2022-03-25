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

struct RoomStateKey: EnvironmentKey {
    static var defaultValue: Binding<RoomState> = .constant(.Chart)
}

extension EnvironmentValues {
  var roomState: Binding<RoomState> {
    get { self[RoomStateKey.self] }
    set { self[RoomStateKey.self] = newValue }
  }
}

//
//  Environment+Extensions.swift
//  MarsAndMore
//
//  Created by Michael Adams on 2/27/22.
//

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

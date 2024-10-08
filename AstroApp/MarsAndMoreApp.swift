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
#if os(macOS)
import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
#endif

@main
struct MarsAndMoreApp: App {
    let persistenceController = PersistenceController.shared
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    var body: some Scene {
        WindowGroup {
#if os(macOS)
            MainView().frame(minWidth: 720, idealWidth: 1300, maxWidth: .infinity, minHeight: 500, idealHeight: 900, maxHeight: .infinity)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
#else
            MainView().environment(\.managedObjectContext, persistenceController.container.viewContext)
#endif
        }
    }
}

//
//  MarsAndMoreApp.swift
//  Shared
//
//  Created by Michael Adams on 1/21/22.
//

import SwiftUI

@main
struct MarsAndMoreApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

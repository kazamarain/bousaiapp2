//
//  bousaiappApp.swift
//  bousaiapp
//
//  Created by ユウ・カザマ on 2023/07/26.
//

import SwiftUI

@main
struct bousaiappApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

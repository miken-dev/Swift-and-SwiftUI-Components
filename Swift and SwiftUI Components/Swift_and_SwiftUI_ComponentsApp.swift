//
//  Swift_and_SwiftUI_ComponentsApp.swift
//  Swift and SwiftUI Components
//
//  Created by Michael Neal on 7/27/24.
//

import SwiftUI
import SwiftData

@main
struct Swift_and_SwiftUI_ComponentsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

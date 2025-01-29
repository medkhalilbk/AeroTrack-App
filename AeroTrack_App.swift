//
//  AeroTrack_App.swift
//  AeroTrack_App
//
//  Created by Med Khalil Benkhelil on 10/30/24.
//
import UserNotifications
import SwiftUI

@main
struct AeroTrack_App: App {
    let persistenceController = PersistenceController.shared
    let defaults = UserDefaults.standard
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

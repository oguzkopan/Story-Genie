//
//  StoryGenieApp.swift
//  StoryGenie
//
//  Created by Oğuz Kopan on 26.07.2023.
//

import SwiftUI

@main
struct StoryGenieApp: App {
// Initialize the FavoritesViewModel and set it as an environment object
    @StateObject private var favoritesViewModel = FavoritesViewModel()

    var body: some Scene {
        WindowGroup {
            // Inject the FavoritesViewModel as an environment object for ContentView
            ContentView()
                .environmentObject(favoritesViewModel)
        }
    }
}

//
//  GourmetApp.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 11/10/24.
//

import SwiftUI

@main
struct GourmetApp: App {
    @StateObject private var authManager = AuthManager.shared
    var body: some Scene {
        WindowGroup {
            NavigationStack {  // Utilisation de NavigationStack pour gérer la navigation
                if authManager.isAuthenticated {
                    HomeView()
                } else {
                    SignInView()
                }
            }
        }
    }
}


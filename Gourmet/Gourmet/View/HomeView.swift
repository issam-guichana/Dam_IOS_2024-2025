//
//  HomeView.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 11/12/24.
//
import SwiftUI

struct HomeView: View {
    
    var body: some View {
        ZStack {
            // Dégradé en arrière-plan
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.pink.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all) // S'assure que le dégradé couvre toute la vue
            
            // Contenu principal
            TabView {
                NewsView(url: URL(string: "https://www.euronews.com/tag/recipes")!).tabItem { Label("Home", systemImage: "house") }
                MultimodalChatView().tabItem { Label("Analyze", systemImage: "magnifyingglass") }
                Text("Favorites").tabItem { Label("Favorites", systemImage: "heart") }
                SuggestionsView().tabItem { Label("Suggestions", systemImage: "lightbulb.max.fill") }
                ProfileView().tabItem { Label("Profile", systemImage: "person") }
            }
        }
    }
}

#Preview {
    HomeView()
}

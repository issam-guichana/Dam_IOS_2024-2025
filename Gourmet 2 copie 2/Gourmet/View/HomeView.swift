import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            Text("Home")
                .tabItem { Label("Home", systemImage: "house") }
            
            MultimodalChatView()
                .tabItem { Label("Analyze", systemImage: "magnifyingglass") }
            
            RecipeGeneratorView()
                .tabItem { Label("Recipes", systemImage: "book") }
            
            Text("Favorites")
                .tabItem { Label("Favorites", systemImage: "heart") }
            
            Text("Settings")
                .tabItem { Label("Settings", systemImage: "gearshape") }
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
        }
    }
}

#Preview {
    HomeView()
}


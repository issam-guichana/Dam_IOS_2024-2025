//
//  HomeView.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 11/12/24.
//
import SwiftUI
struct HomeView: View {
    var body: some View {
        TabView {
            Text("Home").tabItem { Label("Home", systemImage: "house") }
            Text("Search").tabItem { Label("Search", systemImage: "magnifyingglass") }
            Text("Favorites").tabItem { Label("Favorites", systemImage: "heart") }
            Text("Settings").tabItem { Label("Settings", systemImage: "gearshape") }
            ProfileView().tabItem { Label("Profile", systemImage: "person") }
        }
    }
}


#Preview {
    HomeView()
}

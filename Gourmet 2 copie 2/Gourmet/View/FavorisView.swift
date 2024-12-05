//
//  FavorisView.swift
//  Gourmet
//
//  Created by Nawel kaabi on 22/11/2024.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var favorites: [String: Any] // Binding pour récupérer la liste des favoris
    
    var body: some View {
        VStack {
            Text("Mes Favoris")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Afficher les favoris
            if !favorites.isEmpty {
                List(favorites.keys.sorted(), id: \.self) { key in
                    VStack(alignment: .leading) {
                        Text(key)
                            .font(.headline)
                        Text("\(favorites[key] ?? "")")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            } else {
                Text("Aucun favori enregistré.")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

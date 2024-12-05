//
//  RecipeGeneratorView.swift
//  Gourmet
//
//  Created by Nawel kaabi on 3/12/2024.
//
import SwiftUI

struct RecipeGeneratorView: View {
    @State private var ingredients = ""
    @State private var diet = ""
    @State private var recipes: [String: Any]?
    @State private var favorites: [String: Any] = [:] // Liste des recettes favorites
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Générateur de Recettes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 20)
                
                Spacer()
                
                // Champs pour les ingrédients et régime
                VStack(alignment: .leading) {
                    Text("Ingrédients")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 5)
                    TextField("Ex: pommes, carottes, crème", text: $ingredients)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    Text("Régime alimentaire")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 5)
                    TextField("Ex: vegan, végétarien", text: $diet)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Bouton pour générer des recettes
                Button(action: {
                    RecipeService().fetchRecipes(ingredients: ingredients, diet: diet) { result in
                        switch result {
                        case .success(let data):
                            DispatchQueue.main.async {
                                self.recipes = data
                            }
                        case .failure(let error):
                            print("Erreur: \(error)")
                        }
                    }
                }) {
                    Text("Générer des recettes")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.pink)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Affichage des recettes générées
                if let recipes = recipes {
                    Text("Recettes générées")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(recipes.keys.sorted(), id: \.self) { key in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(key)
                                            .font(.headline)
                                        
                                        Spacer()
                                        
                                        // Ajout aux favoris
                                        Button(action: {
                                            if favorites[key] == nil {
                                                favorites[key] = recipes[key] // Ajouter à la liste des favoris
                                            }
                                        }) {
                                            Image(systemName: favorites[key] == nil ? "heart" : "heart.fill")
                                                .foregroundColor(.pink)
                                        }
                                    }
                                    Text("\(recipes[key] ?? "")")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                            }
                        }
                    }
                } else {
                    Text("Aucune recette générée pour le moment.")
                        .foregroundColor(.secondary)
                        .italic()
                        .padding()
                }
                
                Spacer()
                
                // Navigation vers les favoris
                NavigationLink(destination: FavoritesView(favorites: $favorites)) { // Passez $favorites
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.white)
                        Text("Voir les Favoris")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Recettes AI")
            .background(Color(UIColor.systemBackground))
        }
    }
}

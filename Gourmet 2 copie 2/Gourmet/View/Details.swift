//
//  Details.swift
//  Gourmet
//
//  Created by Nawel kaabi on 22/11/2024.
//

import SwiftUI

struct RecipeDetailView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image ronde de la recette
                Image("pasta")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                    .shadow(radius: 8)
                    .padding(.top)
                    .frame(maxWidth: .infinity) // Centre l'image
                
                // Titre et détails
                VStack(alignment: .center, spacing: 8) {
                    Text("Risotto de Pâtes")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 20) {
                        Label("4 pers.", systemImage: "person.3")
                        Label("30 min", systemImage: "clock")
                        Label("0 min", systemImage: "flame")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity) // Centre le texte
                
                Divider()
                
                // Section Ingrédients
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ingrédients")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.pink) // Titre en rose
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("- Viandes : 300 g de poulet haché")
                        Text("- Fruits et légumes : 2 courgettes, 2 gousses d'ail")
                        Text("- Conserves : 500 ml de bouillon")
                        Text("- Condiments : 1 cuillère d'huile d'olive")
                        Text("- Produits laitiers : 50 g de parmesan râpé")
                    }
                    .font(.body)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                Divider()
                
                // Section Préparation
                VStack(alignment: .leading, spacing: 12) {
                    Text("Préparation")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.pink) // Titre en rose
                    
                    // Sous-ScrollView pour la préparation
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("1. Couper les courgettes en petits dés et les faire revenir dans un filet d'huile d'olive avec les gousses d'ail hachées.")
                            Text("2. Ajouter le poulet haché et faire cuire jusqu'à ce qu'il soit doré.")
                            Text("3. Verser le bouillon et laisser mijoter jusqu'à absorption complète.")
                            Text("4. Incorporer le parmesan râpé hors du feu pour plus d'onctuosité.")
                            Text("5. Servir chaud et déguster !")
                        }
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(5)
                    }
                    .frame(height: 160)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Recette")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    NavigationLink(destination:  ShareRecipeView()) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                    // NavigationLink(destination: //FavoritesView(favorites: <#[String : Any]#>)) {
                    //  Image(systemName: "heart")
                }
            }
        }
    }
    //  .background(Color(.systemGroupedBackground))
    //}
    //}
    
    
    
    struct RecipeDetailView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                RecipeDetailView()
            }
        }
    }
}

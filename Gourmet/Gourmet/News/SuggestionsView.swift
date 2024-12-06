//
//  NewsView.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 12/5/24.
//

import SwiftUI

struct SuggestionsView: View {
    @State private var recipes: [Recipe] = []
    
    var body: some View {
        NavigationView {
            List(recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    HStack {
                        if let thumb = recipe.strMealThumb, let url = URL(string: thumb) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            } placeholder: {
                                Color.gray
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(recipe.strMeal)
                                .font(.headline)
                            if let category = recipe.strCategory {
                                Text(category)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Suggestions recipes")
            .onAppear(perform: fetchRecipes)
        }
    }
    
    func fetchRecipes() {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.recipes = decodedResponse.meals ?? []
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}

struct RecipeResponse: Codable {
    let meals: [Recipe]?
}

struct Recipe: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strInstructions: String?
    let strMealThumb: String?
    let strSource: String? // Lien vers les instructions détaillées
    
    var id: String { idMeal } // Identifiable requirement
}



#Preview {
    SuggestionsView()
}

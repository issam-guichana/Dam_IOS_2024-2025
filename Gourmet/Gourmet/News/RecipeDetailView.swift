//
//  RecipeDetailView.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 12/5/24.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let thumb = recipe.strMealThumb, let url = URL(string: thumb) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 200)
                    .clipped()
                }
                
                Text(recipe.strMeal)
                    .font(.largeTitle)
                    .bold()
                
                if let category = recipe.strCategory {
                    Text("Category: \(category)")
                        .font(.headline)
                }
                
                if let instructions = recipe.strInstructions {
                    Text("Instructions")
                        .font(.title2)
                        .padding(.top)
                    Text(instructions)
                        .font(.body)
                        .padding(.top, 5)
                }
                
               
            }
            .padding()
        }
        .navigationTitle(recipe.strMeal)
        .navigationBarTitleDisplayMode(.inline)
    }
}

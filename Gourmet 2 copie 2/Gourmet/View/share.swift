//
//  share.swift
//  Gourmet
//
//  Created by Nawel kaabi on 27/11/2024.
//

import SwiftUI

struct ShareRecipeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Recipe Post Section
                    RecipePostView(
                        username: "chefdelicious",
                        time: "3h ago",
                        title: "Delicious Pasta Recipe Appreciation Post",
                        content: "This creamy garlic pasta recipe is easy to make and absolutely delicious. Perfect for a quick dinner or a family gathering. Pair it with a fresh salad for the best experience!",
                        likes: 719,
                        comments: 16
                    )
                    
                    Divider()
                    
                    // Comment Section
                    CommentView(
                        username: "foodlover123",
                        time: "3h ago",
                        comment: "I tried this recipe, and it’s amazing! The garlic flavor is so rich, and it’s super easy to make."
                    )
                    
                    CommentView(
                        username: "pastaqueen",
                        time: "3h ago",
                        comment: "I added some mushrooms to it, and it turned out fantastic. Highly recommend!"
                    )
                }
                .padding()
                .navigationTitle("Recipes")
            }
        }
    }
}

struct RecipePostView: View {
    let username: String
    let time: String
    let title: String
    let content: String
    let likes: Int
    let comments: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(username)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
            
            Image("pasta")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(8)
                .clipped()
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(.red)
                    Text("\(likes)")
                        .font(.subheadline)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "bubble.right.fill")
                        .foregroundColor(.blue)
                    Text("\(comments)")
                        .font(.subheadline)
                }
            }
            .padding(.top, 8)
        }
    }
}

struct CommentView: View {
    let username: String
    let time: String
    let comment: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(username)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Text(comment)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
     ShareRecipeView()
    }
}

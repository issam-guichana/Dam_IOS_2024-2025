//
//  UserModel.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 11/10/24.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let name: String
    let email: String
    // Ajoute d'autres attributs si nécessaire
}

struct AuthResponse: Codable {
    let token: String
    let user: UserModel
}

struct RecipeResponse: Decodable {
    let title: String
    let ingredients: [String]
    let instructions: String
}
 

//
//  UserModel.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 11/10/24.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let username: String
    let email: String
    // Ajoute d'autres attributs si nécessaire
    init(id: String, username: String, email: String) {
        self.id = id
        self.username = username
        self.email = email
    }
}

struct AuthResponse: Codable {
    let token: String
    let user: UserModel
}

enum VerificationType {
    case login
    case resetPassword
    case changePassword
}

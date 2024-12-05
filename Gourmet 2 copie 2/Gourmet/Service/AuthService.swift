//
//  AuthService.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 11/10/24.
//

import Foundation

class AuthService {
    private let baseURL = "http://localhost:3001"

    
    func signIn(username: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
  
    }
    
    func signUp(username: String, email: String, password: String,confirmPassword: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
    }
}

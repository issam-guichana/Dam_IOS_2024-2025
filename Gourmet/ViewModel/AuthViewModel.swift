//
//  AuthViewModel.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 11/10/24.
//
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isSignedIn: Bool = false // Pour gérer l'état de la connexion
    @Published var profile: UserModel? // Objet pour stocker les infos de profil

    private let baseURL = "http://localhost:3000"
    func areCredentialsValid() -> Bool {
           return !username.isEmpty && !email.isEmpty && !password.isEmpty
       }
    // Méthode d'inscription
    func signUp() {
        guard let url = URL(string: "\(baseURL)/auth/signup") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "name": username,
            "email": email,
            "password": password
        ]
        print(body)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            print(data,response)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Utilisateur créé, récupérer les infos de profil
                DispatchQueue.main.async {
                    self?.isSignedIn = true
                    self?.fetchProfile()
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error signing up"
                }
            }
        }.resume()
    }
    
    func ForgotPassword() {
        guard let url = URL(string: "\(baseURL)/auth/forgot-password") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
          //  "password": password
        ]
        print(body)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Utilisateur créé, récupérer les infos de profil
                DispatchQueue.main.async {
                    self?.isSignedIn = true
                    self?.fetchProfile()
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error signing up"
                }
            }
        }.resume()
    }
    
    
    
    func signin() {
        guard let url = URL(string: "\(baseURL)/auth/signin") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        print(body)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Utilisateur créé, récupérer les infos de profil
                DispatchQueue.main.async {
                    self?.isSignedIn = true
                    self?.fetchProfile()
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error signing in"
                }
            }
        }.resume()
    }
    // Méthode pour récupérer le profil
    func fetchProfile() {
        let accessToken = ""
        guard let url = URL(string: "\(baseURL)/auth/profile") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            let profile = try? JSONDecoder().decode(UserModel.self, from: data)
            DispatchQueue.main.async {
                self?.profile = profile
            }
        }.resume()
    }
}

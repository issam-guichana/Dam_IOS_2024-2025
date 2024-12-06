//
//  AuthViewModel.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 11/10/24.
//
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false // Pour gérer l'état de la connexion
    @Published var isSignedUp: Bool = false
    @Published var profile: UserModel? // Objet pour stocker les infos de profil
    @Published var OTPCode : String = ""
    @Published var newPassword: String = ""
    @Published var isOTPValid: Bool = false
    @Published var navigateToHome: Bool = false
    @Published var navigateToResetPassword: Bool = false
    @Published var navigateToChangePassword: Bool = false
    @Published var isEditingUser: Bool = false
    @Published var isSignedOutUser: Bool = false

    struct AuthDataModel: Codable {
        let accessToken: String
        let refreshToken: String
        let userId: String
    }
    
    private let baseURL = "http://localhost:3000"
    func areCredentialsValid() -> Bool {
           return !username.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    func signUp() {
        guard let url = URL(string: "\(baseURL)/auth/signup") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "username": username,
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
                    self?.isSignedUp = true
                   // self?.fetchProfile()
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error signing up"
                }
            }
        }.resume()
    }
    
    func verifyOTP (){
        if OTPCode == "" {
            
        } else {
            
            guard let url = URL(string: "\(baseURL)/auth/verify-email") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "email": email,
                "otp": OTPCode,
              //  "password": password
            ]
            print(body)
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    // Utilisateur créé, récupérer les infos de profil
                    DispatchQueue.main.async {
                        self?.isOTPValid = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error signing up"
                    }
                }
            }.resume()
        }
    }
    
    func verifyEmail() {
        guard let url = URL(string: "\(baseURL)/auth/generate-email") else { return }
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
                
                  //  self?.fetchProfile()
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error signing up"
                }
            }
        }.resume()
    }
    
    
    func resetPassword() {
        guard let url = URL(string: "\(baseURL)/auth/forgot-password") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": newPassword
          //  "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Utilisateur créé, récupérer les infos de profil
                DispatchQueue.main.async {
                  //  self?.fetchProfile()
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
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                do {
                    let data = try JSONDecoder().decode(AuthDataModel.self, from: data!)
//                    let data = try JSONSerialization.jsonObject(with:  data!)
                    DispatchQueue.main.async {
                        AuthManager.shared.saveTokens(accessToken: data.accessToken, refreshToken: data.refreshToken, userId: data.userId)
                    }
                    print("\(data)")
                } catch  {
                    
                }
              
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                  //  self?.fetchProfile()
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error signing in"
                }
            }
        }.resume()
    }
    func fetchProfile() {
        let userId = AuthManager.shared.getUserId()
        guard let userId = userId, let url = URL(string: "\(baseURL)/user/userId/\(userId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                if let profile = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let username = profile["username"] as? String,
                   let email = profile["email"] as? String {
                    let userModel = UserModel(id: profile["_id"] as! String, username: username, email: email)
                    
                    DispatchQueue.main.async {
                        self.profile = userModel
                        // Ne modifiez PAS isEditingUser ici
                    }
                }
            } catch {
                print("Error decoding profile: \(error)")
            }
        }.resume()
    }
    
    func updateUser(username: String, email: String, oldPassword: String, newPassword: String) {
        let userId = AuthManager.shared.getUserId()
        guard let url = URL(string: "\(baseURL)/user/\(userId!)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(AuthManager.shared.getAccessToken() ?? "")", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "username": username,
            "email": email,
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.fetchProfile() // Recharge le profil après la mise à jour
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error updating profile."
                }
            }
        }.resume()
    }


    
    func deleteUser() {
        let userId = AuthManager.shared.getUserId()
        guard let url = URL(string: "\(baseURL)/user/\(userId!)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "Delete"
        request.setValue("Bearer \(AuthManager.shared.getAccessToken() ?? "")", forHTTPHeaderField: "Authorization")
                
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return  }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    AuthManager.shared.clearTokens() // Recharge le profil après la mise à jour
                    self.isSignedOutUser = true
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error deleting profile."
                }
            }
        }.resume()
    }
    
    @Published var imageAnalysisResult: String = ""

        // Fonction pour envoyer une image au backend pour analyse
        func analyzeImage(imageData: Data) {
            guard let url = URL(string: "\(baseURL)/image/upload") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

            URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Échec de l'envoi de l'image"
                    }
                    return
                }
                if let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let message = result["message"] as? String {
                           DispatchQueue.main.async {
                               self.imageAnalysisResult = message
                               self.errorMessage = nil
                           }
                       } else {
                           DispatchQueue.main.async {
                               self.errorMessage = "Erreur lors de l'analyse de l'image"
                           }
                       }
            }.resume()
        }
}

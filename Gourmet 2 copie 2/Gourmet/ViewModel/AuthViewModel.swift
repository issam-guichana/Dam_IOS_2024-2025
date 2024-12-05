    //
    //  AuthViewModel.swift
    //  Gourmet
    //
    //  Created by Ala Din Habibi on 11/10/24.
    //
    import SwiftUI

    class AuthViewModel: ObservableObject {
        @Published var name: String = ""
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var confirmPassword: String = ""
        @Published var userId: String?
        @Published var errorMessage: String?
        @Published var isSignedIn: Bool = false // Pour gérer l'état de la connexion
        @Published var profile: UserModel?
        
        
       
        
        @Published var profileLoadingError: String?

        private let baseURL = "http://localhost:3001"
        func areCredentialsValid() -> Bool {
               return !name.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
           }
        // Méthode d'inscription
        func signUp() {
            guard let url = URL(string: "\(baseURL)/auth/signup") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "name": name,
                "email": email,
                "password": password,
                "confirmPassword": confirmPassword
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
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error signing up"
                    }
                }
            }.resume()
        }
        
        func ForgotPassword(email: String, completion: @escaping (Bool, String?) -> Void) {
            guard let url = URL(string: "\(baseURL)/auth/forgot-password") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = ["email": email]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    print("Request failed: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse,
                   (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
                    if let data = data {
                        do {
                            let responseObject = try JSONDecoder().decode(ForgotPasswordResponse.self, from: data)
                            DispatchQueue.main.async {
                                // Save the userId for later use
                                self?.userId = responseObject.userId
                                completion(true, responseObject.userId)
                            }
                        } catch {
                            print("Failed to decode response: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                completion(false, nil)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(false, nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                }
            }.resume()
        }

        // Define a struct for decoding the response
        struct ForgotPasswordResponse: Codable {
            let message: String
            let userId: String
        }



        
        
        
        func signin(completion: @escaping (Bool) -> Void) {
            guard let url = URL(string: "\(baseURL)/auth/login") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "email": email,
                "password": password
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    DispatchQueue.main.async {
                        self?.isSignedIn = true
                       
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error signing in"
                        completion(false)
                    }
                }
            }.resume()
        }
        

        func fetchProfile(userId: String, completion: @escaping (Bool) -> Void) {
                guard !userId.isEmpty else {
                    profileLoadingError = "Invalid User ID"
                    completion(false)
                    return
                }
                
                guard let url = URL(string: "\(baseURL)/user/\(userId)") else {
                    profileLoadingError = "Invalid URL"
                    completion(false)
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                
                URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.profileLoadingError = "Network Error: \(error.localizedDescription)"
                            completion(false)
                        }
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode),
                          let data = data else {
                        DispatchQueue.main.async {
                            self?.profileLoadingError = "Server Error: Unable to fetch profile"
                            completion(false)
                        }
                        return
                    }
                    
                    do {
                        let profile = try JSONDecoder().decode(UserModel.self, from: data)
                        DispatchQueue.main.async {
                            self?.profile = profile
                            self?.name = profile.name
                            self?.email = profile.email
                            self?.profileLoadingError = nil
                            completion(true)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self?.profileLoadingError = "Decoding Error: \(error.localizedDescription)"
                            completion(false)
                        }
                    }
                }.resume()
            }
    }

class RecipeService {
    func fetchRecipes(ingredients: String, diet: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3001/recipes") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "ingredients": ingredients,
            "diet": diet
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

class FavoriteService: ObservableObject {
    @Published var favorites: [Favorite] = []
    
    private let baseURL = "http://localhost:3001/favorites" // Changez cette URL avec votre API
    
    // Récupérer les favoris
    func fetchFavorites() {
        guard let url = URL(string: baseURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedFavorites = try? JSONDecoder().decode([Favorite].self, from: data) {
                    DispatchQueue.main.async {
                        self.favorites = decodedFavorites
                    }
                }
            }
        }
        
        task.resume()
    }
    
    // Ajouter un favori
    func addFavorite(title: String, description: String) {
        guard let url = URL(string: baseURL) else { return }
        
        let favorite = Favorite(id: UUID().uuidString, title: title, description: description)
        
        guard let encoded = try? JSONEncoder().encode(favorite) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encoded
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if data != nil {
                self.fetchFavorites() // Recharger les favoris après ajout
            }
        }
        
        task.resume()
    }
}
            // ... other methods remain the same
        

        // UserModel definition
struct userModel: Codable {
    let name: String
    let email: String
    // Add any additional fields from your backend
    
}

struct Favorite: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
}

import SwiftUI

struct ResetPasswordView: View {
    var userId: String // Add userId parameter
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToSignIn = false // Navigation state for SignInView
    
    private let baseURL = "http://localhost:3001"

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Lock Icon
                Image(systemName: "lock.rotation")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.pink)
                    .padding(.bottom, 20)
                
                // Title
                Text("Reset Password")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .padding(.bottom, 20)
                
                // New Password Field
                SecureField("New password", text: $newPassword)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                // Confirm Password Field
                SecureField("Confirm new password", text: $confirmPassword)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                // Submit Button
                Button(action: {
                    resetPassword()
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Navigation to SignInView
                NavigationLink(
                    destination: SignInView(),
                    isActive: $navigateToSignIn
                ) { EmptyView() }
            }
            .background(Color.white)
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Password Reset"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarHidden(true)
    }
    
    func resetPassword() {
        // Validate passwords match
        guard newPassword == confirmPassword else {
            alertMessage = "Passwords do not match. Please try again."
            isShowingAlert = true
            return
        }
        
        // Validate password strength (optional but recommended)
        guard newPassword.count >= 6 else {
            alertMessage = "Password must be at least 6 characters long."
            isShowingAlert = true
            return
        }
        
        // Construct the URL
        guard let url = URL(string: "\(baseURL)/auth/reset-password/\(userId)") else {
            alertMessage = "Invalid URL"
            isShowingAlert = true
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the body
        let body: [String: String] = [
            "password": newPassword,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for network errors
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Network error: \(error.localizedDescription)"
                    self.isShowingAlert = true
                }
                return
            }
            
            // Check HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.alertMessage = "Invalid response from server"
                    self.isShowingAlert = true
                }
                return
            }
            
            // Handle different response scenarios
            switch httpResponse.statusCode {
            case 201:
                // Password Reset Successfully
                DispatchQueue.main.async {
                    self.alertMessage = "Password has been reset successfully."
                    self.isShowingAlert = true
                    self.navigateToSignIn = true
                }
            case 400:
                // Bad Request (Invalid Input)
                DispatchQueue.main.async {
                    self.alertMessage = "Invalid input. Please check your password."
                    self.isShowingAlert = true
                }
            case 404:
                // User Not Found
                DispatchQueue.main.async {
                    self.alertMessage = "User not found. Please try again."
                    self.isShowingAlert = true
                }
            default:
                // Unknown error
                DispatchQueue.main.async {
                    self.alertMessage = "An unexpected error occurred."
                    self.isShowingAlert = true
                }
            }
        }.resume()
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(userId: "6745dcd7f854604f7231cb40") // Pass a sample userId
    }
}

import SwiftUI

struct EditUserView: View {
    @State private var username: String = ""
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isShowingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        
        ZStack {
            
            
            // Dégradé en arrière-plan
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.brown]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Edit Profile")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                // Modifier le nom d'utilisateur
                TextField("New Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                
                // Réinitialiser le mot de passe
                SecureField("Old Password", text: $oldPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                
                SecureField("New Password", text: $newPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                
                SecureField("Confirm New Password", text: $confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)

                Button("Save Changes") {
                    if newPassword == confirmPassword {
                        alertMessage = "Profile updated successfully."
                    } else {
                        alertMessage = "New passwords do not match."
                    }
                    isShowingAlert = true
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
            }
            .padding()
        
            .cornerRadius(10)
            .padding()
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Update Status"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    EditUserView()
}